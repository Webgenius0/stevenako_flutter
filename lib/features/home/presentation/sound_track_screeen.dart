import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/features/home/data/rx_get_soudn_api/rx.dart';
import 'package:stevenako_flutter/features/home/model/get_soudn_modle.dart';
import 'package:stevenako_flutter/helpers/toast.dart';

class SoundTrackScreeen extends StatefulWidget {
  final String soundTitle;
  final String artistName;
  final String coverImageUrl;
  final int postCount;

  const SoundTrackScreeen({
    super.key,
    this.soundTitle = 'Original Sound',
    this.artistName = 'Artist Name',
    this.coverImageUrl =
        'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400',
    this.postCount = 0,
  });

  @override
  State<SoundTrackScreeen> createState() => _SoundTrackScreeenState();
}

class _SoundTrackScreeenState extends State<SoundTrackScreeen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _hintColor = Color(0xFF9C9AAB);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);

  late final GetSoundRx _getSoundRxObj;

  // Audio Preview Player
  late final AudioPlayer _audioPlayer;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<void>? _completeSub;

  Sound? _previewingSound;
  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Search & Selection
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Sound? _selectedSound;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();

    _getSoundRxObj = GetSoundRx(
      empty: GetuserModel(
        success: false,
        code: 0,
        message: "",
        data: null,
      ),
      dataFetcher: BehaviorSubject<GetuserModel>(),
    );
    _getSoundRxObj.fetchSounds();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.playing) {
          _isBuffering = false;
        }
      });
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((pos) {
      if (!mounted) return;
      setState(() => _currentPosition = pos);
    });

    _durationSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (!mounted) return;
      setState(() => _totalDuration = dur);
    });

    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _isBuffering = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _completeSub?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _searchController.dispose();
    _getSoundRxObj.dispose();
    super.dispose();
  }

  Future<void> _togglePreview(Sound sound) async {
    final String? audioUrl = sound.audioUrl;
    if (audioUrl == null || audioUrl.trim().isEmpty) {
      ToastUtil.showShortToast('Audio preview is not available for this soundtrack');
      return;
    }

    if (_previewingSound?.id == sound.id) {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
      return;
    }

    try {
      setState(() {
        _previewingSound = sound;
        _isBuffering = true;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
      });

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl.trim()));
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBuffering = false;
          _isPlaying = false;
        });
        ToastUtil.showShortToast('Unable to preview sound: $e');
      }
    }
  }

  Future<void> _stopPreview() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _previewingSound = null;
        _isPlaying = false;
        _isBuffering = false;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
      });
    }
  }

  void _onBack() async {
    await _stopPreview();
    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  void _onSelectSound(Sound sound) async {
    await _stopPreview();
    if (mounted) {
      setState(() => _selectedSound = sound);
      Navigator.of(context).pop(sound);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _stopPreview();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_bgTop, _bgBottom],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // ---- Top Header Bar ----
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 10.h),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _onBack,
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.music_albums,
                                  color: _purpleLight,
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Soundtracks',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 44.w),
                        ],
                      ),
                    ),

                    // ---- Search Bar ----
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF161426),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                          onChanged: (val) {
                            setState(() => _searchQuery = val.trim());
                          },
                          decoration: InputDecoration(
                            hintText: 'Search songs, artists, beats...',
                            hintStyle: TextStyle(
                              color: _hintColor,
                              fontSize: 13.5.sp,
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              color: _hintColor,
                              size: 18.r,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    child: Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: _hintColor,
                                      size: 18.r,
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 11.h,
                              horizontal: 12.w,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // ---- Sound List StreamBuilder ----
                    Expanded(
                      child: StreamBuilder<GetuserModel>(
                        stream: _getSoundRxObj.stream,
                        builder: (context, snapshot) {
                          final isLoading =
                              snapshot.connectionState == ConnectionState.waiting &&
                                  !snapshot.hasData;

                          if (isLoading) {
                            return const _SoundListShimmer();
                          }

                          final allSounds = snapshot.data?.data?.sounds ?? [];
                          final filteredSounds = _searchQuery.isEmpty
                              ? allSounds
                              : allSounds.where((s) {
                                  final q = _searchQuery.toLowerCase();
                                  final title = (s.title ?? '').toLowerCase();
                                  final artist = (s.artist ?? '').toLowerCase();
                                  return title.contains(q) || artist.contains(q);
                                }).toList();

                          if (filteredSounds.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.music_note_list,
                                    color: _hintColor.withValues(alpha: 0.6),
                                    size: 52.r,
                                  ),
                                  SizedBox(height: 14.h),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No sounds match "$_searchQuery"'
                                        : 'No soundtracks available right now',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _hintColor,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _getSoundRxObj.fetchSounds(),
                                    icon: const Icon(
                                      Icons.refresh,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Refresh',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _purple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Extra padding when bottom floating player is open
                          final bottomPadding =
                              _previewingSound != null ? 116.h : 24.h;

                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              16.w,
                              6.h,
                              16.w,
                              bottomPadding,
                            ),
                            itemCount: filteredSounds.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 14.h),
                            itemBuilder: (context, index) {
                              final sound = filteredSounds[index];
                              final bool isPreviewing =
                                  _previewingSound?.id == sound.id;
                              final bool isPlayingThis =
                                  isPreviewing && _isPlaying;
                              final bool isBufferingThis =
                                  isPreviewing && _isBuffering;

                              return _SoundItemRow(
                                sound: sound,
                                isPreviewing: isPreviewing,
                                isPlaying: isPlayingThis,
                                isBuffering: isBufferingThis,
                                isSelected: _selectedSound?.id == sound.id,
                                onPreviewTap: () => _togglePreview(sound),
                                onUseTap: () => _onSelectSound(sound),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // ---- Ultra-Smooth Floating Glassmorphic Player ----
                if (_previewingSound != null)
                  Positioned(
                    left: 12.w,
                    right: 12.w,
                    bottom: 12.h,
                    child: _ProFloatingMusicPlayer(
                      sound: _previewingSound!,
                      isPlaying: _isPlaying,
                      isBuffering: _isBuffering,
                      currentPosition: _currentPosition,
                      totalDuration: _totalDuration,
                      formattedTime:
                          '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                      progress: _totalDuration.inMilliseconds > 0
                          ? (_currentPosition.inMilliseconds /
                                  _totalDuration.inMilliseconds)
                              .clamp(0.0, 1.0)
                          : 0.0,
                      onTogglePlay: () => _togglePreview(_previewingSound!),
                      onUseSound: () => _onSelectSound(_previewingSound!),
                      onClose: _stopPreview,
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

// ============================================================================
// 1. SOUND ITEM CARD ROW WITH DYNAMIC ACOUSTIC VISUALIZER
// ============================================================================
class _SoundItemRow extends StatelessWidget {
  final Sound sound;
  final bool isPreviewing;
  final bool isPlaying;
  final bool isBuffering;
  final bool isSelected;
  final VoidCallback onPreviewTap;
  final VoidCallback onUseTap;

  const _SoundItemRow({
    required this.sound,
    required this.isPreviewing,
    required this.isPlaying,
    required this.isBuffering,
    required this.isSelected,
    required this.onPreviewTap,
    required this.onUseTap,
  });

  static const Color _cardBorder = Color(0xFF262338);
  static const Color _hintColor = Color(0xFF9C9AAB);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);
  static const Color _hotPink = Color(0xFFEC4899);

  @override
  Widget build(BuildContext context) {
    final title = sound.title ?? 'Original Soundtrack';
    final artist = sound.artist ?? sound.creator?.name ?? 'Unknown Artist';
    final postsCount = sound.postsCount ?? 0;
    final thumbnailUrl = sound.thumbnailUrl ?? '';

    return _BounceTap(
      onTap: onPreviewTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isPreviewing
              ? const Color(0xFF221D38)
              : const Color(0xFF161426),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isPreviewing
                ? _purpleLight
                : (isSelected ? _purple : _cardBorder),
            width: isPreviewing ? 1.6 : 1.0,
          ),
          boxShadow: isPreviewing
              ? [
                  BoxShadow(
                    color: _purple.withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: _hotPink.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // ---- Vinyl Record Turntable with Grooves & Aura Waves ----
                SizedBox(
                  width: 62.w,
                  height: 62.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Acoustic Sound Pulse Halo (pulsing rings behind disc)
                      if (isPlaying)
                        _AcousticSoundAura(
                          size: 62.w,
                          color: _purpleLight,
                        ),

                      // Vinyl Record with Grooves and Center Label
                      _RealisticVinylDisk(
                        isPlaying: isPlaying,
                        thumbnailUrl: thumbnailUrl,
                        size: 60.w,
                      ),

                      // Center Action: Buffering Spinner or Pause icon
                      if (isBuffering)
                        Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.65),
                          ),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 15.w,
                            height: 15.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      else if (isPlaying)
                        Container(
                          width: 26.w,
                          height: 26.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.65),
                            border: Border.all(
                              color: Colors.white38,
                              width: 1.0,
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.pause_fill,
                            color: Colors.white,
                            size: 13.r,
                          ),
                        )
                      else if (!isPreviewing)
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                          child: Icon(
                            CupertinoIcons.play_arrow_solid,
                            color: Colors.white,
                            size: 12.r,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(width: 14.w),

                // ---- Track Info & Animated Waveform ----
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          if (isPlaying) ...[
                            SizedBox(width: 6.w),
                            _LiveBadge(),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _hintColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.flame_fill,
                            color: const Color(0xFFFF7A00),
                            size: 13.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            postsCount > 0
                                ? '$postsCount posts'
                                : 'Trending beat',
                            style: TextStyle(
                              color: _purpleLight,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // ---- "Use" Gradient Action Button ----
                _BounceTap(
                  onTap: onUseTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 7.5.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: const LinearGradient(
                        colors: [_purpleLight, _purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.check_mark,
                          color: Colors.white,
                          size: 13.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Use',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ---- Expanded Dynamic Waveform Visualizer on Active Track ----
            if (isPreviewing) ...[
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Text(
                      'Preview Playing',
                      style: TextStyle(
                        color: _purpleLight.withValues(alpha: 0.9),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _DynamicAudioWaveform(
                        isPlaying: isPlaying,
                        barCount: 20,
                        maxHeight: 18.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. REALISTIC VINYL RECORD DISK WITH GROOVES & SHINE REFLECTION
// ============================================================================
class _RealisticVinylDisk extends StatefulWidget {
  final bool isPlaying;
  final String thumbnailUrl;
  final double size;

  const _RealisticVinylDisk({
    required this.isPlaying,
    required this.thumbnailUrl,
    required this.size,
  });

  @override
  State<_RealisticVinylDisk> createState() => _RealisticVinylDiskState();
}

class _RealisticVinylDiskState extends State<_RealisticVinylDisk>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (widget.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _RealisticVinylDisk oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotationController,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF100E1C),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Vinyl Grooves (concentric ring lines)
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _VinylGroovesPainter(),
            ),

            // Center Label (Cover Art)
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.size * 0.28),
              child: SizedBox(
                width: widget.size * 0.54,
                height: widget.size * 0.54,
                child: widget.thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFF2E294E),
                        ),
                        errorWidget: (context, url, error) =>
                            _buildFallbackArt(),
                      )
                    : _buildFallbackArt(),
              ),
            ),

            // Center Spindle Hole (Silver center dot)
            Container(
              width: 7.w,
              height: 7.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD1D5DB),
                border: Border.all(
                  color: Colors.black87,
                  width: 1.2,
                ),
              ),
            ),

            // Conical Sheen Light Reflection
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.14),
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.14),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackArt() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.music_note,
          color: Colors.white,
          size: widget.size * 0.25,
        ),
      ),
    );
  }
}

class _VinylGroovesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final maxRadius = size.width / 2 - 2;
    // Draw 3 subtle concentric groove tracks
    canvas.drawCircle(center, maxRadius * 0.92, paint);
    canvas.drawCircle(center, maxRadius * 0.80, paint);
    canvas.drawCircle(center, maxRadius * 0.68, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// 3. ACOUSTIC SOUND AURA PULSE RIPPLE
// ============================================================================
class _AcousticSoundAura extends StatefulWidget {
  final double size;
  final Color color;

  const _AcousticSoundAura({
    required this.size,
    required this.color,
  });

  @override
  State<_AcousticSoundAura> createState() => _AcousticSoundAuraState();
}

class _AcousticSoundAuraState extends State<_AcousticSoundAura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _auraController;

  @override
  void initState() {
    super.initState();
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _auraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _auraController,
      builder: (context, child) {
        final t = _auraController.value;
        final scale1 = 1.0 + (t * 0.35);
        final opacity1 = (1.0 - t).clamp(0.0, 1.0) * 0.55;

        final t2 = (t + 0.5) % 1.0;
        final scale2 = 1.0 + (t2 * 0.35);
        final opacity2 = (1.0 - t2).clamp(0.0, 1.0) * 0.55;

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale1,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withValues(alpha: opacity1),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            Transform.scale(
              scale: scale2,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFEC4899).withValues(alpha: opacity2),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// 4. DYNAMIC AUDIO WAVEFORM VISUALIZER BARS
// ============================================================================
class _DynamicAudioWaveform extends StatefulWidget {
  final bool isPlaying;
  final int barCount;
  final double maxHeight;

  const _DynamicAudioWaveform({
    required this.isPlaying,
    this.barCount = 18,
    this.maxHeight = 20,
  });

  @override
  State<_DynamicAudioWaveform> createState() => _DynamicAudioWaveformState();
}

class _DynamicAudioWaveformState extends State<_DynamicAudioWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    if (widget.isPlaying) {
      _waveController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _DynamicAudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
      }
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        final t = _waveController.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (index) {
            // Harmonic wave formula giving natural audio spectrum frequencies
            final double phase = index * (math.pi / (widget.barCount / 2));
            final double wave1 = math.sin((t * 2 * math.pi) + phase).abs();
            final double wave2 = math.cos((t * math.pi) + (index * 0.4)).abs();
            final double combined = (wave1 * 0.6 + wave2 * 0.4);

            final double factor = widget.isPlaying ? combined : 0.15;
            final double barH = (widget.maxHeight * factor).clamp(3.0, widget.maxHeight);

            // Dynamic color gradient across frequencies (cyan -> purple -> hot pink)
            final double colorRatio = index / (widget.barCount - 1);
            final Color barColor = Color.lerp(
              const Color(0xFF06B6D4), // Cyan
              Color.lerp(
                const Color(0xFFA855F7), // Purple
                const Color(0xFFEC4899), // Hot Pink
                colorRatio,
              ),
              colorRatio,
            )!;

            return Container(
              width: 2.8.w,
              height: barH,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2.r),
                boxShadow: widget.isPlaying
                    ? [
                        BoxShadow(
                          color: barColor.withValues(alpha: 0.45),
                          blurRadius: 3,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        );
      },
    );
  }
}

// ============================================================================
// 5. LIVE PLAYING BADGE
// ============================================================================
class _LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.w,
            height: 5.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'PLAYING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 6. PRO FLOATING GLASSMORPHIC MINI MUSIC PLAYER
// ============================================================================
class _ProFloatingMusicPlayer extends StatelessWidget {
  final Sound sound;
  final bool isPlaying;
  final bool isBuffering;
  final Duration currentPosition;
  final Duration totalDuration;
  final String formattedTime;
  final double progress;
  final VoidCallback onTogglePlay;
  final VoidCallback onUseSound;
  final VoidCallback onClose;

  const _ProFloatingMusicPlayer({
    required this.sound,
    required this.isPlaying,
    required this.isBuffering,
    required this.currentPosition,
    required this.totalDuration,
    required this.formattedTime,
    required this.progress,
    required this.onTogglePlay,
    required this.onUseSound,
    required this.onClose,
  });

  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);

  @override
  Widget build(BuildContext context) {
    final title = sound.title ?? 'Original Sound';
    final artist = sound.artist ?? sound.creator?.name ?? 'Unknown Artist';
    final thumbnailUrl = sound.thumbnailUrl ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1B172E).withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: _purpleLight.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: _purple.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---- Audio Progress Bar with Gradient ----
              LinearProgressIndicator(
                value: progress,
                minHeight: 3.h,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(_purpleLight),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Row(
                  children: [
                    // Spinning Disc Thumbnail
                    _RealisticVinylDisk(
                      isPlaying: isPlaying,
                      thumbnailUrl: thumbnailUrl,
                      size: 42.w,
                    ),

                    SizedBox(width: 10.w),

                    // Track Info + Live Time + Mini Waveform
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xFF9C9AAB),
                                    fontSize: 11.5.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '•',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  color: _purpleLight,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          if (isPlaying) ...[
                            SizedBox(height: 4.h),
                            _DynamicAudioWaveform(
                              isPlaying: true,
                              barCount: 16,
                              maxHeight: 9.h,
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(width: 6.w),

                    // Play/Pause Circular Action Button
                    _BounceTap(
                      onTap: onTogglePlay,
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _purple.withValues(alpha: 0.25),
                          border: Border.all(
                            color: _purpleLight.withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: isBuffering
                            ? SizedBox(
                                width: 15.w,
                                height: 15.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(
                                isPlaying
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_arrow_solid,
                                color: Colors.white,
                                size: 15.r,
                              ),
                      ),
                    ),

                    SizedBox(width: 6.w),

                    // "Apply" Button with Vibrant Gradient
                    _BounceTap(
                      onTap: onUseSound,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: const LinearGradient(
                            colors: [_purpleLight, _purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _purple.withValues(alpha: 0.45),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Dismiss Button
                    GestureDetector(
                      onTap: onClose,
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: Colors.white38,
                          size: 19.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 7. SHIMMER SKELETON
// ============================================================================
class _SoundListShimmer extends StatelessWidget {
  const _SoundListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 7,
      separatorBuilder: (context, index) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF262338),
          highlightColor: const Color(0xFF3B3654),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF161426),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 90.w,
                        height: 12.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 58.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// 8. BOUNCE TAP WRAPPER
// ============================================================================
class _BounceTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BounceTap({required this.child, required this.onTap});

  @override
  State<_BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<_BounceTap> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
