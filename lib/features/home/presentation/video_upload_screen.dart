import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stevenako_flutter/features/home/model/get_soudn_modle.dart';
import 'package:stevenako_flutter/features/home/presentation/sound_track_screeen.dart';
import 'package:stevenako_flutter/features/home/presentation/upload_post_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoUploadScreen extends StatefulWidget {
  final String tap;
  const VideoUploadScreen({super.key, required this.tap});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final String _previewImagePath = 'assets/images/preview_placeholder.jpg';

  File? _pickedVideo;
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;

  bool _isPicking = false;
  bool _isVideoInitialized = false;
  bool _isProcessingAudio = false;

  int? _selectedSoundId;
  Sound? _selectedSound;

  bool get _isVideoMode => widget.tap == 'Upload Video';

  String get _continueLabel {
    if (_isVideoMode) {
      return _pickedVideo == null ? 'Upload Video' : 'Continue';
    }
    return 'Continue';
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (_isVideoMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickVideo());
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        await _initializeVideo(File(video.path));
      }
    } catch (e) {
      debugPrint('Video pick error: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _initializeVideo(File file) async {
    await _videoController?.dispose();
    setState(() {
      _isVideoInitialized = false;
      _pickedVideo = file;
    });

    final controller = VideoPlayerController.file(file);
    _videoController = controller;

    try {
      await controller.initialize();
      controller.setLooping(true);
      if (!mounted) return;
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      debugPrint('Video init error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load video')),
      );
    }
  }

  void _togglePlayPause() {
    final controller = _videoController;
    if (controller == null || !_isVideoInitialized) return;

    if (controller.value.isPlaying) {
      controller.pause();
      _audioPlayer?.pause();
    } else {
      controller.play();
      if (_selectedSound?.audioUrl != null &&
          _selectedSound!.audioUrl!.isNotEmpty) {
        _audioPlayer?.play(UrlSource(_selectedSound!.audioUrl!));
      }
    }
    setState(() {});
  }

  void _onClose() {
    _audioPlayer?.stop();
    Navigator.of(context).maybePop();
  }

  Future<void> _onMusicTap() async {
    final result = await Get.to(() => const SoundTrackScreeen());
    if (result != null && mounted) {
      if (result is Sound) {
        setState(() {
          _selectedSound = result;
          _selectedSoundId = result.id;
        });
        if (result.audioUrl != null && result.audioUrl!.isNotEmpty) {
          _audioPlayer?.play(UrlSource(result.audioUrl!));
        }
      } else if (result is int) {
        setState(() {
          _selectedSoundId = result;
        });
      }
    }
  }

  Future<void> _onTrimTap() async {
    if (_pickedVideo == null) return;

    // Pause preview while trimming
    _videoController?.pause();
    _audioPlayer?.pause();

    final trimmedFile = await Navigator.of(context).push<File>(
      MaterialPageRoute(
        builder: (_) => TrimmerScreen(file: _pickedVideo!),
      ),
    );

    if (trimmedFile != null) {
      await _initializeVideo(trimmedFile);
    }
  }

  /// Merges audio into video file using FFmpegKit
  Future<File?> _mergeAudioWithVideo(File videoFile, String audioUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final String tempAudioPath =
          '${tempDir.path}/temp_sound_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final String outputPath =
          '${tempDir.path}/merged_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // 1. Download audio file from audioUrl
      final dio = Dio();
      await dio.download(audioUrl, tempAudioPath);

      final audioFile = File(tempAudioPath);
      if (!await audioFile.exists()) {
        return videoFile;
      }

      // 2. FFmpeg command: replace/mix audio with video
      // -y -i video.mp4 -i audio.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest output.mp4
      final String ffmpegCmd =
          '-y -i "${videoFile.path}" -i "$tempAudioPath" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest "$outputPath"';

      final session = await FFmpegKit.execute(ffmpegCmd);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final outputFile = File(outputPath);
        if (await outputFile.exists()) {
          return outputFile;
        }
      } else {
        debugPrint('FFmpeg processing failed with return code: $returnCode');
      }
    } catch (e, stack) {
      debugPrint('Error merging audio into video: $e\n$stack');
    }
    return videoFile;
  }

  Future<void> _onContinue() async {
    if (_isVideoMode && _pickedVideo == null) {
      _pickVideo();
      return;
    }

    File finalVideoFile = _pickedVideo!;

    // If a music track was selected, merge audio into video file using FFmpegKit
    if (_selectedSound?.audioUrl != null &&
        _selectedSound!.audioUrl!.isNotEmpty) {
      setState(() => _isProcessingAudio = true);

      final mergedFile = await _mergeAudioWithVideo(
        _pickedVideo!,
        _selectedSound!.audioUrl!,
      );

      if (mergedFile != null) {
        finalVideoFile = mergedFile;
      }

      if (mounted) {
        setState(() => _isProcessingAudio = false);
      }
    }

    _audioPlayer?.stop();
    _videoController?.pause();

    Get.to(() => UploadPostScreen(
          videoFile: finalVideoFile,
          soundId: _selectedSoundId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: _pickedVideo != null
                ? _buildVideoPreview()
                : Image.asset(
                    _previewImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFF2A2A2A));
                    },
                  ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.black.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CircleIconButton(
                        icon: Icons.close,
                        onTap: _onClose,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0.sp),
                          child: Text(
                            _isVideoMode ? 'Upload Video' : 'Preview',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (_pickedVideo != null)
                        _CircleIconButton(
                          icon: Icons.refresh,
                          onTap: _pickVideo,
                        )
                      else
                        SizedBox(width: 44.w),
                    ],
                  ),
                ),

                if (_selectedSound != null) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0xFF9F75FF).withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: Color(0xFF9F75FF),
                          size: 16,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            '${_selectedSound?.title ?? ''} • ${_selectedSound?.artist ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            _audioPlayer?.stop();
                            setState(() {
                              _selectedSound = null;
                              _selectedSoundId = null;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 16.h),

                Padding(
                  padding: EdgeInsets.only(right: 16.0.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _PillButton(
                          label: _selectedSound != null ? 'Music ✓' : 'Music',
                          imagePath: 'assets/images/soudn.png',
                          onTap: _onMusicTap,
                        ),
                        SizedBox(height: 14.h),
                        _PillButton(
                          label: 'Trim',
                          imagePath: 'assets/images/treim.png',
                          onTap: _onTrimTap,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _ContinueButton(
                    label: _continueLabel,
                    onTap: _onContinue,
                  ),
                ),
              ],
            ),
          ),

          // Processing indicator overlay when FFmpeg merges audio
          if (_isProcessingAudio)
            Container(
              color: Colors.black.withValues(alpha: 0.75),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 16,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Adding music to video...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    final controller = _videoController;

    if (controller == null || !_isVideoInitialized) {
      return const Center(
        child: CupertinoActivityIndicator(
          color: Colors.white,
          radius: 14,
        ),
      );
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          if (!controller.value.isPlaying)
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.4),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.35),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  height: 18.h,
                  width: 18.w,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.audiotrack, color: Colors.white, size: 16),
                ),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ContinueButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF9F75FF), Color(0xFF7C3AED)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30.r),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrimmerScreen extends StatefulWidget {
  final File file;
  const TrimmerScreen({super.key, required this.file});

  @override
  State<TrimmerScreen> createState() => _TrimmerScreenState();
}

class _TrimmerScreenState extends State<TrimmerScreen> {
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  void _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        if (!mounted) return;
        setState(() {
          _progressVisibility = false;
        });
        if (outputPath != null) {
          Navigator.of(context).pop(File(outputPath));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Trim Video', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _progressVisibility ? null : _saveVideo,
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: _progressVisibility,
                child: const CupertinoActivityIndicator(color: Colors.white),
              ),
              Expanded(
                child: VideoViewer(trimmer: _trimmer),
              ),
              Center(
                child: TrimViewer(
                  trimmer: _trimmer,
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width,
                  maxVideoLength: const Duration(seconds: 120),
                  onChangeStart: (value) => _startValue = value,
                  onChangeEnd: (value) => _endValue = value,
                  onChangePlaybackState: (value) =>
                      setState(() => _isPlaying = value),
                ),
              ),
              TextButton(
                child: _isPlaying
                    ? const Icon(Icons.pause, size: 36.0, color: Colors.white)
                    : const Icon(Icons.play_arrow, size: 36.0, color: Colors.white),
                onPressed: () async {
                  final playbackState = await _trimmer.videoPlaybackControl(
                    startValue: _startValue,
                    endValue: _endValue,
                  );
                  setState(() => _isPlaying = playbackState);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}