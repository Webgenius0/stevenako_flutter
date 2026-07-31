
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:share_plus/share_plus.dart';
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

  Future<void> _shareVideo() async {
    final String userHandle = widget.data['userHandle'] ?? '@frances';
    final String caption = widget.data['caption'] ?? '';
    final String videoUrl = widget.data['videoUrl'] ?? '';
    final String shareText =
        'Watch this reel by $userHandle on StevenAko!\n\n"$caption"\n\n$videoUrl';

    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'Reel by $userHandle',
        ),
      );
      if (result.status == ShareResultStatus.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video link shared!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showShareBottomSheet(context, shareText);
      }
    }
  }

  void _showShareBottomSheet(BuildContext context, String shareText) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E212D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Share Video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),

              ListTile(
                leading: const Icon(Icons.copy_rounded, color: Colors.white),
                title: const Text('Copy Video Link',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Clipboard.setData(ClipboardData(text: shareText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Video link copied to clipboard!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.share_outlined, color: Colors.white),
                title: const Text('Share via App...',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  SharePlus.instance.share(ShareParams(text: shareText));
                },
              ),

              ListTile(
                leading: const Icon(Icons.send_rounded, color: Color(0xFF9D65FF)),
                title: const Text('Send in Message',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Video sent in message!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final TextEditingController commentInputController = TextEditingController();
    final List<Map<String, dynamic>> localComments = [
      {
        'id': '1',
        'handle': '@kai',
        'avatar':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
        'text': 'Absolutely stunning video! 🔥',
        'time': '2h',
        'likes': 4,
        'isLiked': false,
      },
      {
        'id': '2',
        'handle': '@priya',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
        'text': 'Love the vibe here. ✨',
        'time': '1h',
        'likes': 2,
        'isLiked': false,
      },
      {
        'id': '3',
        'handle': '@tom',
        'avatar':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&auto=format&fit=crop&q=80',
        'text': 'Incredible shot! 🚀',
        'time': '30m',
        'likes': 1,
        'isLiked': false,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.72,
                decoration: BoxDecoration(
                  color: const Color(0xFF161722),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  border: Border.all(color: Colors.white12, width: 1),
                ),
                child: Column(
                  children: [
                    // Handle & Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 38.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 24.w),
                              Text(
                                '${widget.data['comments']} Comments',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(bottomSheetContext),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white60,
                                  size: 22.r,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(color: Colors.white12, height: 1),

                    // Scrollable Comments List
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(16.r),
                        itemCount: localComments.length,
                        separatorBuilder: (context, index) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final item = localComments[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18.r),
                                child: Image.network(
                                  item['avatar'],
                                  width: 36.r,
                                  height: 36.r,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 36.r,
                                    height: 36.r,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.person, color: Colors.white70),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF222533),
                                        borderRadius: BorderRadius.circular(18.r),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${item['handle']} ',
                                              style: TextStyle(
                                                color: const Color(0xFF9D65FF),
                                                fontSize: 13.5.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: item['text'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.5.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.w),
                                      child: Row(
                                        children: [
                                          Text(
                                            item['time'],
                                            style: TextStyle(
                                                color: Colors.white38, fontSize: 11.sp),
                                          ),
                                          SizedBox(width: 12.w),
                                          GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                commentInputController.text =
                                                    '${item['handle']} ';
                                              });
                                            },
                                            child: Text(
                                              'Reply',
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 11.5.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    item['isLiked'] = !(item['isLiked'] as bool);
                                    if (item['isLiked']) {
                                      item['likes'] = (item['likes'] as int) + 1;
                                    } else {
                                      item['likes'] = (item['likes'] as int) - 1;
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      item['isLiked']
                                          ? Icons.favorite
                                          : Icons.favorite_border_rounded,
                                      size: 16.r,
                                      color: item['isLiked']
                                          ? const Color(0xFFFF3F5E)
                                          : Colors.white38,
                                    ),
                                    if (item['likes'] > 0)
                                      Text(
                                        '${item['likes']}',
                                        style: TextStyle(
                                            color: Colors.white38, fontSize: 10.sp),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Add Comment Input Box
                    Container(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 8.h,
                        bottom: 16.h + MediaQuery.of(context).padding.bottom,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF161722),
                        border: Border(
                          top: BorderSide(color: Colors.white12, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF222533),
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: TextField(
                                controller: commentInputController,
                                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                cursorColor: const Color(0xFFFF3F5E),
                                decoration: InputDecoration(
                                  hintText: 'Add a comment...',
                                  hintStyle: TextStyle(
                                      color: Colors.white38, fontSize: 14.sp),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          IconButton(
                            onPressed: () {
                              final text = commentInputController.text.trim();
                              if (text.isEmpty) return;

                              setModalState(() {
                                localComments.add({
                                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                  'handle': '@you',
                                  'avatar':
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
                                  'text': text,
                                  'time': 'Just now',
                                  'likes': 0,
                                  'isLiked': false,
                                });

                                widget.data['comments'] =
                                    (widget.data['comments'] as int) + 1;

                                commentInputController.clear();
                              });

                              setState(() {});
                            },
                            icon: Image.asset(
                              'assets/images/rocket.png',
                              width: 22.r,
                              height: 22.r,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTipsBottomSheet(BuildContext context) {
    final amounts = [1, 5, 10, 50];
    int selectedAmount = 50;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF181924),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 12.h,
                bottom: 24.h + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag indicator handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Header title: Gift icon + Tips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Image.asset('assets/images/gift.png',height: 24.h,width: 24.w,),
                      SizedBox(width: 8.w),
                      Text(
                        'Tips',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // "Amount" section label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Amount options selector
                  Row(
                    children: amounts.map((amount) {
                      final isSelected = selectedAmount == amount;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedAmount = amount;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 52.h,
                              decoration: BoxDecoration(
                                color: isSelected ? null : Colors.white,
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF8B5CF6).withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '\$ $amount',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 32.h),

                  // Send button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // Trigger coin float animation
                      final screenSize = MediaQuery.of(context).size;
                      setState(() {
                        _coinAnimX = screenSize.width / 2;
                        _coinAnimY = screenSize.height / 2;
                        _showCoinAnim = true;
                      });
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        if (mounted) {
                          setState(() {
                            _showCoinAnim = false;
                          });
                        }
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.greenAccent),
                              SizedBox(width: 10.w),
                              Text('Sent \$$selectedAmount tip to ${widget.data['userName']}!'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF181924),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9061F9), Color(0xFF5B21B6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withOpacity(0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Image.asset('assets/images/gift.png',height: 24.h,width: 24.w,),
                          SizedBox(width: 8.w),
                          Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Orange Coin Icon
                          Container(
                            width: 22.w,
                            height: 22.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              r'$',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '\$$selectedAmount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
            // Positioned(
            //   bottom: 96,
            //   left: 0,
            //   right: 0,
            //   child: VideoProgressIndicator(
            //     widget.videoController!,
            //     allowScrubbing: true,
            //     padding: const EdgeInsets.symmetric(horizontal: 12),
            //     colors: const VideoProgressColors(
            //       playedColor: Color(0xFFFF3F55),
            //       bufferedColor: Colors.white30,
            //       backgroundColor: Colors.white12,
            //     ),
            //   ),
            // ),

// Bottom Left Overlay details (User profile info)
          Positioned(
            bottom: 140.h,
            left: 16.w,
            right: 80.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // <-- ADD THIS
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: NetworkImage(widget.data['avatar']),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.data['userName'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.data['userHandle'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 11.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        constraints: BoxConstraints(minWidth: 74.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isFollowing
                              ? Colors.white24
                              : const Color(0xFFFF3F55),
                          borderRadius: BorderRadius.circular(8.r),
                          border: _isFollowing ? Border.all(color: Colors.white30) : null,
                        ),
                        child: Text(
                          _isFollowing ? 'Following' : 'Follow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isFollowing ? Colors.white70 : Colors.white,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  widget.data['caption'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
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
                  imagePath: 'assets/images/mesagenva.png',
                  label: '${widget.data['comments']}',
                  onTap: () => _showCommentsBottomSheet(context),
                ),
                const SizedBox(height: 16),

                // Share / Send
                _buildActionItem(
                  imagePath: 'assets/images/ShareIcon.png',
                  icon: Icons.reply,
                  label: '',
                  iconScaleX: -1.0, // Flip arrow to point top-right
                  onTap: _shareVideo,
                ),
                const SizedBox(height: 16),

                // // Mute / Unmute toggle
                // _buildActionItem(
                //   icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                //   label: '',
                //   onTap: _toggleMute,
                // ),
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
                  onTap: () => _showTipsBottomSheet(context),
                  child: Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBF9405), Color(0xFFBF9405)],
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
                    child: Image.asset(
                      'assets/images/dolor.png',
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.contain,
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
    IconData? icon,
    String? imagePath, // NEW: pass asset path for image-based icons
    required String label,
    Color iconColor = Colors.white,
    double iconScaleX = 1.0,
    double size = 32,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imagePath != null
              ? Image.asset(
            imagePath,
            width: size,
            height: size,
            color: iconColor, // remove this line if your image is already colored/full-color
          )
              : Icon(
            icon,
            color: iconColor,
            size: size,
            shadows: const [
              Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
            ],
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