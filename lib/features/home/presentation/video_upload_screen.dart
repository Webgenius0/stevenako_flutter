import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stevenako_flutter/features/home/presentation/sound_track_screeen.dart';
import 'package:stevenako_flutter/features/home/presentation/upload_post_screen.dart';
import 'package:video_player/video_player.dart';

import 'package:video_trimmer/video_trimmer.dart';

import 'package:get/get.dart';

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
  bool _isPicking = false;
  bool _isVideoInitialized = false;

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
    if (_isVideoMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickVideo());
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
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
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  void _onClose() {
    Navigator.of(context).maybePop();
  }

  void _onMusicTap() {
    Get.to(() => SoundTrackScreeen());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music tapped'), duration: Duration(milliseconds: 800)),
    );
  }

  Future<void> _onTrimTap() async {
    if (_pickedVideo == null) return;

    // Pause preview while trimming
    _videoController?.pause();

    final trimmedFile = await Navigator.of(context).push<File>(
      MaterialPageRoute(
        builder: (_) => TrimmerScreen(file: _pickedVideo!),
      ),
    );

    if (trimmedFile != null) {
      await _initializeVideo(trimmedFile);
    }
  }

  void _onContinue() {
    if (_isVideoMode && _pickedVideo == null) {
      _pickVideo();
      return;
    }
    // TODO: proceed to next step (caption / post details screen, upload, etc.)
    Get.to(UploadPostScreen());
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
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.0),
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
                      Colors.black.withOpacity(0.45),
                      Colors.black.withOpacity(0.0),
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
                          padding:   EdgeInsets.only(top: 10.0.sp),
                          child: Text(
                            _isVideoMode ? 'Upload Video' : 'Preview',
                            textAlign: TextAlign.center,
                            style:   TextStyle(
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

                  SizedBox(height: 16.h),

                Padding(
                  padding:   EdgeInsets.only(right: 16.0.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _PillButton(
                          label: 'Music',
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
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (!_isVideoInitialized || _videoController == null) {
      return Container(
        color: const Color(0xFF2A2A2A),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white70),
      );
    }

    final controller = _videoController!;

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
          AnimatedOpacity(
            opacity: controller.value.isPlaying ? 0.0 : 1.0,
            duration:   Duration(milliseconds: 200),
            child: Center(
              child: Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child:   Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Reusable pieces
// ============================================================

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.28),
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          height: 48.h,
          padding:   EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.32),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style:   TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
                SizedBox(width: 10.w),
              Image.asset(
                imagePath,
                width: 18.w,
                height: 18.h,
                color: Colors.white, // Remove if you don't want tint
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _ContinueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ContinueButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          width: double.infinity,
          height: 54.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF7C3AED),
                Color(0xFF6D28D9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            label,
            style:   TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  Future<void> _saveTrimmedVideo() async {
    setState(() => _isSaving = true);

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (String? outputPath) {
        if (!mounted) return;
        setState(() => _isSaving = false);

        if (outputPath != null) {
          Navigator.of(context).pop(File(outputPath));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trim failed, try again')),
          );
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
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          _isSaving
              ?   Padding(
            padding: EdgeInsets.all(16.0.sp),
            child: SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          )
              : TextButton(
            onPressed: _saveTrimmedVideo,
            child:   Text(
              'Save',
              style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16.sp),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: VideoViewer(trimmer: _trimmer),
            ),
            const SizedBox(height: 20),
            TrimViewer(
              trimmer: _trimmer,
              viewerHeight: 50.0,
              viewerWidth: MediaQuery.of(context).size.width,
              maxVideoLength: const Duration(seconds: 60),
              onChangeStart: (value) => _startValue = value,
              onChangeEnd: (value) => _endValue = value,
              onChangePlaybackState: (value) => setState(() => _isPlaying = value),
            ),
              SizedBox(height: 20.h),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 60.sp,
                color: Colors.white,
              ),
              onPressed: () async {
                bool playbackState = await _trimmer.videoPlaybackControl(
                  startValue: _startValue,
                  endValue: _endValue,
                );
                if (!mounted) return;
                setState(() => _isPlaying = playbackState);
              },
            ),
              SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}