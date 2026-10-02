import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:stevenako_flutter/features/home/model/hom_screen_reals_model.dart';
import 'package:stevenako_flutter/features/home/presentation/widgets/reel_comments_bottom_sheet.dart';
import 'package:stevenako_flutter/features/home/presentation/widgets/home_report_bottom_sheet.dart';
import 'package:stevenako_flutter/features/profile/presentation/profile_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/my_wallet_screen.dart';
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:google_fonts/google_fonts.dart';

class ReelsSubScreen extends StatefulWidget {
  final bool isActive;
  final String? mentorId;

  const ReelsSubScreen({
    super.key,
    this.isActive = true,
    this.mentorId,
  });

  @override
  State<ReelsSubScreen> createState() => _ReelsSubScreenState();
}

class _ReelsSubScreenState extends State<ReelsSubScreen> {
  final PreloadPageController _pageController = PreloadPageController();
  int _currentPage = 0;
  bool _isVisible = true;
  bool _isLoading = true;
  bool _hasUserStartedPlayback = true;

  final Map<int, VideoPlayerController> _controllers = {};
  final Map<int, bool> _initializedStates = {};
  final Map<int, bool> _errorStates = {};

  List<Map<String, dynamic>> _reelsData = [];

  Timer? _viewCountTimer;
  final Set<int> _recordedViewPostIds = {};

  @override
  void initState() {
    super.initState();
    _fetchReels();
  }

