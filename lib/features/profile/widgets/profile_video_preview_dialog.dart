import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:stevenako_flutter/features/home/presentation/widgets/reel_comments_bottom_sheet.dart';

class ProfileVideoPreviewDialog extends StatefulWidget {
  final List<dynamic> posts;
  final int initialIndex;
  final VoidCallback? onDelete;

  const ProfileVideoPreviewDialog({
    super.key,
    required this.posts,
    this.initialIndex = 0,
    this.onDelete,
  });

  @override
  State<ProfileVideoPreviewDialog> createState() =>
      _ProfileVideoPreviewDialogState();
}

class _ProfileVideoPreviewDialogState extends State<ProfileVideoPreviewDialog> {
  late PageController _pageController;
  late int _currentPage;

  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, bool> _initializedStates = {};
  final Map<int, bool> _errorStates = {};

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initControllerForIndex(_currentPage);
    _initControllerForIndex(_currentPage + 1);
    if (_currentPage > 0) {
      _initControllerForIndex(_currentPage - 1);
    }
  }

  void _initControllerForIndex(int index) {
    if (index < 0 || index >= widget.posts.length) return;
    if (_controllers.containsKey(index)) return;

    final post = widget.posts[index];
    String videoUrl = '';
    if (post.media != null && post.media!.isNotEmpty) {
      videoUrl = post.media!.first.mediaUrl ?? '';
    }

    if (videoUrl.isEmpty) {
      _errorStates[index] = true;
      return;
    }

    try {
      final uri = Uri.parse(videoUrl.trim());
      final controller = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: const {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
        },
      );

      _controllers[index] = controller;

      controller.initialize().then((_) {
        if (!mounted) return;
        controller.setLooping(true);
        setState(() {
          _initializedStates[index] = true;
          _errorStates[index] = false;
        });
        if (index == _currentPage) {
          controller.play();
        }
      }).catchError((error) {
        debugPrint('Profile reels video init error at index $index: $error');
        if (!mounted) return;
        controller.dispose();
        _controllers.remove(index);
        setState(() {
          _errorStates[index] = true;
          _initializedStates[index] = false;
        });
      });
    } catch (e) {
      debugPrint('Profile reels setup exception at index $index: $e');
      _errorStates[index] = true;
    }
  }

  void _onPageChanged(int index) {
    _controllers.forEach((idx, ctrl) {
      if (idx != index) {
        ctrl.pause();
      }
    });

    if (mounted) {
      setState(() {
        _currentPage = index;
      });
    }

    _controllers[index]?.play();
    _initControllerForIndex(index + 1);
    if (index > 0) {
      _initControllerForIndex(index - 1);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllers.forEach((_, ctrl) {
      try {
        ctrl.pause();
        ctrl.dispose();
      } catch (e) {
        debugPrint('Error disposing profile video controller: $e');
      }
    });
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Vertical Swipe PageView for Reels
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: widget.posts.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return ProfileReelItem(
                  post: widget.posts[index],
                  isActive: index == _currentPage,
                  controller: _controllers[index],
                  isInitialized: _initializedStates[index] ?? false,
                  hasError: _errorStates[index] ?? false,
                  onRetry: () => _initControllerForIndex(index),
                  onDelete: widget.onDelete,
                );
              },
            ),

            // Top Navigation Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Reels',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileReelItem extends StatefulWidget {
  final dynamic post;
  final bool isActive;
  final VideoPlayerController? controller;
  final bool isInitialized;
  final bool hasError;
  final VoidCallback onRetry;
  final VoidCallback? onDelete;

  const ProfileReelItem({
    super.key,
    required this.post,
    required this.isActive,
    this.controller,
    required this.isInitialized,
    required this.hasError,
    required this.onRetry,
    this.onDelete,
  });

  @override
  State<ProfileReelItem> createState() => _ProfileReelItemState();
}

