import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stevenako_flutter/features/home/model/get_commatns_model.dart';
import 'package:stevenako_flutter/features/profile/presentation/profile_screen.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class PostDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? postData;
  final int? postId;

  const PostDetailsScreen({
    super.key,
    this.postData,
    this.postId,
  });

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

// Alias to support the exact misspelled filename if imported elsewhere
typedef PostDeatilsScreeen = PostDetailsScreen;

class CommentItem {
  final String id;
  final String userHandle;
  String text;
  final String avatarUrl;
  final String timeAgo;
  bool isLiked;
  int likeCount;
  List<CommentItem> replies;
  final int? userId;

  CommentItem({
    required this.id,
    required this.userHandle,
    required this.text,
    required this.avatarUrl,
    this.timeAgo = '2h',
    this.isLiked = false,
    this.likeCount = 0,
    List<CommentItem>? replies,
    this.userId,
  }) : replies = replies ?? [];
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  final FocusNode _commentFocusNode = FocusNode();

  int _currentImageIndex = 0;
  bool _isFollowing = false;
  bool _isLiked = false;
  int _likeCount = 10;
  int _commentCount = 8;

  // Active state for replying or editing
  CommentItem? _replyingToComment;
  CommentItem? _editingComment;

  // Multi-image list for Instagram-style horizontal image scrolling
  late List<String> _postImages;

  // Comment list
  late List<CommentItem> _comments;

  StreamSubscription? _postDetailsSubscription;

  @override
  void initState() {
    super.initState();

    final initialUrl = widget.postData?['url'] ??
        'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=800&auto=format&fit=crop&q=80';

    _postImages = [
      initialUrl,
      'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1511994298241-608e28f14fde?w=800&auto=format&fit=crop&q=80',
    ];

    if (widget.postData?['likes'] != null) {
      _likeCount = widget.postData!['likes'];
    }
    if (widget.postData?['isFollowing'] != null) {
      _isFollowing = widget.postData!['isFollowing'];
    }

    _comments = [];

    _fetchPostDetails();
  }

  void _fetchPostDetails() {
    final dynamic effectiveId = widget.postId ?? widget.postData?['id'];
    if (effectiveId != null) {
      getCommentsRxObj.getComments(id: effectiveId);
      _postDetailsSubscription = getCommentsRxObj.stream.listen((model) {
        if (!mounted || model.data?.post == null) return;
        final post = model.data!.post!;

        setState(() {
          if (post.likesCount != null) _likeCount = post.likesCount!;
          if (post.commentsCount != null) _commentCount = post.commentsCount!;
          if (post.isLiked != null) _isLiked = post.isLiked!;
          if (post.user?.isFollow != null) _isFollowing = post.user!.isFollow!;

          // Map Media URLs
          if (post.media != null && post.media!.isNotEmpty) {
            final urls = post.media!
                .map((m) => m.mediaUrl ?? '')
                .where((u) => u.isNotEmpty)
                .toList();
            if (urls.isNotEmpty) {
              _postImages = urls;
            }
          }

          // Map Comments
          if (post.comments != null) {
            _comments = post.comments!
                .map((c) => _mapApiCommentToCommentItem(c))
                .toList();
          }
        });
      });
    }
  }

  CommentItem _mapApiCommentToCommentItem(Comment comment) {
    final user = comment.user;
    final handle = user?.username != null && user!.username!.isNotEmpty
        ? '@${user.username}'
        : (user?.name != null && user!.name!.isNotEmpty ? user.name! : '@user');

    final replies = comment.replies != null
        ? comment.replies!.map((r) => _mapApiCommentToCommentItem(r)).toList()
        : <CommentItem>[];

    return CommentItem(
      id: comment.id?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      userHandle: handle,
      text: comment.content ?? '',
      avatarUrl: user?.avatar ?? '',
      timeAgo: comment.createdAt != null
          ? DateFormat('dd MMM').format(comment.createdAt!.toLocal())
          : '2h',
      isLiked: comment.isLiked ?? false,
      likeCount: comment.likesCount ?? 0,
      replies: replies,
      userId: user?.id,
    );
  }

