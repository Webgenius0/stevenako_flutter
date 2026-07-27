
// ==========================================
// 1. REELS SUB-SCREEN (Video Tab)
// ==========================================
import 'dart:math' as math;

import 'package:flutter/material.dart';
// ==========================================
// 1. REELS SUB-SCREEN (Video Tab)
// ==========================================
//
// REQUIRED SETUP:
// Add this to pubspec.yaml under dependencies:
//   video_player: ^2.9.2
// Then run: flutter pub get
//
// This uses NETWORK video urls in _reelsData for demo purposes.
// If you want to bundle local video files instead, add them under
// pubspec.yaml -> flutter -> assets (e.g. assets/videos/reel1.mp4),
// put the file path in 'videoUrl', and set 'isNetwork': false.
//

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelsSubScreen extends StatefulWidget {
  final bool isActive;

  const ReelsSubScreen({super.key, this.isActive = true});

  @override
  State<ReelsSubScreen> createState() => _ReelsSubScreenState();
}

class _ReelsSubScreenState extends State<ReelsSubScreen> {
  final PreloadPageController _pageController = PreloadPageController();
  int _currentPage = 0;
  bool _isVisible = true;

  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, bool> _initializedStates = {};
  final Map<int, bool> _errorStates = {};

  final List<Map<String, dynamic>> _reelsData = [
    {
      'userName': 'Frances Swann',
      'userHandle': '@frances',
      'caption': 'I\'m good !! How are you? #farewell',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'likes': 10,
      'comments': 8,
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'isNetwork': true,
      'musicTitle': 'Original Sound - Frances S.',
    },
    {
      'userName': 'David Miller',
      'userHandle': '@david_m',
      'caption': 'Cyberpunk night vibes in the city 🌃 #neon #future',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
      'likes': 420,
      'comments': 32,
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'isNetwork': true,
      'musicTitle': 'Synthwave Nights - V.2',
    },
    {
      'userName': 'Sophia Taylor',
      'userHandle': '@sophia_sun',
      'caption': 'Golden hour in paradise 🌴☀️ #sunset #beach #escape',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&auto=format&fit=crop&q=80',
      'likes': 812,
      'comments': 54,
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'isNetwork': true,
      'musicTitle': 'Summer Breeze - Sophia',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Pre-initialize video 0 and next video 1 immediately for instant playback
    _initControllerForIndex(0);
    _initControllerForIndex(1);
  }

  @override
  void didUpdateWidget(covariant ReelsSubScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && _isVisible) {
        _controllers[_currentPage]?.play();
      } else {
        _controllers[_currentPage]?.pause();
      }
    }
  }

  void _initControllerForIndex(int index) {
    if (index < 0 || index >= _reelsData.length) return;
    if (_controllers.containsKey(index)) return;

    final item = _reelsData[index];
    final bool isNetwork = item['isNetwork'] ?? true;
    final String source = item['videoUrl'];

    try {
      final controller = isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(source))
          : VideoPlayerController.asset(source);

      _controllers[index] = controller;

      controller.initialize().then((_) {
        if (!mounted) return;
        controller.setLooping(true);
        setState(() {
          _initializedStates[index] = true;
          _errorStates[index] = false;
        });
        if (index == _currentPage && widget.isActive && _isVisible) {
          controller.play();
        }
      }).catchError((error) {
        debugPrint('Preload error for video index $index: $error');
        if (!mounted) return;
        setState(() {
          _errorStates[index] = true;
          _initializedStates[index] = false;
        });
      });
    } catch (e) {
      debugPrint('Setup error for video index $index: $e');
      _errorStates[index] = true;
    }
  }

  void _onPageChanged(int newIndex) {
    // Pause previous video
    _controllers[_currentPage]?.pause();

    setState(() {
      _currentPage = newIndex;
    });

    // Play current video
    final currentController = _controllers[newIndex];
    if (currentController != null && _initializedStates[newIndex] == true && widget.isActive && _isVisible) {
      currentController.play();
    } else {
      _initControllerForIndex(newIndex);
    }

    // Preload next & previous adjacent videos for zero-latency swiping
    _initControllerForIndex(newIndex + 1);
    if (newIndex > 0) {
      _initControllerForIndex(newIndex - 1);
    }

    // Clean up distant controllers to manage RAM
    _cleanupControllers(newIndex);
  }

  void _cleanupControllers(int currentIndex) {
    final keysToRemove = <int>[];
    _controllers.forEach((index, controller) {
      if ((index - currentIndex).abs() > 2) {
        controller.dispose();
        keysToRemove.add(index);
      }
    });

    for (final key in keysToRemove) {
      _controllers.remove(key);
      _initializedStates.remove(key);
      _errorStates.remove(key);
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    _controllers.clear();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('reels-sub-screen-visibility-key'),
      onVisibilityChanged: (info) {
        final bool isVisibleNow = info.visibleFraction > 0.1;
        if (_isVisible != isVisibleNow) {
          setState(() {
            _isVisible = isVisibleNow;
          });
          if (_isVisible && widget.isActive) {
            _controllers[_currentPage]?.play();
          } else {
            _controllers[_currentPage]?.pause();
          }
        }
      },
      child: PreloadPageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        preloadPagesCount: 1,
        itemCount: _reelsData.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return ReelPageItem(
            data: _reelsData[index],
            isActive: index == _currentPage && widget.isActive && _isVisible,
            videoController: _controllers[index],
            isVideoInitialized: _initializedStates[index] ?? false,
            hasError: _errorStates[index] ?? false,
            onRetry: () => _initControllerForIndex(index),
          );
        },
      ),
    );
  }
}

class ReelPageItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isActive;
  final VideoPlayerController? videoController;
  final bool isVideoInitialized;
  final bool hasError;
  final VoidCallback onRetry;

  const ReelPageItem({
    super.key,
    required this.data,
    required this.isActive,
    this.videoController,
    this.isVideoInitialized = false,
    this.hasError = false,
    required this.onRetry,
  });

  @override
  State<ReelPageItem> createState() => _ReelPageItemState();
}

class _ReelPageItemState extends State<ReelPageItem> with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  bool _isFollowing = false;
  late int _likeCount;

  bool _isMuted = false;
  bool _showPauseIcon = false;

  // Music vinyl rotation controller
  late AnimationController _musicController;

  // Interactive popup variables
  double? _coinAnimX;
  double? _coinAnimY;
  bool _showCoinAnim = false;

  double? _heartPopX;
  double? _heartPopY;
  bool _showHeartPop = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.data['likes'];
    _musicController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _musicController.dispose();
    super.dispose();
  }

  void _triggerLike() {
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likeCount++ : _likeCount--;
    });
  }

  void _togglePlayPause() {
    final controller = widget.videoController;
    if (controller == null || !widget.isVideoInitialized) return;
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
        _showPauseIcon = true;
      } else {
        controller.play();
        _showPauseIcon = false;
      }
    });
  }

  void _toggleMute() {
    final controller = widget.videoController;
    if (controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _triggerCoins(TapDownDetails details) {
    setState(() {
      _coinAnimX = details.globalPosition.dx;
      _coinAnimY = details.globalPosition.dy;
      _showCoinAnim = true;
    });

    // Animate coins toast float up
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showCoinAnim = false;
        });
      }
    });
  }

  void _handleDoubleTap(TapDownDetails details) {
    setState(() {
      _heartPopX = details.globalPosition.dx;
      _heartPopY = details.globalPosition.dy;
      _showHeartPop = true;
      if (!_isLiked) {
        _isLiked = true;
        _likeCount++;
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _showHeartPop = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTap,
      onDoubleTap: () {}, // Handled by gesture detector
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          // Video background
          Positioned.fill(
            child: widget.isVideoInitialized && widget.videoController != null
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: widget.videoController!.value.size.width > 0
                          ? widget.videoController!.value.size.width
                          : 16,
                      height: widget.videoController!.value.size.height > 0
                          ? widget.videoController!.value.size.height
                          : 9,
                      child: VideoPlayer(widget.videoController!),
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: Center(
                      child: widget.hasError
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Color(0xFFFF3F55),
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Unable to load video',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: widget.onRetry,
                                  icon: const Icon(Icons.refresh_rounded, size: 18),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF3F55),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const CircularProgressIndicator(color: Color(0xFFFF3F55)),
                    ),
                  ),
          ),

          // Dark vignette overlay on bottom and top for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Center pause icon (shows briefly when user taps to pause)
          if (_showPauseIcon)
            const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white70,
                size: 88,
              ),
            ),

          // Thin video progress bar pinned above bottom overlay
          if (widget.isVideoInitialized && widget.videoController != null)
            Positioned(
              bottom: 96,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                widget.videoController!,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                colors: const VideoProgressColors(
                  playedColor: Color(0xFFFF3F55),
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white12,
                ),
              ),
            ),

          // Bottom Left Overlay details (User profile info)
          Positioned(
            bottom: 140.h, // Raised above bottom nav bar area
            left: 16,
            right: 80, // Leave room for right overlay actions
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar, Name, Follow
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.data['avatar']),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.data['userName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tactile Follow Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: _isFollowing
                              ? Colors.white24
                              : const Color(0xFFFF3F55),
                          borderRadius: BorderRadius.circular(14),
                          border: _isFollowing ? Border.all(color: Colors.white30) : null,
                        ),
                        child: Text(
                          _isFollowing ? 'following' : 'follow',
                          style: TextStyle(
                            color: _isFollowing ? Colors.white70 : Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.data['userHandle'],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.data['caption'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Right Vertical Action Menu Overlay
          Positioned(
            bottom: 130.h,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Heart Like
                _buildActionItem(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isLiked ? const Color(0xFFFF3F55) : Colors.white,
                  label: '$_likeCount',
                  onTap: _triggerLike,
                ),
                const SizedBox(height: 16),

                // Comment
                _buildActionItem(
                  icon: Icons.chat_bubble_outline,
                  label: '${widget.data['comments']}',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comments section coming soon!')),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Share / Send
                _buildActionItem(
                  icon: Icons.reply,
                  label: '',
                  iconScaleX: -1.0, // Flip arrow to point top-right
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied to clipboard!')),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Mute / Unmute toggle
                _buildActionItem(
                  icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                  label: '',
                  onTap: _toggleMute,
                ),
                const SizedBox(height: 16),

                // Spinning Vinyl Music Disk
                RotationTransition(
                  turns: _musicController,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Interactive Coins Award Button
                GestureDetector(
                  onTapDown: _triggerCoins,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD97706).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      r'$',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Double Tap Heart Pop Animation overlay
          if (_showHeartPop && _heartPopX != null && _heartPopY != null)
            Positioned(
              left: _heartPopX! - 48,
              top: _heartPopY! - 48,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale * 1.3,
                    child: Opacity(
                      opacity: math.max(0.0, 1.0 - scale),
                      child: const Icon(
                        Icons.favorite,
                        color: Color(0xFFFF3F55),
                        size: 96,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Coin rewards float-up text overlay
          if (_showCoinAnim && _coinAnimX != null && _coinAnimY != null)
            Positioned(
              left: _coinAnimX! - 60,
              top: _coinAnimY! - 60,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, val, child) {
                  return Transform.translate(
                    offset: Offset(0, -val * 60),
                    child: Opacity(
                      opacity: 1.0 - val,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBBF24),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monetization_on, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '+10 Coins!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    Color iconColor = Colors.white,
    double iconScaleX = 1.0,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(iconScaleX, 1.0, 1.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
              shadows: const [
                Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}