class _ProfileReelItemState extends State<ProfileReelItem>
    with TickerProviderStateMixin {
  late AnimationController _playPauseAnimController;
  late Animation<double> _playPauseScale;
  late Animation<double> _playPauseOpacity;

  late AnimationController _musicController;

  bool _showRipple = false;
  IconData _rippleIcon = Icons.pause_rounded;

  bool _isLiked = false;
  int _likeCount = 0;
  int _commentsCount = 0;

  double? _heartPopX;
  double? _heartPopY;
  bool _showHeartPop = false;

  @override
  void initState() {
    super.initState();
    try {
      _isLiked = widget.post.isLiked ?? false;
    } catch (_) {
      _isLiked = false;
    }
    try {
      _likeCount = widget.post.likesCount ?? 0;
    } catch (_) {
      _likeCount = 0;
    }
    try {
      _commentsCount = widget.post.commentsCount ?? 0;
    } catch (_) {
      _commentsCount = 0;
    }

    _playPauseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _playPauseScale = Tween<double>(begin: 0.6, end: 1.3).animate(
      CurvedAnimation(
        parent: _playPauseAnimController,
        curve: Curves.easeOutBack,
      ),
    );
    _playPauseOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _playPauseAnimController,
        curve: Curves.easeIn,
      ),
    );

    _musicController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _playPauseAnimController.dispose();
    _musicController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    final ctrl = widget.controller;
    if (ctrl == null || !widget.isInitialized) return;

    if (ctrl.value.isPlaying) {
      ctrl.pause();
      _rippleIcon = Icons.pause_rounded;
    } else {
      ctrl.play();
      _rippleIcon = Icons.play_arrow_rounded;
    }

    if (mounted) setState(() => _showRipple = true);
    _playPauseAnimController.forward(from: 0.0).then((_) {
      if (mounted) setState(() => _showRipple = false);
    });
  }

  void _triggerLike() {
    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
        _isLiked ? _likeCount++ : _likeCount--;
      });
    }
  }

  void _handleDoubleTap(TapDownDetails details) {
    if (mounted) {
      setState(() {
        _heartPopX = details.globalPosition.dx;
        _heartPopY = details.globalPosition.dy;
        _showHeartPop = true;
        if (!_isLiked) {
          _isLiked = true;
          _likeCount++;
        }
      });
    }

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() => _showHeartPop = false);
      }
    });
  }

  Future<void> _shareVideo() async {
    final String userHandle = '@${widget.post.user?.username ?? 'user'}';
    final String caption = widget.post.caption ?? '';
    String videoUrl = '';
    if (widget.post.media != null && widget.post.media!.isNotEmpty) {
      videoUrl = widget.post.media!.first.mediaUrl ?? '';
    }

    final String shareText =
        'Watch this reel by $userHandle on StevenAko!\n\n"$caption"\n\n$videoUrl';

    try {
      await SharePlus.instance.share(
        ShareParams(text: shareText, subject: 'Reel by $userHandle'),
      );
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  void _showVideoOptions(BuildContext context) {
    final dynamic savedUserId =
        appData.read('user_id') ?? appData.read(kKeyUserID);
    final dynamic profileUserId =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
    final String? currentIdStr =
        (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
            ? savedUserId.toString().trim()
            : profileUserId?.toString().trim();
    final String? postUserIdStr =
        widget.post.user?.id?.toString().trim() ?? widget.post.userId?.toString().trim();
    final bool isOwnPost = widget.post.isSelf == true ||
        widget.post.isMyPost == true ||
        (currentIdStr != null &&
            postUserIdStr != null &&
            currentIdStr == postUserIdStr);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text(
            'Video Options',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                _shareVideo();
              },
              child: const Text('Share Video'),
            ),
            if (isOwnPost)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _confirmDeleteReel(widget.post.id);
                },
                child: const Text('Delete Reel'),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(sheetContext),
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  void _confirmDeleteReel(dynamic reelId) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Delete Reel?'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'This action cannot be undone. Are you sure you want to delete this reel?',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(dialogContext);
                if (reelId != null) {
                  final bool success =
                      await deletePostRxObj.deletePost(reelId);
                  if (success) {
                    ToastUtil.showShortToast('Reel deleted successfully');
                    widget.onDelete?.call();
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    ToastUtil.showShortToast(
                      'Failed to delete reel. Please try again.',
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    dynamic postId;
    try {
      postId = widget.post.id;
    } catch (_) {
      postId = null;
    }

    if (postId == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ReelCommentsBottomSheet(
          postId: postId,
          initialCommentsCount: _commentsCount,
          onCommentCountChanged: (newCount) {
            if (mounted) {
              setState(() {
                _commentsCount = newCount;
              });
            }
          },
        );
      },
    );
  }

  Widget _buildActionItem({
    IconData? icon,
    String? imagePath,
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
                  color: iconColor,
                )
              : Transform.scale(
                  scaleX: iconScaleX,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: size,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? get _soundTitle {
    try {
      return (widget.post as dynamic).sound?.title?.toString();
    } catch (_) {
      return null;
    }
  }

  String? get _soundThumbnailUrl {
    try {
      return (widget.post as dynamic).sound?.thumbnailUrl?.toString();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = widget.post.user?.avatar ?? '';
    final String userName = widget.post.user?.name ?? 'User';
    final String userHandle = '@${widget.post.user?.username ?? 'username'}';
    final String caption = widget.post.caption ?? '';

    return Material(
      color: Colors.black,
      child: GestureDetector(
        onDoubleTapDown: _handleDoubleTap,
        onDoubleTap: () {},
        onTap: _togglePlayPause,
        child: Stack(
          children: [
            // ---------------- Video Background ----------------
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: widget.isInitialized && widget.controller != null
                    ? FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: widget.controller!.value.size.width > 0
                              ? widget.controller!.value.size.width
                              : 1080,
                          height: widget.controller!.value.size.height > 0
                              ? widget.controller!.value.size.height
                              : 1920,
                          child: VideoPlayer(widget.controller!),
                        ),
                      )
                    : (widget.hasError
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.white54,
                                size: 52.r,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'Unable to load video',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              ElevatedButton(
                                onPressed: widget.onRetry,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9F75FF),
                                ),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF9F75FF),
                            ),
                          )),
              ),
            ),

            // ---------------- Gradient Overlay ----------------
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ---------------- Persistent Play Icon When Paused ----------------
            if (widget.isInitialized &&
                widget.controller != null &&
                !widget.controller!.value.isPlaying &&
                !_showRipple)
              Center(
                child: Container(
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 52.r,
                  ),
                ),
              ),

            // ---------------- Tap Play/Pause Ripple ----------------
            if (_showRipple)
              Center(
                child: AnimatedBuilder(
                  animation: _playPauseAnimController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _playPauseScale.value,
                      child: Opacity(
                        opacity: _playPauseOpacity.value,
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _rippleIcon,
                            color: Colors.white,
                            size: 56.r,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // ---------------- Double Tap Heart Pop Overlay ----------------
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

            // ---------------- Bottom Left User Details ----------------
            Positioned(
              bottom: 24.h,
              left: 16.w,
              right: 76.w,
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: const Color(0xFF2A2A3A),
                          backgroundImage: avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl.isEmpty
                              ? const Icon(Icons.person, color: Colors.white70)
                              : null,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5.sp,
                                ),
                              ),
                              Text(
                                userHandle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (caption.trim().isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        caption.trim(),
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                    if (_soundTitle != null && _soundTitle!.trim().isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            color: Colors.white70,
                            size: 14,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              _soundTitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 12.h),
                    if (widget.isInitialized && widget.controller != null)
                      VideoProgressIndicator(
                        widget.controller!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Color(0xFF9F75FF),
                          bufferedColor: Colors.white30,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ---------------- Right Vertical Action Sidebar ----------------
            Positioned(
              bottom: 24.h,
              right: 16,
              child: SafeArea(
                top: false,
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionItem(
                    icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                    iconColor:
                        _isLiked ? const Color(0xFFFF3F55) : Colors.white,
                    label: '$_likeCount',
                    onTap: _triggerLike,
                  ),
                  const SizedBox(height: 16),

                  _buildActionItem(
                    imagePath: 'assets/images/mesagenva.png',
                    label: '$_commentsCount',
                    onTap: () => _showCommentsBottomSheet(context),
                  ),
                  const SizedBox(height: 16),

                  _buildActionItem(
                    imagePath: 'assets/images/ShareIcon.png',
                    icon: Icons.reply,
                    label: '${widget.post.sharesCount ?? ''}',
                    iconScaleX: -1.0,
                    onTap: () => _showVideoOptions(context),
                  ),
                  const SizedBox(height: 16),

                  // Rotating Music Disc (No Gift Icon)
                  RotationTransition(
                    turns: _musicController,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: _soundThumbnailUrl != null &&
                              _soundThumbnailUrl!.isNotEmpty
                          ? CircleAvatar(
                              radius: 10.r,
                              backgroundImage: NetworkImage(
                                _soundThumbnailUrl!,
                              ),
                            )
                          : const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
