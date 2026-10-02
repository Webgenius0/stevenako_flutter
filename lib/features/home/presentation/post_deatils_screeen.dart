import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';
import 'package:stevenako_flutter/features/home/model/get_commatns_model.dart';
import 'package:stevenako_flutter/features/home/presentation/widgets/home_report_bottom_sheet.dart';
import 'package:stevenako_flutter/features/profile/presentation/profile_screen.dart';
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class PostDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? postData;
  final int? postId;

  const PostDetailsScreen({super.key, this.postData, this.postId});

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
  int _likeCount = 0;
  int _commentCount = 0;
  String _caption = '';
  String? _userAvatar;
  String? _userHandle;
  String? _userName;
  int? _postUserId;
  bool _isMyPost = false;
  String? _timeAgo;

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

    final String? initialUrl = widget.postData?['url'];
    _postImages = [];
    if (initialUrl != null &&
        initialUrl.trim().isNotEmpty &&
        !initialUrl.contains('unsplash.com') &&
        !initialUrl.contains('mixkit.co')) {
      _postImages.add(initialUrl.trim());
    }

    if (widget.postData?['images'] is List) {
      for (final img in widget.postData!['images']) {
        final str = img?.toString().trim() ?? '';
        if (str.isNotEmpty &&
            !str.contains('unsplash.com') &&
            !str.contains('mixkit.co') &&
            !_postImages.contains(str)) {
          _postImages.add(str);
        }
      }
    }

    if (widget.postData?['likes'] != null) {
      _likeCount = widget.postData!['likes'] is int
          ? widget.postData!['likes']
          : int.tryParse(widget.postData!['likes'].toString()) ?? 0;
    }
    if (widget.postData?['comments'] != null) {
      _commentCount = widget.postData!['comments'] is int
          ? widget.postData!['comments']
          : int.tryParse(widget.postData!['comments'].toString()) ?? 0;
    }
    if (widget.postData?['isLiked'] != null) {
      _isLiked = widget.postData!['isLiked'] == true;
    }
    if (widget.postData?['isFollowing'] != null) {
      _isFollowing = widget.postData!['isFollowing'] == true;
    }
    if (widget.postData?['caption'] != null) {
      _caption = widget.postData!['caption'].toString().trim();
    }
    if (widget.postData?['avatar'] != null) {
      final av = widget.postData!['avatar'].toString().trim();
      if (!av.contains('unsplash.com')) {
        _userAvatar = av;
      }
    }
    if (widget.postData?['handle'] != null) {
      _userHandle = widget.postData!['handle'].toString().trim();
    }
    if (widget.postData?['userId'] != null) {
      _postUserId = widget.postData!['userId'] is int
          ? widget.postData!['userId']
          : int.tryParse(widget.postData!['userId'].toString());
    }
    if (widget.postData?['isMyPost'] == true ||
        widget.postData?['isSelf'] == true) {
      _isMyPost = true;
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
          if (post.caption != null) _caption = post.caption!.trim();
          if (post.isMyPost != null) _isMyPost = post.isMyPost!;
          if (post.createdAt != null) {
            _timeAgo = _getTimeAgo(post.createdAt);
          }

          if (post.user != null) {
            final u = post.user!;
            if (u.avatar != null &&
                u.avatar!.trim().isNotEmpty &&
                !u.avatar!.contains('unsplash.com')) {
              _userAvatar = u.avatar!.trim();
            }
            if (u.username != null && u.username!.trim().isNotEmpty) {
              _userHandle = '@${u.username!.trim().replaceAll('@', '')}';
            }
            if (u.name != null && u.name!.trim().isNotEmpty) {
              _userName = u.name!.trim();
            }
            if (u.id != null) {
              _postUserId = u.id;
            }
          }

          // Map Media URLs - filter out dummy seed URLs (mixkit, unsplash) and videos if photo post
          if (post.media != null && post.media!.isNotEmpty) {
            final isPhoto = post.type == 'photo';
            final validUrls = post.media!
                .where((m) {
                  final url = (m.mediaUrl ?? '').trim();
                  if (url.isEmpty) return false;
                  if (url.contains('mixkit.co')) return false;
                  if (url.contains('unsplash.com')) return false;
                  if (isPhoto && m.mediaType == 'video') return false;
                  if (isPhoto &&
                      (url.endsWith('.mp4') ||
                          url.endsWith('.mov') ||
                          url.endsWith('.mkv'))) {
                    return false;
                  }
                  return true;
                })
                .map((m) => m.mediaUrl!.trim())
                .toList();

            if (validUrls.isNotEmpty) {
              _postImages = validUrls;
            } else {
              final anyNonDummy = post.media!
                  .map((m) => (m.mediaUrl ?? '').trim())
                  .where((u) =>
                      u.isNotEmpty &&
                      !u.contains('mixkit.co') &&
                      !u.contains('unsplash.com'))
                  .toList();
              if (anyNonDummy.isNotEmpty) {
                _postImages = anyNonDummy;
              }
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

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final difference = DateTime.now().toUtc().difference(dateTime.toUtc());
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
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
      id:
          comment.id?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      userHandle: handle,
      text: comment.content ?? '',
      avatarUrl: user?.avatar ?? '',
      timeAgo: comment.createdAt != null
          ? _getTimeAgo(comment.createdAt)
          : '',
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
    final String postHandle = _userHandle?.isNotEmpty == true
        ? _userHandle!
        : (widget.postData?['handle'] ?? (_userName?.isNotEmpty == true ? '@$_userName' : ''));
    final String postCaption = _caption;
    final String postUrl = _postImages.isNotEmpty ? _postImages.first : '';
    final String shareText =
        'Check out this post${postHandle.isNotEmpty ? " by $postHandle" : ""} on StevenAko!\n\n${postCaption.isNotEmpty ? "\"$postCaption\"\n\n" : ""}$postUrl';

    try {
      final result = await SharePlus.instance.share(
        ShareParams(text: shareText, subject: 'Post${postHandle.isNotEmpty ? " by $postHandle" : ""}'),
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
    final dynamic savedUserId =
        appData.read('user_id') ?? appData.read(kKeyUserID);
    final dynamic profileUserId =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
    final String? currentIdStr =
        (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
            ? savedUserId.toString().trim()
            : profileUserId?.toString().trim();
    final String? postUserIdStr = (_postUserId ??
            widget.postData?['userId'] ??
            widget.postData?['user']?['id'] ??
            widget.postData?['user_id'])
        ?.toString()
        .trim();
    final bool isOwnPost = _isMyPost ||
        widget.postData?['isSelf'] == true ||
        widget.postData?['isMyPost'] == true ||
        (currentIdStr != null &&
            postUserIdStr != null &&
            currentIdStr == postUserIdStr);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text(
            'Post Options',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(sheetContext);
                Clipboard.setData(ClipboardData(text: shareText));
                ToastUtil.showShortToast('Link copied to clipboard!');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.doc_on_doc, size: 20),
                  SizedBox(width: 8),
                  Text('Copy Post Link'),
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
            if (isOwnPost)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  final dynamic effectiveId =
                      widget.postId ?? widget.postData?['id'];
                  _confirmDeletePost(effectiveId);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.delete,
                        size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Delete Post'),
                  ],
                ),
              ),
            if (!isOwnPost)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  final dynamic effectiveId =
                      widget.postId ?? widget.postData?['id'];
                  HomeReportBottomSheet.show(context, postId: effectiveId);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.exclamationmark_triangle,
                        size: 20, color: CupertinoColors.destructiveRed),
                    SizedBox(width: 8),
                    Text('Report Post'),
                  ],
                ),
              ),
            if (!_isMyPost)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  if (_postUserId != null) {
                    _confirmBlockUser(
                      _postUserId.toString(),
                      _userHandle ?? _userName ?? 'User',
                    );
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
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(sheetContext),
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  void _confirmDeletePost(dynamic effectiveId) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Delete Post?'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'This action cannot be undone. Are you sure you want to delete this post?',
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
                if (effectiveId != null) {
                  final bool success =
                      await deletePostRxObj.deletePost(effectiveId);
                  if (success) {
                    ToastUtil.showShortToast('Post deleted successfully');
                    getAllPostRxObj.getAllPosts();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    ToastUtil.showShortToast(
                      'Failed to delete post. Please try again.',
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
              'They will no longer be able to message you, view your profile, or see your posts. You will not see their content in your feed.',
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
                  getAllPostRxObj.getAllPosts();
                  if (mounted) {
                    Navigator.pop(context);
                  }
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
      if (_editingComment?.id == comment.id ||
          _replyingToComment?.id == comment.id) {
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

    final currentUser =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;
    final currentHandle = currentUser?.username != null &&
            currentUser!.username!.isNotEmpty
        ? '@${currentUser.username!.replaceAll('@', '')}'
        : (currentUser?.name != null && currentUser!.name!.isNotEmpty
            ? '@${currentUser.name}'
            : '@you');
    final currentAvatar = currentUser?.avatar ?? '';

    // Mode 2 & Mode 3: Reply or New top-level comment
    final newComment = CommentItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userHandle: currentHandle,
      text: ' $text',
      avatarUrl: currentAvatar,
      timeAgo: 'Just now',
      userId: currentUser?.id,
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
                title: Text(
                  'Reply to ${comment.userHandle}',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _startReply(comment);
                },
              ),

              // Edit Option (Allow editing any comment or own comment)
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Colors.white),
                title: const Text(
                  'Edit comment',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _startEdit(comment);
                },
              ),

              // Delete Option
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFF3F5E),
                ),
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
    final handle = _userHandle?.isNotEmpty == true
        ? _userHandle!
        : (widget.postData?['handle'] ??
            (_userName?.isNotEmpty == true ? '@$_userName' : ''));
    final avatar = _userAvatar?.isNotEmpty == true
        ? _userAvatar!
        : (widget.postData?['avatar'] ?? '');

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
            final dynamic rawUserId = _postUserId ?? widget.postData?['userId'];
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
            child: avatar.trim().isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: avatar.trim(),
                    width: 38.r,
                    height: 38.r,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 38.r,
                      height: 38.r,
                      color: const Color(0xFF2B2838),
                    ),
                    errorWidget: (context, error, stackTrace) => Container(
                      width: 38.r,
                      height: 38.r,
                      color: const Color(0xFF2B2838),
                      child: const Icon(Icons.person, color: Colors.white70),
                    ),
                  )
                : Container(
                    width: 38.r,
                    height: 38.r,
                    color: const Color(0xFF2B2838),
                    child: const Icon(Icons.person, color: Colors.white70),
                  ),
          ),
        ),
        SizedBox(width: 12.w),

        // User Handle and Time
        GestureDetector(
          onTap: () {
            final dynamic rawUserId = _postUserId ?? widget.postData?['userId'];
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
              if (handle.isNotEmpty)
                Text(
                  handle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (_timeAgo != null && _timeAgo!.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  _timeAgo!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),

        const Spacer(),

        // Follow Button and More Options (only for other users)
        Builder(
          builder: (context) {
            final dynamic savedUserId =
                appData.read('user_id') ?? appData.read(kKeyUserID);
            final dynamic profileUserId =
                getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.id;
            final String? currentIdStr =
                (savedUserId != null && savedUserId.toString().trim().isNotEmpty)
                    ? savedUserId.toString().trim()
                    : profileUserId?.toString().trim();
            final String? postUserIdStr = (_postUserId ??
                    widget.postData?['userId'] ??
                    widget.postData?['user']?['id'] ??
                    widget.postData?['user_id'])
                ?.toString()
                .trim();
            final bool isOwnPost = _isMyPost ||
                widget.postData?['isSelf'] == true ||
                widget.postData?['isMyPost'] == true ||
                (currentIdStr != null &&
                    postUserIdStr != null &&
                    currentIdStr == postUserIdStr);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isOwnPost)
                  GestureDetector(
                    onTap: _toggleFollow,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding:
                          EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
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
                if (isOwnPost) ...[
                  IconButton(
                    onPressed: () {
                      final dynamic effectiveId =
                          widget.postId ?? widget.postData?['id'];
                      _confirmDeletePost(effectiveId);
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFFF4D4D),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 8.w),
                ],
                IconButton(
                  onPressed: () => _showShareBottomSheet(
                    _caption.isNotEmpty ? _caption : 'Stevenako post',
                  ),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // Main Image Widget with Instagram-style PageView (Image 1 to 2 to 3 scroller)
  Widget _buildPostImage() {
    if (_postImages.isEmpty) {
      return Container(
        width: double.infinity,
        height: 250.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1E212D),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Shimmer.fromColors(
            baseColor: const Color(0xFF1E212D),
            highlightColor: const Color(0xFF2E3245),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      );
    }

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
                final imageUrl = _postImages[index];
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF1E212D),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF3F5E),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFF1E212D),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_rounded,
                          size: 48,
                          color: Colors.white38,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Photo unavailable',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Top Right Badge (1/3, 2/3, 3/3 like Instagram)
            if (_postImages.length > 1)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
            if (_postImages.length > 1)
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
            Image.asset('assets/images/chat.png', height: 24.h, width: 24.w),
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
    if (_caption.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Caption
        Text(
          _caption,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.95),
            fontSize: 14.5.sp,
            height: 1.45,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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
      onLongPress: () =>
          _showCommentOptions(comment, parentComment: parentComment),
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
              child: comment.avatarUrl.trim().isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: comment.avatarUrl.trim(),
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: avatarSize,
                        height: avatarSize,
                        color: Colors.grey[800],
                      ),
                      errorWidget: (context, error, stackTrace) => Container(
                        width: avatarSize,
                        height: avatarSize,
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.person,
                          color: Colors.white70,
                          size: isReply ? 16 : 20,
                        ),
                      ),
                    )
                  : Container(
                      width: avatarSize,
                      height: avatarSize,
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.person,
                        color: Colors.white70,
                        size: isReply ? 16 : 20,
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
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
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
                      style: TextStyle(color: Colors.white38, fontSize: 11.sp),
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
                      onTap: () =>
                          _deleteComment(comment, parentComment: parentComment),
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
  Widget _buildCommentInputField(Color backgroundColor, Color commentBgColor) {
    final bool isReplying = _replyingToComment != null;
    final bool isEditing = _editingComment != null;

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 6.h, bottom: 12.h),
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
                      : Image.asset(
                          'assets/images/rocket.png',
                          height: 24.h,
                          width: 24.h,
                        ),
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
