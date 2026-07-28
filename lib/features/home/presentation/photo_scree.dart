import 'dart:math' as math;

import 'package:flutter/material.dart';

// ==========================================
// 2. PHOTOS SUB-SCREEN (Photos Tab)
// ==========================================
class PhotosSubScreen extends StatefulWidget {
  const PhotosSubScreen({super.key});

  @override
  State<PhotosSubScreen> createState() => _PhotosSubScreenState();
}

class _PhotosSubScreenState extends State<PhotosSubScreen> {
  final List<Map<String, dynamic>> _photos = [
    {
      'url':
          'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=400&auto=format&fit=crop&q=80',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'handle': '@frances',
      'likes': 10,
      'comments': 8,
      'isFollowing': false,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&auto=format&fit=crop&q=80',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'handle': '@frances',
      'likes': 10,
      'comments': 8,
      'isFollowing': true,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=400&auto=format&fit=crop&q=80',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'handle': '@frances',
      'likes': 10,
      'comments': 8,
      'isFollowing': true,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1472214222541-d510753a4707?w=400&auto=format&fit=crop&q=80',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'handle': '@frances',
      'likes': 10,
      'comments': 8,
      'isFollowing': true,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?w=400&auto=format&fit=crop&q=80',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'handle': '@frances',
      'likes': 10,
      'comments': 8,
      'isFollowing': true,
    },
    {
      'url':
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&auto=format&fit=crop&q=80',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'handle': '@frances',
      'likes': 10,
      'comments': 8,
      'isFollowing': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          Colors.transparent, // Transparent to show the NavigationMenu gradient
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 12,
        right: 12,
      ),
      child: GridView.builder(
        itemCount: _photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          return _PhotoTile(index: index, data: _photos[index]);
        },
      ),
    );
  }
}

class _PhotoTile extends StatefulWidget {
  final int index;
  final Map<String, dynamic> data;

  const _PhotoTile({required this.index, required this.data});

  @override
  State<_PhotoTile> createState() => _PhotoTileState();
}

class _PhotoTileState extends State<_PhotoTile> with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _isPressed = false;
  bool _isFollowing = false;
  late int _likeCount;

  // Staggered grid entrance
  late final AnimationController _entranceController;
  late final Animation<double> _entranceFade;
  late final Animation<double> _entranceScale;
  late final Animation<Offset> _entranceSlide;

  // Double-tap heart pop (on the photo itself)
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
    _likeCount = widget.data['likes'];
    _isFollowing = widget.data['isFollowing'] ?? false;

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
          CurvedAnimation(parent: _likeController, curve: Curves.easeOutBack),
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
          CurvedAnimation(parent: _shareController, curve: Curves.easeOutBack),
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
            curve: Curves.easeOutBack,
          ),
        );

    // Stagger: each tile starts a beat after the last, based on grid position
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _likeController.dispose();
    _shareController.dispose();
    _commentController.dispose();
    super.dispose();
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
        content: Text('Shared!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleComment() {
    _commentController.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comments coming soon!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
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
    return FadeTransition(
      opacity: _entranceFade,
      child: SlideTransition(
        position: _entranceSlide,
        child: ScaleTransition(
          scale: _entranceScale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  onDoubleTap: _handleDoubleTap,
                  onTap: () {},
                  child: AnimatedScale(
                    scale: _isPressed ? 0.97 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image with fade-in once loaded
                          Image.network(
                            widget.data['url'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                return AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 350),
                                  child: child,
                                );
                              }
                              return Container(
                                color: Colors.white10,
                                child: Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white38,
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.white10,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.white24,
                                      size: 28,
                                    ),
                                  ),
                                ),
                          ),

                          // Follow badge, top-right — fades/scales out once tapped
                          Positioned(
                            top: 10,
                            right: 10,
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF3F55),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFFF3F55,
                                              ).withOpacity(0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Text(
                                          'follow',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
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
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Color(0xFFFF3F55),
                                        size: 60,
                                        shadows: [
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

              const SizedBox(height: 8),

              // Stats row below the photo (avatar, handle, like, comment, share)
              Row(
                children: [
                  // Avatar
                  _BounceTap(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 11,
                      backgroundImage: NetworkImage(widget.data['avatar']),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.data['handle'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Like
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
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: Text(
                              '$_likeCount',
                              key: ValueKey(_likeCount),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Comment
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
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.data['comments']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Share
                  _BounceTap(
                    onTap: _handleShare,
                    child: AnimatedBuilder(
                      animation: _shareScale,
                      builder: (context, child) => Transform.scale(
                        scale: _shareScale.value,
                        child: child,
                      ),
                      child: const Icon(
                        Icons.ios_share_rounded,
                        color: Colors.white70,
                        size: 14,
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