  void _startViewCountTimer() {
    _cancelViewCountTimer();

    if (!widget.isActive || !_isVisible) return;
    if (_reelsData.isEmpty || _currentPage < 0 || _currentPage >= _reelsData.length) return;

    final currentItem = _reelsData[_currentPage];
    final dynamic rawId = currentItem['id'];
    final int? postId = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');

    if (postId == null || _recordedViewPostIds.contains(postId)) {
      return;
    }

    final int targetPage = _currentPage;

    _viewCountTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      if (!widget.isActive || !_isVisible) return;
      if (_currentPage != targetPage) return;
      if (_recordedViewPostIds.contains(postId)) return;

      _recordedViewPostIds.add(postId);
      reelsCountRxObj.recordPostView(postId: postId);
    });
  }

  void _cancelViewCountTimer() {
    _viewCountTimer?.cancel();
    _viewCountTimer = null;
  }

  void _clearAllControllers() {
    _cancelViewCountTimer();
    _controllers.forEach((_, controller) {
      try {
        controller.pause();
        controller.dispose();
      } catch (e) {
        debugPrint('Error disposing controller: $e');
      }
    });
    _controllers.clear();
    _initializedStates.clear();
    _errorStates.clear();
  }

  Future<void> _fetchReels() async {
    if (!mounted) return;

    // Dispose old video controllers before loading new data to prevent surface buffer leaks
    _clearAllControllers();

    setState(() {
      _isLoading = true;
    });

    final GetReelsListModel? response = await getReelsRxObj.getReels(
      mentorId: widget.mentorId,
    );

    if (mounted) {
      final posts = response?.data?.posts?.data ?? [];
      final converted = _convertPostsToReels(posts);
      setState(() {
        _reelsData = converted;
        _isLoading = false;
        _currentPage = 0;
      });

      if (_reelsData.isNotEmpty) {
        _initControllerForIndex(0);
        _initControllerForIndex(1);
        _startViewCountTimer();
      }
    }
  }

  List<Map<String, dynamic>> _convertPostsToReels(List<ReelItem> posts) {
    if (posts.isEmpty) {
      return [];
    }

    return posts.map((post) {
      String videoUrl = '';
      String mediaType = 'video';
      final bool isAd = post.itemType == 'ad' || post.type == 'ad';

      final List<String> availableUrls = [];

      if (post.media != null && post.media!.isNotEmpty) {
        for (final m in post.media!) {
          if (m.mediaUrl != null && m.mediaUrl!.trim().isNotEmpty) {
            availableUrls.add(m.mediaUrl!.trim());
          }
        }

        final validMedia = post.media!.firstWhere(
          (m) =>
              m.mediaUrl != null &&
              m.mediaUrl!.trim().isNotEmpty &&
              !m.mediaUrl!.contains('mixkit.co'),
          orElse: () => post.media!.lastWhere(
            (m) => m.mediaUrl != null && m.mediaUrl!.trim().isNotEmpty,
            orElse: () => post.media!.first,
          ),
        );
        if (validMedia.mediaUrl != null &&
            validMedia.mediaUrl!.trim().isNotEmpty) {
          videoUrl = validMedia.mediaUrl!.trim();
        }
        if (validMedia.mediaType != null &&
            validMedia.mediaType!.isNotEmpty) {
          mediaType = validMedia.mediaType!;
        }
      } else if (post.mediaUrl != null && post.mediaUrl!.trim().isNotEmpty) {
        videoUrl = post.mediaUrl!.trim();
        availableUrls.add(videoUrl);
        if (post.mediaType != null && post.mediaType!.isNotEmpty) {
          mediaType = post.mediaType!;
        }
      }

      final String lowerUrl = videoUrl.toLowerCase();
      final bool isImageMedia = mediaType.toLowerCase() == 'image' ||
          lowerUrl.endsWith('.jpg') ||
          lowerUrl.endsWith('.jpeg') ||
          lowerUrl.endsWith('.png') ||
          lowerUrl.endsWith('.webp') ||
          lowerUrl.contains('unsplash.com');

      if (videoUrl.isEmpty) {
        videoUrl =
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
      }

      final String userName = isAd
          ? (post.title ?? 'Sponsored')
          : (post.user?.name ?? 'Anonymous');
      final String userHandle = isAd
          ? '@sponsored'
          : '@${post.user?.username ?? 'user'}';
      final String avatar = post.user?.avatar ??
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80';
      final String caption = post.caption ?? post.title ?? '';

      final dynamic savedUserId =
          appData.read('user_id') ?? appData.read(kKeyUserID);
      final dynamic profileUserId =
          getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
      final String? currentIdStr =
          (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
              ? savedUserId.toString().trim()
              : profileUserId?.toString().trim();
      final String? postUserIdStr = post.user?.id?.toString().trim();
      final bool isSelf = post.isMyPost == true ||
          (currentIdStr != null &&
              postUserIdStr != null &&
              currentIdStr == postUserIdStr);

      return <String, dynamic>{
        'id': post.id,
        'userId': post.user?.id,
        'isSelf': isSelf,
        'isMyPost': post.isMyPost == true || isSelf,
        'itemType': isAd ? 'ad' : 'post',
        'isAd': isAd,
        'isImage': isImageMedia,
        'targetUrl': post.targetUrl ?? '',
        'userName': userName,
        'userHandle': userHandle,
        'caption': caption,
        'avatar': avatar,
        'likes': post.likesCount ?? 0,
        'comments': post.commentsCount ?? 0,
        'videoUrl': videoUrl,
        'fallbackUrls': availableUrls,
        'isNetwork': true,
        'musicTitle': isAd ? 'Sponsored Content' : 'Original Sound - $userName',
        'isLiked': post.isLiked ?? false,
        'isFollow': post.user?.isFollow ?? false,
      };
    }).toList();
  }

  @override
  void didUpdateWidget(covariant ReelsSubScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && _isVisible) {
        _startViewCountTimer();
      } else {
        _cancelViewCountTimer();
      }

      final currentItem = _reelsData.isNotEmpty && _currentPage < _reelsData.length
          ? _reelsData[_currentPage]
          : null;
      final bool isImage = currentItem?['isImage'] ?? false;

      if (!isImage) {
        if (widget.isActive && _isVisible && _hasUserStartedPlayback) {
          _controllers[_currentPage]?.play();
        } else {
          _controllers[_currentPage]?.pause();
        }
      }
    }
  }

  void _initControllerForIndex(int index) {
    if (index < 0 || index >= _reelsData.length) return;
    if (_controllers.containsKey(index)) return;

    final item = _reelsData[index];
    final bool isImage = item['isImage'] ?? false;

    // Do NOT instantiate video controllers for image posts/ads
    if (isImage) {
      _initializedStates[index] = false;
      _errorStates[index] = false;
      return;
    }

    final bool isNetwork = item['isNetwork'] ?? true;
    String source = item['videoUrl'] ?? '';
    final List<dynamic> fallbackUrls = item['fallbackUrls'] ?? [];

    if (source.isEmpty && fallbackUrls.isNotEmpty) {
      source = fallbackUrls.firstWhere(
        (u) =>
            u.toString().trim().isNotEmpty &&
            !u.toString().contains('mixkit.co'),
        orElse: () => fallbackUrls.first.toString(),
      );
      item['videoUrl'] = source;
    }

    if (source.isEmpty) {
      _errorStates[index] = true;
      return;
    }

    try {
      final controller = isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(source))
          : VideoPlayerController.asset(source);

      _controllers[index] = controller;

      controller
          .initialize()
          .then((_) {
            if (!mounted) return;

            // If controller was removed while initializing, dispose immediately
            if (_controllers[index] != controller) {
              controller.dispose();
              return;
            }

            controller.setLooping(true);
            if (!mounted) return;
            setState(() {
              _initializedStates[index] = true;
              _errorStates[index] = false;
            });
            if (index == _currentPage &&
                widget.isActive &&
                _isVisible &&
                _hasUserStartedPlayback) {
              controller.play();
            }
          })
          .catchError((error) {
            debugPrint('Preload error for video index $index ($source): $error');
            if (!mounted) return;
            controller.dispose();
            _controllers.remove(index);

            // If this video has an alternative working URL, retry automatically
            final nextFallback = fallbackUrls.firstWhere(
              (u) =>
                  u.toString().trim().isNotEmpty &&
                  u.toString().trim() != source &&
                  !u.toString().contains('mixkit.co'),
              orElse: () => '',
            );
            if (nextFallback.toString().isNotEmpty) {
              item['videoUrl'] = nextFallback.toString();
              _initControllerForIndex(index);
              return;
            }

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
    _cancelViewCountTimer();
    if (!_hasUserStartedPlayback) {
      _hasUserStartedPlayback = true;
    }

    // Pause all previous controllers
    _controllers.forEach((idx, ctrl) {
      if (idx != newIndex) {
        ctrl.pause();
      }
    });

    setState(() {
      _currentPage = newIndex;
    });

    _startViewCountTimer();

    final currentItem = newIndex < _reelsData.length ? _reelsData[newIndex] : null;
    final bool isImage = currentItem?['isImage'] ?? false;

    if (!isImage) {
      final currentController = _controllers[newIndex];
      if (currentController != null &&
          _initializedStates[newIndex] == true &&
          widget.isActive &&
          _isVisible) {
        currentController.play();
      } else {
        _initControllerForIndex(newIndex);
      }

      // Preload only next adjacent video to avoid hardware decoder limit on Android
      if (newIndex + 1 < _reelsData.length) {
        _initControllerForIndex(newIndex + 1);
      }
    }

    // Immediately dispose distant controllers to keep at most 2 surface buffers active
    _cleanupControllers(newIndex);
  }

  void _cleanupControllers(int currentIndex) {
    final keysToRemove = <int>[];
    _controllers.forEach((index, controller) {
      // Keep only active index and next index
      if (index != currentIndex && index != currentIndex + 1) {
        try {
          controller.pause();
          controller.dispose();
        } catch (e) {
          debugPrint('Error disposing controller at $index: $e');
        }
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
    _cancelViewCountTimer();
    _clearAllControllers();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    debugPrint('mentorId: ${widget.mentorId}');
    if (_isLoading && _reelsData.isEmpty) {
      return const ReelsSkeletonLoader();
    }

    // Professional Empty State if no reels are returned from API
    if (!_isLoading && _reelsData.isEmpty) {
      return ReelsEmptyStateWidget(onRefresh: _fetchReels);
    }

    return VisibilityDetector(
      key: const Key('reels-sub-screen-visibility-key'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        final bool isVisibleNow = info.visibleFraction > 0.1;
        if (_isVisible != isVisibleNow) {
          setState(() {
            _isVisible = isVisibleNow;
          });
          if (isVisibleNow && widget.isActive) {
            _startViewCountTimer();
          } else {
            _cancelViewCountTimer();
          }
          final currentItem =
              _reelsData.isNotEmpty && _currentPage < _reelsData.length
                  ? _reelsData[_currentPage]
                  : null;
          final bool isImage = currentItem?['isImage'] ?? false;

          if (!isImage) {
            if (_isVisible && widget.isActive && _hasUserStartedPlayback) {
              _controllers[_currentPage]?.play();
            } else {
              _controllers[_currentPage]?.pause();
            }
          }
        }
      },
      child: RefreshIndicator(
        color: const Color(0xFF8B5CF6),
        backgroundColor: Colors.black,
        onRefresh: _fetchReels,
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
              onDelete: _fetchReels,
              onStartPlayback: () {
                if (!_hasUserStartedPlayback) {
                  setState(() {
                    _hasUserStartedPlayback = true;
                  });
                }
              },
            );
          },
        ),
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
  final VoidCallback? onStartPlayback;
  final VoidCallback? onDelete;

  const ReelPageItem({
    super.key,
    required this.data,
    required this.isActive,
    this.videoController,
    this.isVideoInitialized = false,
    this.hasError = false,
    required this.onRetry,
    this.onStartPlayback,
    this.onDelete,
  });

  @override
  State<ReelPageItem> createState() => _ReelPageItemState();
}

class _ReelPageItemState extends State<ReelPageItem>
    with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _isFollowing = false;
  late int _likeCount;

  late AnimationController _musicController;
  late AnimationController _playPauseAnimController;
  late Animation<double> _playPauseScale;
  late Animation<double> _playPauseOpacity;

  bool _showPlayPauseRipple = false;
  IconData _playPauseIcon = Icons.pause_rounded;

  double? _coinAnimX;
  double? _coinAnimY;
  bool _showCoinAnim = false;

  double? _heartPopX;
  double? _heartPopY;
  bool _showHeartPop = false;
  double _likeButtonScale = 1.0;

  final List<_FloatingHeart> _floatingHearts = [];

  void _spawnFloatingHearts(double startX, double startY) {
    final random = math.Random();
    final List<Color> heartColors = [
      const Color(0xFFFF3F55),
      const Color(0xFFFF4D6D),
      const Color(0xFFFF758F),
      const Color(0xFFFF2A4B),
      const Color(0xFFE91E63),
      const Color(0xFFFF85A1),
    ];

    for (int i = 0; i < 2; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (!mounted) return;

        final heart = _FloatingHeart(
          id: UniqueKey(),
          x: startX + (random.nextDouble() * 20 - 10),
          y: startY + (random.nextDouble() * 12 - 6),
          size: 28 + random.nextDouble() * 16,
          color: heartColors[random.nextInt(heartColors.length)],
          angle: (random.nextDouble() * 0.4 - 0.2),
        );

        setState(() {
          _floatingHearts.add(heart);
        });

        Future.delayed(const Duration(milliseconds: 3200), () {
          if (mounted) {
            setState(() {
              _floatingHearts.removeWhere((item) => item.id == heart.id);
            });
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likeCount = widget.data['likes'] ?? 0;
    _isLiked = widget.data['isLiked'] ?? false;
    _isFollowing = widget.data['isFollow'] ?? false;

    _musicController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _playPauseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _playPauseScale = Tween<double>(begin: 0.6, end: 1.25).animate(
      CurvedAnimation(
        parent: _playPauseAnimController,
        curve: Curves.easeOutBack,
      ),
    );

    _playPauseOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 30,
      ),
    ]).animate(_playPauseAnimController);
  }

  @override
  void dispose() {
    _musicController.dispose();
    _playPauseAnimController.dispose();
    super.dispose();
  }

  void _triggerLike({TapDownDetails? details}) async {
    final bool isAd = widget.data['isAd'] ?? false;
    final dynamic postId = widget.data['id'];

    final bool previousIsLiked = _isLiked;
    final int previousLikeCount = _likeCount;

    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likeCount++ : _likeCount--;
      _likeButtonScale = 1.35;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _likeButtonScale = 1.0;
        });
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double startX = details?.globalPosition.dx ?? (screenWidth - 38.w);
    final double startY = details?.globalPosition.dy ?? (screenHeight - 340.h);

    _spawnFloatingHearts(startX, startY);

    if (!isAd && postId != null) {
      final res = await userPostLikeRxObj.toggleLike(postId: postId);
      if (mounted) {
        if (res != null && res.data != null) {
          setState(() {
            _isLiked = res.data!.isLiked ?? _isLiked;
            _likeCount = res.data!.likesCount ?? _likeCount;
          });
        } else {
          // Revert optimistic update gracefully on error
          setState(() {
            _isLiked = previousIsLiked;
            _likeCount = previousLikeCount;
          });
        }
      }
    }
  }

  void _togglePlayPause() {
    final bool isImage = widget.data['isImage'] ?? false;
    if (isImage) return;

    final controller = widget.videoController;
    if (controller == null || !widget.isVideoInitialized) return;
    if (widget.onStartPlayback != null) {
      widget.onStartPlayback!();
    }

    final bool isCurrentlyPlaying = controller.value.isPlaying;

    if (isCurrentlyPlaying) {
      controller.pause();
      _playPauseIcon = Icons.pause_rounded;
    } else {
      controller.play();
      _playPauseIcon = Icons.play_arrow_rounded;
    }

    setState(() {
      _showPlayPauseRipple = true;
    });

    _playPauseAnimController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _showPlayPauseRipple = false;
        });
      }
    });
  }

  void _triggerCoins(TapDownDetails details) {
    setState(() {
      _coinAnimX = details.globalPosition.dx;
      _coinAnimY = details.globalPosition.dy;
      _showCoinAnim = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showCoinAnim = false;
        });
      }
    });
  }

  void _handleDoubleTap(TapDownDetails details) async {
    final bool previousIsLiked = _isLiked;
    final int previousLikeCount = _likeCount;

    setState(() {
      _heartPopX = details.globalPosition.dx;
      _heartPopY = details.globalPosition.dy;
      _showHeartPop = true;
      if (!_isLiked) {
        _isLiked = true;
        _likeCount++;
      }
    });

    _spawnFloatingHearts(details.globalPosition.dx, details.globalPosition.dy);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _showHeartPop = false;
        });
      }
    });

    final bool isAd = widget.data['isAd'] ?? false;
    final dynamic postId = widget.data['id'];

    if (!previousIsLiked && !isAd && postId != null) {
      final res = await userPostLikeRxObj.toggleLike(postId: postId);
      if (mounted) {
        if (res != null && res.data != null) {
          setState(() {
            _isLiked = res.data!.isLiked ?? _isLiked;
            _likeCount = res.data!.likesCount ?? _likeCount;
          });
        } else {
          // Revert optimistic update gracefully on error
          setState(() {
            _isLiked = previousIsLiked;
            _likeCount = previousLikeCount;
          });
        }
      }
    }
  }

  Future<void> _launchUrlStr(String urlStr) async {
    if (urlStr.isEmpty) return;
    try {
      final Uri uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening link: $urlStr'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _shareVideo() {
    final String userHandle = widget.data['userHandle'] ?? '@user';
    final String caption = widget.data['caption'] ?? '';
    final String videoUrl = widget.data['videoUrl'] ?? '';
    final String shareText =
        'Watch this reel by $userHandle on StevenAko!\n\n"$caption"\n\n$videoUrl';

    _showShareBottomSheet(context, shareText);
  }

  void _showShareBottomSheet(BuildContext context, String shareText) {
    final dynamic savedUserId =
        appData.read('user_id') ?? appData.read(kKeyUserID);
    final dynamic profileUserId =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
    final String? currentIdStr =
        (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
            ? savedUserId.toString().trim()
            : profileUserId?.toString().trim();
    final String? postUserIdStr = widget.data['userId']?.toString().trim();
    final bool isOwnPost = widget.data['isSelf'] == true ||
        widget.data['isMyPost'] == true ||
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
                Clipboard.setData(ClipboardData(text: shareText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video link copied to clipboard!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.doc_on_doc, size: 20),
                  SizedBox(width: 8),
                  Text('Copy Video Link'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                SharePlus.instance.share(ShareParams(text: shareText));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.share_up, size: 20),
                  SizedBox(width: 8),
                  Text('Share via App...'),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video sent in message!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.chat_bubble, size: 20),
                  SizedBox(width: 8),
                  Text('Send in Message'),
                ],
              ),
            ),
            if (isOwnPost)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _confirmDeleteReel(widget.data['id']);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.delete,
                        size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Delete Reel'),
                  ],
                ),
              ),
            if (!isOwnPost) ...[
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  HomeReportBottomSheet.show(context, postId: widget.data['id']);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.exclamationmark_triangle,
                        size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Report Reel'),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  final authorId = widget.data['userId'];
                  final authorName = widget.data['userName'] ?? widget.data['userHandle'] ?? 'User';
                  if (authorId != null) {
                    _confirmBlockUser(authorId.toString(), authorName.toString());
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.slash_circle,
                        size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Block User'),
                  ],
                ),
              ),
            ],
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

  void _confirmBlockUser(String userId, String username) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text('Block @$username?'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'They will no longer be able to message you, view your profile, or see your posts. You will not see their reels in your feed.',
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
                final res = await blockOrUnblockUserRxObj.blockOrUnblockUser(userId);
                if (res != null) {
                  ToastUtil.showShortToast('User blocked successfully');
                  widget.onDelete?.call();
                } else {
                  ToastUtil.showShortToast('Failed to block user. Please try again.');
                }
              },
              child: const Text('Block'),
            ),
          ],
        );
      },
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final dynamic postId = widget.data['id'];
    final int initialCount = (widget.data['comments'] as int?) ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return ReelCommentsBottomSheet(
          postId: postId,
          initialCommentsCount: initialCount,
          onCommentCountChanged: (newCount) {
            if (mounted) {
              setState(() {
                widget.data['comments'] = newCount;
              });
            }
          },
        );
      },
    );
  }

  void _showTipsBottomSheet(BuildContext context) {
    final dynamic creatorId = widget.data['userId'];
    final dynamic postId = widget.data['id'];
    final String userName = widget.data['userName'] ?? 'Creator';
    final String userHandle = widget.data['userHandle'] ?? '';
    final String avatar = widget.data['avatar'] ?? '';
    final bool isAd = widget.data['isAd'] ?? false;

    final dynamic savedUserId =
        appData.read('user_id') ?? appData.read(kKeyUserID);
    final dynamic profileUserId =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
    final String? currentIdStr =
        (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
            ? savedUserId.toString().trim()
            : profileUserId?.toString().trim();
    final String? creatorIdStr = creatorId?.toString().trim();

    final bool isSelf = widget.data['isSelf'] == true ||
        (currentIdStr != null &&
            creatorIdStr != null &&
            currentIdStr == creatorIdStr);

    if (isAd) {
      ToastUtil.showShortToast('Sponsored content cannot receive tips');
      return;
    }

    if (isSelf) {
      ToastUtil.showShortToast('You cannot send a tip to your own reel');
      return;
    }

    // Refresh wallet in background
    getWalletRxObj.getWallet();

    final List<int> presetAmounts = [1, 5, 10, 20, 50];
    int selectedAmount = 5;
    bool isCustom = false;
    final TextEditingController customController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF1B182B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final wallet = getWalletRxObj.dataFetcher.valueOrNull?.data?.wallet;
            final availableBalance = wallet?.availableBalance ?? 0;
            final currency = wallet?.currency ?? 'EUR';
            final symbol = currency == 'EUR'
                ? '€'
                : (currency == 'USD' ? '\$' : '$currency ');

            num effectiveAmount = selectedAmount;
            if (isCustom) {
              final parsed = num.tryParse(customController.text.trim());
              effectiveAmount = (parsed != null && parsed > 0) ? parsed : 0;
            }

            return SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(22.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // Header with Creator details
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.5.r),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 22.r,
                              backgroundColor: const Color(0xFF27273A),
                              backgroundImage: avatar.isNotEmpty
                                  ? CachedNetworkImageProvider(avatar)
                                  : null,
                              child: avatar.isEmpty
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                      size: 20.sp,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Send Tip',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16.5.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Image.asset(
                                      'assets/images/gift.png',
                                      height: 18.h,
                                      width: 18.w,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'To $userName ($userHandle)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white38,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),

                      // Wallet Balance Banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27273A).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED)
                                        .withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: const Color(0xFF9F75FF),
                                    size: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Wallet Balance',
                                      style: GoogleFonts.inter(
                                        color: Colors.white60,
                                        fontSize: 11.5.sp,
                                      ),
                                    ),
                                    Text(
                                      '$symbol$availableBalance',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14.5.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MyWalletScreen(),
                                  ),
                                );
                                await getWalletRxObj.getWallet();
                                if (sheetContext.mounted) {
                                  setModalState(() {});
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: const Color(0xFF9F75FF)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: const Color(0xFF9F75FF),
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Top Up',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF9F75FF),
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Select Amount Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Tip Amount',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Preset Amount Chips + Custom Button
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double itemWidth =
                              (constraints.maxWidth - (2 * 10.w)) / 3;
                          return Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: [
                              ...presetAmounts.map((amt) {
                                final isSelected =
                                    !isCustom && selectedAmount == amt;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      isCustom = false;
                                      selectedAmount = amt;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    width: itemWidth,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF7C3AED),
                                                Color(0xFF402380),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: isSelected
                                          ? null
                                          : const Color(0xFF27273A)
                                              .withValues(alpha: 0.5),
                                      borderRadius:
                                          BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF9F75FF)
                                            : Colors.white.withValues(
                                                alpha: 0.08,
                                              ),
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF7C3AED)
                                                    .withValues(alpha: 0.4),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/dolor.png',
                                          width: 14.w,
                                          height: 14.h,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '$symbol$amt',
                                          style: GoogleFonts.inter(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white70,
                                            fontSize: 14.5.sp,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    isCustom = true;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: itemWidth,
                                  padding:
                                      EdgeInsets.symmetric(vertical: 12.h),
                                  decoration: BoxDecoration(
                                    gradient: isCustom
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF7C3AED),
                                              Color(0xFF402380),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isCustom
                                        ? null
                                        : const Color(0xFF27273A)
                                            .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: isCustom
                                          ? const Color(0xFF9F75FF)
                                          : Colors.white.withValues(
                                              alpha: 0.08,
                                            ),
                                      width: isCustom ? 1.5 : 1,
                                    ),
                                    boxShadow: isCustom
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF7C3AED)
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Custom',
                                    style: GoogleFonts.inter(
                                      color: isCustom
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: 13.5.sp,
                                      fontWeight: isCustom
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      if (isCustom) ...[
                        SizedBox(height: 14.h),
                        TextField(
                          controller: customController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (_) => setModalState(() {}),
                          decoration: InputDecoration(
                            prefixText: '$symbol ',
                            prefixStyle: GoogleFonts.inter(
                              color: const Color(0xFF9F75FF),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Enter custom tip (e.g. 15)',
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 13.sp,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF27273A)
                                .withValues(alpha: 0.5),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(
                                color: const Color(0xFF7C3AED)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: const BorderSide(
                                color: Color(0xFF9F75FF),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 24.h),

                      // Send Tip Button
                      ValueListenableBuilder<bool>(
                        valueListenable: sentTipRxObj.isLoading,
                        builder: (context, isLoading, child) {
                          final isInsufficient =
                              effectiveAmount > availableBalance;

                          return SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7C3AED),
                                    Color(0xFF402380),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7C3AED)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (effectiveAmount <= 0) {
                                          ToastUtil.showShortToast(
                                            'Please select or enter a valid amount',
                                          );
                                          return;
                                        }

                                        if (isInsufficient) {
                                          ToastUtil.showShortToast(
                                            'Insufficient balance ($symbol$availableBalance). Please top up your wallet.',
                                          );
                                          return;
                                        }

                                        final response =
                                            await sentTipRxObj.sendTip(
                                          creatorId: creatorId,
                                          amount: effectiveAmount,
                                          postId: postId,
                                        );

                                        if (response?.success == true &&
                                            sheetContext.mounted) {
                                          Navigator.pop(sheetContext);

                                          // Celebratory coin burst on screen
                                          final screenSize =
                                              MediaQuery.of(context).size;
                                          setState(() {
                                            _coinAnimX = screenSize.width / 2;
                                            _coinAnimY =
                                                screenSize.height / 2;
                                            _showCoinAnim = true;
                                          });

                                          Future.delayed(
                                            const Duration(milliseconds: 1200),
                                            () {
                                              if (mounted) {
                                                setState(() {
                                                  _showCoinAnim = false;
                                                });
                                              }
                                            },
                                          );

                                          getWalletRxObj.getWallet();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/gift.png',
                                            height: 20.h,
                                            width: 20.w,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            effectiveAmount > 0
                                                ? 'Send $symbol$effectiveAmount Tip'
                                                : 'Send Tip',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isImage = widget.data['isImage'] ?? false;
    final bool isAd = widget.data['isAd'] ?? false;
    final String targetUrl = widget.data['targetUrl'] ?? '';

    final dynamic savedUserId =
        appData.read('user_id') ?? appData.read(kKeyUserID);
    final dynamic profileUserId =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
    final String? currentIdStr =
        (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
            ? savedUserId.toString().trim()
            : profileUserId?.toString().trim();
    final String? postUserIdStr = widget.data['userId']?.toString().trim();
    final bool isSelf = widget.data['isSelf'] == true ||
        (currentIdStr != null &&
            postUserIdStr != null &&
            currentIdStr == postUserIdStr);
    final bool isOwnPost = isSelf;

    return Material(
      color: Colors.black,
      child: GestureDetector(
        onDoubleTapDown: _handleDoubleTap,
        onDoubleTap: () {},
        onTap: _togglePlayPause,
        child: Stack(
        children: [
          // Background content (Video or Image)
          Positioned.fill(
            child: isImage
                ? Image.network(
                    widget.data['videoUrl'],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF3F55),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                color: Colors.white54,
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Unable to load image',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : (widget.isVideoInitialized && widget.videoController != null
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
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        size: 18,
                                      ),
                                      label: const Text('Retry'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFF3F55),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const CircularProgressIndicator(
                                  color: Color(0xFFFF3F55),
                                ),
                        ),
                      )),
          ),

          // Vignette gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.2, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Sponsored/Ad Tag Badge
          if (isAd)
            Positioned(
              top: MediaQuery.of(context).padding.top + 60.h,
              left: 16.w,
              child: SafeArea(
                bottom: false,
                right: false,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'SPONSORED',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Instagram-style Animated Center Play/Pause Feedback & Persistent Paused State
          if (!isImage) ...[
            // 1) Animated Pop Ripple on Tap (Play / Pause icon scaling and fading out)
            if (_showPlayPauseRipple)
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
                            color: Colors.black.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            _playPauseIcon,
                            color: Colors.white,
                            size: 48.r,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // 2) Persistent Center Play Icon when video is paused (and ripple is done)
            if (!_showPlayPauseRipple &&
                widget.videoController != null &&
                widget.isVideoInitialized &&
                !widget.videoController!.value.isPlaying)
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 52.r,
                  ),
                ),
              ),
          ],

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final dynamic rawUserId = widget.data['userId'];
                        final int? userId = rawUserId is int
                            ? rawUserId
                            : int.tryParse(rawUserId?.toString() ?? '');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(userId: userId),
                          ),
                        );
                      },
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.data['avatar'] ?? '',
                          width: 40.r,
                          height: 40.r,
                          fit: BoxFit.cover,

                          // Shimmer while loading
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 40.r,
                              height: 40.r,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),

                          // Image load error
                          errorWidget: (context, url, error) => Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 22.r,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          final dynamic rawUserId = widget.data['userId'];
                          final int? userId = rawUserId is int
                              ? rawUserId
                              : int.tryParse(rawUserId?.toString() ?? '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(userId: userId),
                            ),
                          );
                        },
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
                    ),
                    SizedBox(width: 11.w),
                    if (!isAd && !isOwnPost)
                      GestureDetector(
                        onTap: () async {
                          final int? targetUserId = widget.data['userId'];
                          if (mounted) {
                            setState(() {
                              _isFollowing = !_isFollowing;
                            });
                          }
                          if (targetUserId != null) {
                            final res =
                                await postFlowRxObj.post(userId: targetUserId);
                            if (res == null || res.success != true) {
                              if (mounted) {
                                setState(() {
                                  _isFollowing = !_isFollowing;
                                });
                              }
                            }
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          constraints: BoxConstraints(minWidth: 74.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isFollowing
                                ? Colors.white24
                                : const Color(0xFFFF3F55),
                            borderRadius: BorderRadius.circular(8.r),
                            border: _isFollowing
                                ? Border.all(color: Colors.white30)
                                : null,
                          ),
                          child: Text(
                            _isFollowing ? 'Following' : 'Follow',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isFollowing
                                  ? Colors.white70
                                  : Colors.white,
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
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                if (isAd && targetUrl.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () => _launchUrlStr(targetUrl),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Learn More',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                AnimatedScale(
                  scale: _likeButtonScale,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  child: _buildActionItem(
                    icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                    iconColor:
                        _isLiked ? const Color(0xFFFF3F55) : Colors.white,
                    label: '$_likeCount',
                    onTapDown: (details) => _triggerLike(details: details),
                  ),
                ),
                const SizedBox(height: 16),

                _buildActionItem(
                  imagePath: 'assets/images/mesagenva.png',
                  label: '${widget.data['comments']}',
                  onTap: () => _showCommentsBottomSheet(context),
                ),
                const SizedBox(height: 16),

                _buildActionItem(
                  imagePath: 'assets/images/ShareIcon.png',
                  icon: Icons.reply,
                  label: '',
                  iconScaleX: -1.0,
                  onTap: _shareVideo,
                ),
                if (isOwnPost) ...[
                  const SizedBox(height: 16),
                  _buildActionItem(
                    icon: CupertinoIcons.delete,
                    iconColor: const Color(0xFFFF4D4D),
                    label: 'Delete',
                    onTap: () => _confirmDeleteReel(widget.data['id']),
                  ),
                ],
                const SizedBox(height: 16),

                RotationTransition(
                  turns: _musicController,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
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
                if (!isOwnPost && !isAd) ...[
                  const SizedBox(height: 20),
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
                            color:
                                const Color(0xFFD97706).withValues(alpha: 0.4),
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

          // Floating Love Hearts Animation Overlay (Only 2 hearts, floating very slowly to the top before closing)
          ..._floatingHearts.map((heart) {
            return Positioned(
              left: heart.x - heart.size / 2,
              top: heart.y - heart.size / 2,
              child: TweenAnimationBuilder<double>(
                key: heart.id,
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 3200),
                curve: Curves.decelerate,
                builder: (context, val, child) {
                  final translateY = -val * 520.h;
                  final translateX = math.sin(val * math.pi * 3) * 24.w;
                  final scale = val < 0.10
                      ? (val / 0.10)
                      : (1.0 + math.sin((val - 0.10) * math.pi) * 0.2);
                  final opacity = val > 0.70
                      ? ((1.0 - val) / 0.30).clamp(0.0, 1.0)
                      : 1.0;

                  return Transform.translate(
                    offset: Offset(translateX, translateY),
                    child: Transform.rotate(
                      angle: heart.angle,
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Icon(
                            Icons.favorite_rounded,
                            color: heart.color,
                            size: heart.size.r,
                            shadows: [
                              Shadow(
                                color: heart.color.withValues(alpha: 0.7),
                                blurRadius: 14,
                              ),
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
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
                            Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                              size: 16,
                            ),
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
    ),
    );
  }

  Widget _buildActionItem({
    IconData? icon,
    String? imagePath,
    required String label,
    Color iconColor = Colors.white,
    double iconScaleX = 1.0,
    double size = 32,
    VoidCallback? onTap,
    Function(TapDownDetails)? onTapDown,
  }) {
    return GestureDetector(
      onTapDown: onTapDown,
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
              : Icon(
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
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                shadows: [
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
}

class ReelsEmptyStateWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const ReelsEmptyStateWidget({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF8B5CF6),
          backgroundColor: Colors.black,
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 110.r,
                    height: 110.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                          const Color(0xFFFF3F55).withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.video_library_outlined,
                      color: const Color(0xFF8B5CF6),
                      size: 52.r,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'No Reels Available',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'There are no video reels to watch right now.\nSwipe down to refresh or check back later!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13.5.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  ElevatedButton.icon(
                    onPressed: onRefresh,
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 20.r,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Refresh Feed',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      elevation: 6,
                      shadowColor:
                          const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReelsSkeletonLoader extends StatefulWidget {
  const ReelsSkeletonLoader({super.key});

  @override
  State<ReelsSkeletonLoader> createState() => _ReelsSkeletonLoaderState();
}

class _ReelsSkeletonLoaderState extends State<ReelsSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final opacity = 0.2 + (_shimmerController.value * 0.3);
        final shimmerColor = Colors.white.withValues(alpha: opacity);

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned(
                left: 16.w,
                bottom: 40.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: shimmerColor,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: shimmerColor,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              width: 80.w,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: shimmerColor,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: 220.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 160.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16.w,
                bottom: 60.h,
                child: Column(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Column(
                        children: [
                          Container(
                            width: 42.r,
                            height: 42.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: shimmerColor,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            width: 24.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: shimmerColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FloatingHeart {
  final Key id;
  final double x;
  final double y;
  final double size;
  final Color color;
  final double angle;

  _FloatingHeart({
    required this.id,
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.angle,
  });
}