  @override
  void dispose() {
    _postDetailsSubscription?.cancel();
    _commentController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  Future<void> _sharePost() async {
    final String postHandle = widget.postData?['handle'] ?? '@frances';
    final String postCaption =
        'Golden hour ride through the city streets. Nothing beats the feeling of wind rushing past on two wheels. 🏍️✨\n#cycling #streetphotography #goldenhour';
    final String postUrl = widget.postData?['url'] ??
        'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=800&auto=format&fit=crop&q=80';
    final String shareText =
        'Check out this post by $postHandle on StevenAko!\n\n"$postCaption"\n\n$postUrl';

    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'Post by $postHandle',
        ),
      );

      if (result.status == ShareResultStatus.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post shared successfully!'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showShareBottomSheet(shareText);
      }
    }
  }

  void _showShareBottomSheet(String shareText) {
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
                'Share Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),

              // Copy Link / Text
              ListTile(
                leading: const Icon(Icons.copy_rounded, color: Colors.white),
                title: const Text('Copy Post Link',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Clipboard.setData(ClipboardData(text: shareText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link copied to clipboard!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              // Share via native apps
              ListTile(
                leading: const Icon(Icons.share_outlined, color: Colors.white),
                title: const Text('Share via App...',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  SharePlus.instance.share(ShareParams(text: shareText));
                },
              ),

              // Direct Message option
              ListTile(
                leading: const Icon(Icons.send_rounded, color: Color(0xFF9D65FF)),
                title: const Text('Send in Message',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sent to direct messages!'),
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


  void _toggleCommentLike(CommentItem comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
      if (comment.isLiked) {
        comment.likeCount++;
      } else {
        comment.likeCount--;
      }
    });
  }

  void _startReply(CommentItem comment) {
    setState(() {
      _editingComment = null;
      _replyingToComment = comment;
      _commentController.text = '${comment.userHandle} ';
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
    });
    _commentFocusNode.requestFocus();
  }

  void _startEdit(CommentItem comment) {
    setState(() {
      _replyingToComment = null;
      _editingComment = comment;
      _commentController.text = comment.text.trim();
      _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length),
      );
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelActiveAction() {
    setState(() {
      _replyingToComment = null;
      _editingComment = null;
      _commentController.clear();
    });
  }

  void _deleteComment(CommentItem comment, {CommentItem? parentComment}) {
    setState(() {
      if (parentComment != null) {
        parentComment.replies.removeWhere((item) => item.id == comment.id);
      } else {
        _comments.removeWhere((item) => item.id == comment.id);
      }
      if (_commentCount > 0) _commentCount--;
      if (_editingComment?.id == comment.id || _replyingToComment?.id == comment.id) {
        _cancelActiveAction();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comment deleted'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final dynamic effectiveId = widget.postId ?? widget.postData?['id'];
    final int? targetPostId = effectiveId is int
        ? effectiveId
        : int.tryParse(effectiveId?.toString() ?? '');

    // Mode 1: Edit existing comment
    if (_editingComment != null) {
      setState(() {
        _editingComment!.text = ' $text';
        _editingComment = null;
        _commentController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment updated'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      FocusScope.of(context).unfocus();
      return;
    }

    // Mode 2 & Mode 3: Reply or New top-level comment
    final newComment = CommentItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userHandle: '@you',
      text: ' $text',
      avatarUrl: '',
      timeAgo: 'Just now',
    );

    setState(() {
      if (_replyingToComment != null) {
        _replyingToComment!.replies.add(newComment);
        _replyingToComment = null;
      } else {
        _comments.add(newComment);
      }
      _commentCount++;
      _commentController.clear();
    });

    FocusScope.of(context).unfocus();

    // Scroll down to the latest comment
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Call API: POST /user/posts/{postId}/comment
    if (targetPostId != null) {
      final res = await postCommantsRxObj.post(
        userId: targetPostId,
        content: text,
      );

      if (res != null && res.success == true) {
        // Silently refresh server comments
        getCommentsRxObj.getComments(id: targetPostId);
      }
    }
  }

  void _showCommentOptions(CommentItem comment, {CommentItem? parentComment}) {
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

              // Reply Option
              ListTile(
                leading: const Icon(Icons.reply_rounded, color: Colors.white),
                title: Text('Reply to ${comment.userHandle}',
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _startReply(comment);
                },
              ),

              // Edit Option (Allow editing any comment or own comment)
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Colors.white),
                title: const Text('Edit comment',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _startEdit(comment);
                },
              ),

              // Delete Option
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: Color(0xFFFF3F5E)),
                title: const Text(
                  'Delete comment',
                  style: TextStyle(
                    color: Color(0xFFFF3F5E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _deleteComment(comment, parentComment: parentComment);
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
      print('Post Id ${widget.postId}');
    }
    // Theme colors matching exact design screenshot
    const backgroundColor = Color(0xFF13151E);
    const commentBgColor = Color(0xFF1F222E);
    const accentPurple = Color(0xFF9D65FF);
    const followBtnColor = Color(0xFFFF3F5E);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Pinned Top Header Row in SafeArea (Never hides when scrolling)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: _buildHeader(accentPurple, followBtnColor),
            ),

            // Scrollable Content area
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Post Image (Instagram-style Multi-Image Carousel)
                    _buildPostImage(),
                    SizedBox(height: 14.h),

                    // Action Icons Bar (Likes, Comments, Share)
                    _buildActionBar(),
                    SizedBox(height: 16.h),

                    // Post Description Caption & Hashtags
                    _buildCaptionAndHashtags(accentPurple),
                    SizedBox(height: 24.h),

                    // COMMENTS Header
                    Text(
                      'COMMENTS',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Comments List
                    _buildCommentsList(commentBgColor, accentPurple),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // Bottom Add Comment Field
            _buildCommentInputField(backgroundColor, commentBgColor),
          ],
        ),
      ),
    );
  }

  // Header Widget with Back Button, User Avatar, Handle, Time, and Follow Button
  Widget _buildHeader(Color accentPurple, Color followBtnColor) {
    final handle = widget.postData?['handle'] ?? '@frances';
    final avatar = widget.postData?['avatar'] ??
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80';

    return Row(
      children: [
        // Back Button
        IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        SizedBox(width: 10.w),

        // User Avatar
        GestureDetector(
          onTap: () {
            final dynamic rawUserId = widget.postData?['userId'];
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.network(
              avatar,
              width: 38.r,
              height: 38.r,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 38.r,
                height: 38.r,
                color: Colors.grey[800],
                child: const Icon(Icons.person, color: Colors.white70),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // User Handle and Time
        GestureDetector(
          onTap: () {
            final dynamic rawUserId = widget.postData?['userId'];
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
                handle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '2 hours ago',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Follow Button
        GestureDetector(
          onTap: _toggleFollow,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: _isFollowing ? Colors.white24 : followBtnColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              _isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Main Image Widget with Instagram-style PageView (Image 1 to 2 to 3 scroller)
  Widget _buildPostImage() {
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // PageView for image scrolling
            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: _postImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.network(
                  _postImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFF1E212D),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF3F5E),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF1E212D),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_rounded,
                              size: 48, color: Colors.white38),
                          SizedBox(height: 8),
                          Text('Photo',
                              style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // Top Right Badge (1/3, 2/3, 3/3 like Instagram)
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${_postImages.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // Bottom Center Pagination Dots (Instagram style indicator)
            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_postImages.length, (index) {
                  final bool isActive = _currentImageIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: isActive ? 18.w : 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Bar with Likes, Comments, Share
  Widget _buildActionBar() {
    return Row(
      children: [
        // Heart Like Button
        GestureDetector(
          onTap: _toggleLike,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                  key: ValueKey<bool>(_isLiked),
                  color: _isLiked ? const Color(0xFFFF3F5E) : Colors.white,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '$_likeCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 22.w),

        // Comment Button & Count
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           Image.asset('assets/images/chat.png',height: 24.h,width: 24.w,),
            SizedBox(width: 8.w),
            Text(
              '$_commentCount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(width: 22.w),

        // Share Icon
        GestureDetector(
          onTap: _sharePost,
          child: Image.asset(
            'assets/images/ShareIcon.png',
            height: 24.h,
            width: 24.w,
            errorBuilder: (context, error, stackTrace) => Transform.rotate(
              angle: -0.4,
              child: Icon(
                Icons.shortcut_rounded,
                color: Colors.white,
                size: 24.r,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Caption text and hashtags
  Widget _buildCaptionAndHashtags(Color accentPurple) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Caption
        Text(
          'Golden hour ride through the city streets. Nothing beats the feeling of wind rushing past on two wheels. 🏍️✨',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.95),
            fontSize: 14.5.sp,
            height: 1.45,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),

        // Hashtags
        // Wrap(
        //   spacing: 8.w,
        //   runSpacing: 4.h,
        //   children: [
        //     _buildHashtag('#cycling', accentPurple),
        //     _buildHashtag('#streetphotography', accentPurple),
        //     _buildHashtag('#goldenhour', accentPurple),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildHashtag(String text, Color accentPurple) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exploring $text')),
        );
      },
      child: Text(
        text,
        style: TextStyle(
          color: accentPurple,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Comments List Widget with reply, edit, delete, like capabilities
  Widget _buildCommentsList(Color commentBgColor, Color accentPurple) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _comments.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Level Comment Item
            _buildSingleCommentRow(comment, commentBgColor, accentPurple),

            // Nested Replies (if any)
            if (comment.replies.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 44.w, top: 8.h),
                child: Column(
                  children: comment.replies.map((reply) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _buildSingleCommentRow(
                        reply,
                        commentBgColor,
                        accentPurple,
                        isReply: true,
                        parentComment: comment,
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSingleCommentRow(
    CommentItem comment,
    Color commentBgColor,
    Color accentPurple, {
    bool isReply = false,
    CommentItem? parentComment,
  }) {
    final avatarSize = isReply ? 30.r : 36.r;

    return GestureDetector(
      onLongPress: () => _showCommentOptions(comment, parentComment: parentComment),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commenter Avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: comment.userId),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: Image.network(
                comment.avatarUrl,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: avatarSize,
                  height: avatarSize,
                  color: Colors.grey[800],
                  child: Icon(Icons.person,
                      color: Colors.white70, size: isReply ? 16 : 20),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Comment Content Bubble + Meta Actions (Reply, Edit, Delete, Time)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Bubble Container
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: commentBgColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: comment.userHandle,
                                style: TextStyle(
                                  color: accentPurple,
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: comment.text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // Comment Like Heart Icon
                    GestureDetector(
                      onTap: () => _toggleCommentLike(comment),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            comment.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            size: 16.r,
                            color: comment.isLiked
                                ? const Color(0xFFFF3F5E)
                                : Colors.white38,
                          ),
                          if (comment.likeCount > 0)
                            Text(
                              '${comment.likeCount}',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Meta Info Row (Time, Reply, Edit, Delete buttons)
                Row(
                  children: [
                    SizedBox(width: 8.w),
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),

                    // Reply Action Button
                    GestureDetector(
                      onTap: () => _startReply(comment),
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),

                    // Edit Button
                    GestureDetector(
                      onTap: () => _startEdit(comment),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),

                    // Delete Button
                    GestureDetector(
                      onTap: () => _deleteComment(comment, parentComment: parentComment),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: const Color(0xFFFF3F5E).withValues(alpha: 0.8),
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Input Field Widget at the Bottom with Active Replying & Editing Banner
  Widget _buildCommentInputField(
      Color backgroundColor, Color commentBgColor) {
    final bool isReplying = _replyingToComment != null;
    final bool isEditing = _editingComment != null;

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 6.h,
        bottom: 12.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active Action Banner (Replying to @user or Editing comment)
          if (isReplying || isEditing)
            Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: commentBgColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.reply_rounded,
                    color: const Color(0xFF9D65FF),
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Editing your comment...'
                          : 'Replying to ${_replyingToComment!.userHandle}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelActiveAction,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                      size: 18.r,
                    ),
                  ),
                ],
              ),
            ),

          // Main Input Box
          Container(
            decoration: BoxDecoration(
              color: commentBgColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: (isReplying || isEditing)
                    ? const Color(0xFF9D65FF)
                    : Colors.white.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 18.w),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    cursorColor: const Color(0xFFFF3F5E),
                    decoration: InputDecoration(
                      hintText: isEditing
                          ? 'Update comment...'
                          : isReplying
                              ? 'Reply to ${_replyingToComment!.userHandle}...'
                              : 'Add comment...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onSubmitted: (_) => _submitComment(),
                  ),
                ),
                IconButton(
                  onPressed: _submitComment,
                  icon: isEditing
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF9D65FF),
                          size: 24.r,
                        )
                      : Image.asset('assets/images/rocket.png',height: 24.h,width: 24.h,),
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
