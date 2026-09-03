import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/features/home/data/rx_comment_actions_api/api.dart';
import 'package:stevenako_flutter/features/home/model/get_commatns_model.dart';
import 'package:stevenako_flutter/features/home/model/post_my_commants_model.dart'
    as post_comm;
import 'package:stevenako_flutter/features/profile/presentation/profile_screen.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class ReelCommentsBottomSheet extends StatefulWidget {
  final dynamic postId;
  final int initialCommentsCount;
  final ValueChanged<int>? onCommentCountChanged;

  const ReelCommentsBottomSheet({
    super.key,
    required this.postId,
    required this.initialCommentsCount,
    this.onCommentCountChanged,
  });

  @override
  State<ReelCommentsBottomSheet> createState() =>
      _ReelCommentsBottomSheetState();
}

class _ReelCommentsBottomSheetState extends State<ReelCommentsBottomSheet> {
  final TextEditingController _commentInputController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<Comment> _comments = [];
  late int _commentsCount;

  String? _replyingToUser;
  bool _hasInputText = false;
  final Set<int> _pendingCommentIds = {};

  static const List<String> _quickEmojis = [
    '❤️',
    '🙌',
    '🔥',
    '👏',
    '😂',
    '😍',
    '😮',
    '💯',
    '✨',
    '👍',
  ];

  @override
  void initState() {
    super.initState();
    _commentsCount = widget.initialCommentsCount;
    _commentInputController.addListener(_onInputChanged);
    _fetchComments();
  }

  void _onInputChanged() {
    final bool hasText = _commentInputController.text.trim().isNotEmpty;
    if (hasText != _hasInputText) {
      setState(() {
        _hasInputText = hasText;
      });
    }
  }

