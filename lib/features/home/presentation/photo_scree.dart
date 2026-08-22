import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/features/home/model/get_all_photo_model.dart';
import 'package:stevenako_flutter/features/home/presentation/post_deatils_screeen.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

// ==========================================
// 2. PHOTOS SUB-SCREEN (Photos Tab)
// ==========================================
class PhotosSubScreen extends StatefulWidget {
  const PhotosSubScreen({super.key});

  @override
  State<PhotosSubScreen> createState() => _PhotosSubScreenState();
}

class _PhotosSubScreenState extends State<PhotosSubScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    await getAllPhotoRxObj.getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Transparent to show background gradient
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 56.h,
        left: 12.w,
        right: 12.w,
      ),
      child: RefreshIndicator(
        onRefresh: _fetchPhotos,
        color: const Color(0xFF7C3AED),
        backgroundColor: const Color(0xFF1E1E2C),
        child: StreamBuilder<GetAllPhotoModel>(
          stream: getAllPhotoRxObj.dataFetcher.stream,
          builder: (context, snapshot) {
            // Error State
            if (snapshot.hasError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _buildErrorView(snapshot.error.toString()),
                ),
              );
            }

            // Loading State (Shimmer)
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return _buildShimmerLoading();
            }

            final GetAllPhotoModel? photoModel = snapshot.data;
            final List<Post> posts = photoModel?.data?.posts ?? [];

            // Empty State
            if (posts.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _buildEmptyView(),
                ),
              );
            }

            // Data Success Grid
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: posts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                return _PhotoTile(index: index, post: posts[index]);
              },
            );
          },
        ),
      ),
    );
  }

  // Professional Shimmer Loading Grid
  Widget _buildShimmerLoading() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF1E1E2C),
          highlightColor: const Color(0xFF2E2E3E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 11.r,
                    backgroundColor: Colors.white10,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 28.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Error State View with Retry Option
  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3F55).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFFF3F55),
                size: 40.r,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Oops! Failed to load photos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: _fetchPhotos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
              label: Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State View
  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_library_outlined,
                color: const Color(0xFF7C3AED),
                size: 44.r,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Photos Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'No photos available right now. Pull down to refresh!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            OutlinedButton.icon(
              onPressed: _fetchPhotos,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF7C3AED)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Color(0xFF7C3AED), size: 18),
              label: Text(
                'Refresh',
                style: TextStyle(
                  color: const Color(0xFF7C3AED),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatefulWidget {
  final int index;
  final Post post;

  const _PhotoTile({required this.index, required this.post});

  @override
  State<_PhotoTile> createState() => _PhotoTileState();
}

class _PhotoTileState extends State<_PhotoTile> with TickerProviderStateMixin {
  late bool _isLiked;
  late bool _isPressed;
  late bool _isFollowing;
  late int _likeCount;

  // Staggered grid entrance
  late final AnimationController _entranceController;
  late final Animation<double> _entranceFade;
  late final Animation<double> _entranceScale;
  late final Animation<Offset> _entranceSlide;

  // Double-tap heart pop
  bool _showHeartPop = false;

  // Like heartbeat bounce
  late final AnimationController _likeController;
  late final Animation<double> _likeScale;

  // Share icon micro-bounce
  late final AnimationController _shareController;
  late final Animation<double> _shareScale;

  // Comment icon micro-bounce
  late final AnimationController _commentController;
  late final Animation<double> _commentScale;

  @override
  void initState() {
    super.initState();
    _isPressed = false;
    _likeCount = widget.post.likesCount ?? 0;
    _isLiked = widget.post.isLiked ?? false;
    _isFollowing = widget.post.user?.isFollow ?? false;

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _entranceScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );
    _entranceSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _likeScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 60),
        ]).animate(
          CurvedAnimation(parent: _likeController, curve: Curves.easeOutCubic),
        );

    _shareController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _shareScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 60),
        ]).animate(
          CurvedAnimation(parent: _shareController, curve: Curves.easeOutCubic),
        );

    _commentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _commentScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 60),
        ]).animate(
          CurvedAnimation(
            parent: _commentController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Stagger animation based on item index
    Future.delayed(Duration(milliseconds: 50 * math.min(widget.index, 10)), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant _PhotoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id) {
      setState(() {
        _likeCount = widget.post.likesCount ?? 0;
        _isLiked = widget.post.isLiked ?? false;
        _isFollowing = widget.post.user?.isFollow ?? false;
      });
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _likeController.dispose();
    _shareController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  String _getPhotoUrl() {
    if (widget.post.mediaUrl != null && widget.post.mediaUrl!.isNotEmpty) {
      return widget.post.mediaUrl!;
    }
    if (widget.post.media != null && widget.post.media!.isNotEmpty) {
      final firstMediaUrl = widget.post.media!.first.mediaUrl;
      if (firstMediaUrl != null && firstMediaUrl.isNotEmpty) {
        return firstMediaUrl;
      }
    }
    return '';
  }

  Map<String, dynamic> _mapPostToData() {
    final photoUrl = _getPhotoUrl();
    final avatar = widget.post.user?.avatar ?? '';
    final username = widget.post.user?.username;
    final name = widget.post.user?.name;
    final handle = username != null && username.isNotEmpty
        ? '@$username'
        : (name != null && name.isNotEmpty ? '@$name' : '@user');

    return {
      'id': widget.post.id,
      'url': photoUrl,
      'avatar': avatar,
      'handle': handle,
      'likes': _likeCount,
      'comments': widget.post.commentsCount ?? 0,
      'isFollowing': _isFollowing,
      'isLiked': _isLiked,
      'caption': widget.post.caption ?? '',
    };
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likeCount++ : _likeCount--;
    });
    _likeController.forward(from: 0);
  }

  void _handleDoubleTap() {
    setState(() {
      _showHeartPop = true;
      if (!_isLiked) {
        _isLiked = true;
        _likeCount++;
      }
    });
    _likeController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) setState(() => _showHeartPop = false);
    });
  }

  void _handleShare() {
    _shareController.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleComment() {
    _commentController.forward(from: 0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsScreen(postData: _mapPostToData()),
      ),
    );
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = _getPhotoUrl();
    final userAvatar = widget.post.user?.avatar ?? '';
    final username = widget.post.user?.username;
    final name = widget.post.user?.name;
    final handle = username != null && username.isNotEmpty
        ? '@$username'
        : (name != null && name.isNotEmpty ? name : '@user');

    return FadeTransition(
      opacity: _entranceFade,
      child: SlideTransition(
        position: _entranceSlide,
        child: ScaleTransition(
          scale: _entranceScale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Card with CachedNetworkImage
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  onDoubleTap: _handleDoubleTap,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostDetailsScreen(postData: _mapPostToData()),
                      ),
                    );
                  },
                  child: AnimatedScale(
                    scale: _isPressed ? 0.97 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Photo Image with CachedNetworkImage & Shimmer Placeholder
                          if (photoUrl.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: const Color(0xFF1E1E2C),
                                highlightColor: const Color(0xFF2E2E3E),
                                child: Container(color: Colors.black26),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: const Color(0xFF1E1E2C),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.white38,
                                      size: 30.r,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Unavailable',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(
                              color: const Color(0xFF1E1E2C),
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.white38,
                                  size: 32.r,
                                ),
                              ),
                            ),

                          // Follow badge, top-right — fades/scales out once tapped
                          Positioned(
                            top: 10.r,
                            right: 10.r,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(
                                scale: anim,
                                child: FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                              ),
                              child: _isFollowing
                                  ? const SizedBox.shrink(
                                      key: ValueKey('hidden'),
                                    )
                                  : GestureDetector(
                                      key: const ValueKey('badge'),
                                      onTap: _toggleFollow,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF3F55),
                                          borderRadius: BorderRadius.circular(
                                            14.r,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFF3F55)
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'follow',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),

                          // Double-tap heart pop overlay (Instagram-style)
                          if (_showHeartPop)
                            Center(
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutBack,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale * 1.2,
                                    child: Opacity(
                                      opacity: math.max(
                                        0.0,
                                        1.0 - (scale - 1.0).abs() * 1.6,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        color: const Color(0xFFFF3F55),
                                        size: 60.r,
                                        shadows: const [
                                          Shadow(
                                            color: Colors.black45,
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Stats row below the photo (avatar, handle, like, comment, share)
              Row(
                children: [
                  // User Avatar with CachedNetworkImage
                  _BounceTap(
                    onTap: () {},
                    child: userAvatar.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: userAvatar,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 11.r,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: const Color(0xFF1E1E2C),
                              highlightColor: const Color(0xFF2E2E3E),
                              child: CircleAvatar(
                                radius: 11.r,
                                backgroundColor: Colors.white10,
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 11.r,
                              backgroundColor: const Color(0xFF2E2E3E),
                              child: Icon(
                                Icons.person,
                                size: 12.sp,
                                color: Colors.white54,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 11.r,
                            backgroundColor: const Color(0xFF2E2E3E),
                            child: Icon(
                              Icons.person,
                              size: 12.sp,
                              color: Colors.white54,
                            ),
                          ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      handle,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Like button
                  _BounceTap(
                    onTap: _toggleLike,
                    child: AnimatedBuilder(
                      animation: _likeScale,
                      builder: (context, child) => Transform.scale(
                        scale: _likeScale.value,
                        child: child,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(_isLiked),
                              color: _isLiked
                                  ? const Color(0xFFFF3F55)
                                  : Colors.white70,
                              size: 15.r,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: Text(
                              '$_likeCount',
                              key: ValueKey(_likeCount),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Comment button
                  _BounceTap(
                    onTap: _handleComment,
                    child: AnimatedBuilder(
                      animation: _commentScale,
                      builder: (context, child) => Transform.scale(
                        scale: _commentScale.value,
                        child: child,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/chat.png',
                            height: 14.h,
                            width: 14.h,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            '${widget.post.commentsCount ?? 0}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Share button
                  _BounceTap(
                    onTap: _handleShare,
                    child: AnimatedBuilder(
                      animation: _shareScale,
                      builder: (context, child) => Transform.scale(
                        scale: _shareScale.value,
                        child: child,
                      ),
                      child: Image.asset(
                        'assets/images/ShareIcon.png',
                        height: 14.h,
                        width: 14.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable tap-scale wrapper for small icon buttons in the stats row.
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
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