  @override
  void dispose() {
    _commentInputController.removeListener(_onInputChanged);
    _commentInputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    setState(() {
      if (_comments.isEmpty) {
        _isLoading = true;
      }
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final GetUserCommentsModel? res =
          await getCommentsRxObj.getComments(id: widget.postId);

      if (!mounted) return;

      if (res != null && res.data?.post != null) {
        final List<Comment> fetchedComments = res.data?.post?.comments ?? [];
        final int fetchedCount =
            res.data?.post?.commentsCount ?? fetchedComments.length;

        // Preserve any comments created by the user in this active session
        final List<Comment> mergedComments = List.from(fetchedComments);
        for (final local in _comments) {
          if (!mergedComments.any((c) => c.id == local.id || (c.content == local.content && c.user?.id == local.user?.id))) {
            mergedComments.add(local);
          }
        }

        final int finalCount = mergedComments.length > fetchedCount ? mergedComments.length : fetchedCount;

        setState(() {
          _comments = mergedComments;
          _commentsCount = finalCount;
          _isLoading = false;
        });

        if (widget.onCommentCountChanged != null) {
          widget.onCommentCountChanged!(_commentsCount);
        }
      } else {
        setState(() {
          _isLoading = false;
          if (_comments.isEmpty) {
            _commentsCount = 0;
          }
        });

        if (_comments.isEmpty && widget.onCommentCountChanged != null) {
          widget.onCommentCountChanged!(0);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load comments. Please try again.';
      });
    }
  }

  void _rollbackOptimisticComment(int commentId) {
    setState(() {
      _comments.removeWhere((c) => c.id == commentId);
      if (_commentsCount > 0) {
        _commentsCount--;
      }
    });
    if (widget.onCommentCountChanged != null) {
      widget.onCommentCountChanged!(_commentsCount);
    }
  }

  void _postComment() async {
    final String text = _commentInputController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.mediumImpact();

    final currentUser =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;

    final int? postIdInt = widget.postId is int
        ? widget.postId
        : int.tryParse(widget.postId?.toString() ?? '');

    final optimisticComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      content: text,
      likesCount: 0,
      isLiked: false,
      user: User(
        id: currentUser?.id,
        name: currentUser?.name ?? 'You',
        username: currentUser?.username ?? 'you',
        avatar: currentUser?.avatar ?? '',
      ),
      createdAt: DateTime.now(),
    );

    setState(() {
      _comments.add(optimisticComment);
      _commentsCount++;
      _pendingCommentIds.add(optimisticComment.id!);
      _commentInputController.clear();
      _replyingToUser = null;
      _hasInputText = false;
    });

    if (widget.onCommentCountChanged != null) {
      widget.onCommentCountChanged!(_commentsCount);
    }

    // Scroll to bottom smoothly to view newly added comment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    if (postIdInt != null) {
      try {
        final post_comm.PostSentMyCommantsModel? res =
            await postCommantsRxObj.post(
          userId: postIdInt,
          content: text,
        );

        if (!mounted) return;

        if (res != null && res.data != null) {
          final apiComment = res.data?.comment;
          final int? apiCount = res.data?.commentsCount;

          final index =
              _comments.indexWhere((c) => c.id == optimisticComment.id);

          if (index != -1 && apiComment != null) {
            // Silent update — only swap ID and remove pending, no visible content change
            setState(() {
              _pendingCommentIds.remove(optimisticComment.id);
              _comments[index] = Comment(
                id: apiComment.id ?? optimisticComment.id,
                content: apiComment.content ?? text,
                likesCount: apiComment.likesCount ?? 0,
                isLiked: apiComment.isLiked ?? false,
                user: User(
                  id: apiComment.user?.id ?? currentUser?.id,
                  name: apiComment.user?.name ?? currentUser?.name ?? 'You',
                  username: apiComment.user?.username ??
                      currentUser?.username ??
                      'you',
                  avatar: apiComment.user?.avatar ?? currentUser?.avatar ?? '',
                ),
                createdAt: apiComment.createdAt ?? DateTime.now(),
              );
              if (apiCount != null) {
                _commentsCount = apiCount;
              }
            });

            if (widget.onCommentCountChanged != null) {
              widget.onCommentCountChanged!(_commentsCount);
            }
          }
        } else {
          _pendingCommentIds.remove(optimisticComment.id);
          _rollbackOptimisticComment(optimisticComment.id!);
          ToastUtil.showShortToast('Failed to post comment. Please try again.');
        }
      } catch (e) {
        if (!mounted) return;
        _pendingCommentIds.remove(optimisticComment.id);
        _rollbackOptimisticComment(optimisticComment.id!);
        ToastUtil.showShortToast('Failed to post comment. Please try again.');
      }
    }
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return 'Just now';
    final duration = DateTime.now().difference(date);
    if (duration.inDays >= 365) {
      return '${(duration.inDays / 365).floor()}y ago';
    } else if (duration.inDays >= 30) {
      return '${(duration.inDays / 30).floor()}m ago';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAvatar =
        getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user?.avatar;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        decoration: BoxDecoration(
          color: const Color(0xFF161722),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.r),
          ),
          border: Border.all(color: Colors.white12, width: 1),
        ),
        child: Column(
          children: [
            // Sheet Top Header Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
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
                        '$_commentsCount Comments',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
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

            // Comments Body Area (Shimmer Loading / Error View / Comments List)
            Expanded(
              child: _buildBody(),
            ),

            // Comment Input Bottom Field
            _buildInputBar(currentUserAvatar),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildShimmerLoading();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_comments.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _fetchComments,
      color: const Color(0xFF9D65FF),
      backgroundColor: const Color(0xFF222533),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(16.r),
        itemCount: _comments.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final comment = _comments[index];
          return _buildCommentTile(comment);
        },
      ),
    );
  }

  Widget _buildCommentTile(Comment comment) {
    final user = comment.user;
    final String avatarUrl = user?.avatar ?? '';
    final String username = user?.username ?? user?.name ?? 'User';
    final int? userId = user?.id;
    final bool isPending = _pendingCommentIds.contains(comment.id);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Avatar with glowing ring & View Mode on tap
        GestureDetector(
          onTap: () {
            if (avatarUrl.isNotEmpty) {
              _showImagePreviewDialog(context, avatarUrl, username, userId);
            } else if (userId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: userId),
                ),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(1.5.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF9D65FF), Color(0xFF6D28D9)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9D65FF).withValues(alpha: 0.25),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: avatarUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl,
                      width: 34.r,
                      height: 34.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: const Color(0xFF222533),
                        highlightColor: const Color(0xFF32364A),
                        child: Container(
                          width: 34.r,
                          height: 34.r,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 34.r,
                        height: 34.r,
                        color: const Color(0xFF222533),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    )
                  : Container(
                      width: 34.r,
                      height: 34.r,
                      color: const Color(0xFF222533),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(width: 10.w),

        // Comment Content Container
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF222533),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(userId: userId),
                          ),
                        );
                      },
                      child: Text(
                        '@$username',
                        style: TextStyle(
                          color: const Color(0xFF9D65FF),
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      comment.content ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),

              // Comment Footer Info (Time Ago, Delivery Status & Reply Action)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Row(
                  children: [
                    // WhatsApp-style delivery status icon
                    if (isPending)
                      Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(
                          Icons.access_time_rounded,
                          size: 12.r,
                          color: Colors.white30,
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Icon(
                          Icons.done_rounded,
                          size: 12.r,
                          color: const Color(0xFF9D65FF),
                        ),
                      ),
                    Text(
                      isPending ? 'Sending...' : _formatTimeAgo(comment.createdAt),
                      style: TextStyle(
                        color: isPending ? Colors.white24 : Colors.white38,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    if (!isPending)
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _replyingToUser = username;
                          });
                          _commentInputController.text = '@$username ';
                          _commentInputController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: _commentInputController.text.length),
                          );
                          _inputFocusNode.requestFocus();
                        },
                        child: Text(
                          'Reply',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),

        // Comment Action Icons (Heart Like Button & 3-Dots Menu)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(
              builder: (context, setTileState) {
                final bool isLiked = comment.isLiked ?? false;
                final int likes = comment.likesCount ?? 0;

                return GestureDetector(
                  onTap: () async {
                    final bool newLiked = !isLiked;
                    final int newLikes = newLiked
                        ? likes + 1
                        : (likes > 0 ? likes - 1 : 0);

                    setTileState(() {
                      comment = comment.copyWith(
                        isLiked: newLiked,
                        likesCount: newLikes,
                      );
                    });

                    if (comment.id != null) {
                      try {
                        final res =
                            await userCommentLikeRxObj.toggleLike(commentId: comment.id);
                        if (res != null && res.data != null) {
                          setTileState(() {
                            comment = comment.copyWith(
                              isLiked: res.data!.isLiked ?? newLiked,
                              likesCount: res.data!.likesCount ?? newLikes,
                            );
                          });
                        }
                      } catch (e) {
                        setTileState(() {
                          comment = comment.copyWith(
                            isLiked: isLiked,
                            likesCount: likes,
                          );
                        });
                      }
                    }
                  },
                  child: Column(
                    children: [
                      Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        size: 16.r,
                        color: isLiked
                            ? const Color(0xFFFF3F5E)
                            : Colors.white38,
                      ),
                      if (likes > 0)
                        Text(
                          '$likes',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10.sp,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(width: 2.w),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                size: 18.r,
                color: Colors.white38,
              ),
              color: const Color(0xFF1E1F2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: const BorderSide(color: Colors.white12),
              ),
              offset: const Offset(0, 24),
              onSelected: (value) {
                final TextEditingController editController =
                    TextEditingController(text: comment.content);
                if (value == 'edit') {
                  _showEditCommentDialog(comment, editController);
                } else if (value == 'delete') {
                  _confirmDeleteComment(comment);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        color: Color(0xFF8B5CF6),
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFFF3F5E),
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: const Color(0xFFFF3F5E),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: 6,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF222533),
          highlightColor: const Color(0xFF32364A),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: 80.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: const Color(0xFFFF3F5E),
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: _fetchComments,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: Colors.white24,
            size: 54.r,
          ),
          SizedBox(height: 12.h),
          Text(
            'No comments yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Be the first to share a thought!',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickEmojiBar() {
    return Container(
      height: 38.h,
      color: const Color(0xFF191A26),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _quickEmojis.length,
        separatorBuilder: (context, index) => SizedBox(width: 14.w),
        itemBuilder: (context, index) {
          final emoji = _quickEmojis[index];
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              final currentText = _commentInputController.text;
              final selection = _commentInputController.selection;
              final start = selection.start < 0 ? currentText.length : selection.start;
              final end = selection.end < 0 ? currentText.length : selection.end;
              final newText = currentText.replaceRange(start, end, emoji);
              _commentInputController.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(
                  offset: start + emoji.length,
                ),
              );
            },
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReplyBanner() {
    if (_replyingToUser == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      color: const Color(0xFF1E202E),
      child: Row(
        children: [
          Icon(Icons.reply_rounded, color: const Color(0xFF9D65FF), size: 16.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              'Replying to @$_replyingToUser',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _replyingToUser = null;
              });
            },
            child: Icon(Icons.close_rounded, color: Colors.white38, size: 18.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(String? currentUserAvatar) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildReplyBanner(),
        _buildQuickEmojiBar(),
        Container(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 12.w,
            top: 8.h,
            bottom: 10.h + MediaQuery.of(context).padding.bottom,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF161722),
            border: Border(
              top: BorderSide(color: Colors.white12, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Current User Avatar with ring border
              Container(
                padding: EdgeInsets.all(1.2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D65FF), Color(0xFF6D28D9)],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: currentUserAvatar != null && currentUserAvatar.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: currentUserAvatar,
                          width: 32.r,
                          height: 32.r,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: const Color(0xFF222533),
                            highlightColor: const Color(0xFF32364A),
                            child: Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 32.r,
                          height: 32.r,
                          color: const Color(0xFF222533),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 10.w),

              // Comment Text Input Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF222533),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _inputFocusNode.hasFocus
                          ? const Color(0xFF9D65FF).withValues(alpha: 0.5)
                          : Colors.white12,
                    ),
                  ),
                  child: TextField(
                    controller: _commentInputController,
                    focusNode: _inputFocusNode,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _postComment(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5.sp,
                    ),
                    cursorColor: const Color(0xFFFF3F5E),
                    decoration: InputDecoration(
                      hintText: _replyingToUser != null
                          ? 'Reply to @$_replyingToUser...'
                          : 'Add a comment...',
                      hintStyle: TextStyle(
                        color: Colors.white38,
                        fontSize: 13.5.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 9.h,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Send Button with ValueListenableBuilder for posting loader state
              ValueListenableBuilder<bool>(
                valueListenable: postCommantsRxObj.isLoading,
                builder: (context, isPosting, child) {
                  final bool canSend = _hasInputText && !isPosting;

                  return GestureDetector(
                    onTap: canSend ? _postComment : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        gradient: canSend
                            ? const LinearGradient(
                                colors: [Color(0xFF9D65FF), Color(0xFF7C3AED)],
                              )
                            : null,
                        color: canSend ? null : const Color(0xFF222533),
                        shape: BoxShape.circle,
                        boxShadow: canSend
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF9D65FF).withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                              Icons.send_rounded,
                              color: canSend ? Colors.white : Colors.white24,
                              size: 16.r,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }



  void _showEditCommentDialog(Comment comment, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isSaving = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1F2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: const BorderSide(color: Colors.white12),
              ),
              title: Text(
                'Edit Comment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: TextField(
                controller: controller,
                maxLines: 3,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                cursorColor: const Color(0xFFFF3F5E),
                decoration: InputDecoration(
                  hintText: 'Edit your comment...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 14.sp),
                  filled: true,
                  fillColor: const Color(0xFF2B2D42),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(12.r),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final String newContent = controller.text.trim();
                          if (newContent.isEmpty) return;

                          setDialogState(() {
                            isSaving = true;
                          });

                          final index = _comments.indexWhere((c) => c.id == comment.id);
                          if (index != -1) {
                            setState(() {
                              _comments[index] = _comments[index].copyWith(content: newContent);
                            });
                          }

                          Navigator.pop(dialogContext);

                          try {
                            final bool success = await CommentActionsApi.instance.editComment(
                              commentId: comment.id,
                              content: newContent,
                            );

                            if (!success) {
                              final index = _comments.indexWhere((c) => c.id == comment.id);
                              if (index != -1) {
                                setState(() {
                                  _comments[index] = _comments[index].copyWith(content: comment.content);
                                });
                              }
                              ToastUtil.showShortToast(
                                  'Failed to update comment. Please try again.');
                            }
                          } catch (e) {
                            final index = _comments.indexWhere((c) => c.id == comment.id);
                            if (index != -1) {
                              setState(() {
                                _comments[index] = _comments[index].copyWith(content: comment.content);
                              });
                            }
                            ToastUtil.showShortToast(
                                'Failed to update comment. Please try again.');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: isSaving
                      ? SizedBox(
                          width: 50,
                          height: 16,
                          child: Shimmer.fromColors(
                            baseColor: Colors.white54,
                            highlightColor: Colors.white,
                            child: const Text('Saving...', style: TextStyle(fontSize: 12, color: Colors.white)),
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteComment(Comment comment) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Delete Comment'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Are you sure you want to delete this comment?'),
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

                final int originalIndex = _comments.indexWhere((c) => c.id == comment.id);

                setState(() {
                  _comments.removeWhere((c) => c.id == comment.id);
                  if (_commentsCount > 0) {
                    _commentsCount--;
                  }
                });

                if (widget.onCommentCountChanged != null) {
                  widget.onCommentCountChanged!(_commentsCount);
                }

                try {
                  final bool success = await CommentActionsApi.instance.deleteComment(
                    commentId: comment.id,
                  );

                  if (!success) {
                    setState(() {
                      if (originalIndex != -1 && originalIndex <= _comments.length) {
                        _comments.insert(originalIndex, comment);
                      } else {
                        _comments.add(comment);
                      }
                      _commentsCount++;
                    });
                    if (widget.onCommentCountChanged != null) {
                      widget.onCommentCountChanged!(_commentsCount);
                    }
                    ToastUtil.showShortToast(
                        'Failed to delete comment. Please try again.');
                  }
                } catch (e) {
                  setState(() {
                    if (originalIndex != -1 && originalIndex <= _comments.length) {
                      _comments.insert(originalIndex, comment);
                    } else {
                      _comments.add(comment);
                    }
                    _commentsCount++;
                  });
                  if (widget.onCommentCountChanged != null) {
                    widget.onCommentCountChanged!(_commentsCount);
                  }
                  ToastUtil.showShortToast(
                      'Failed to delete comment. Please try again.');
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showImagePreviewDialog(
      BuildContext context, String imageUrl, String username, int? userId) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header bar with user tag & close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      if (userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(userId: userId),
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          '@$username',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: const Color(0xFF9D65FF),
                          size: 14.sp,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24.r,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Image Viewer Box with Pinch-to-Zoom
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                    maxWidth: MediaQuery.of(context).size.width * 0.85,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161722),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    minScale: 0.8,
                    maxScale: 3.5,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xFF222533),
                          highlightColor: const Color(0xFF32364A),
                          child: Container(
                            width: 120.r,
                            height: 120.r,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 64,
                      ),
                    ),
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
