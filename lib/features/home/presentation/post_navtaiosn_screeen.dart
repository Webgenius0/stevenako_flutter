import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stevenako_flutter/features/home/model/get_all_post_model.dart';
import 'package:stevenako_flutter/helpers/ui_helpers.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class PostsSubScreenTwo extends StatefulWidget {
  const PostsSubScreenTwo({super.key});

  @override
  State<PostsSubScreenTwo> createState() => _PostsSubScreenTwoState();
}

class _PostsSubScreenTwoState extends State<PostsSubScreenTwo> {
  final Set<int> _likedPostIds = {};
  final Map<int, int> _extraLikes = {};

  @override
  void initState() {
    super.initState();
    getAllPostRxObj.getAllPosts();
  }

  Future<void> _refreshPosts() async {
    await getAllPostRxObj.getAllPosts();
  }

  void _showPostOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              _buildOptionTile(
                icon: Icons.bookmark_border,
                label: 'Save post',
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Post saved!')));
                },
              ),
              _buildOptionTile(
                icon: Icons.edit_outlined,
                label: 'Edit post',
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit coming soon!')),
                  );
                },
              ),
              const Divider(color: Colors.white12, height: 8),
              _buildOptionTile(
                icon: Icons.delete_outline,
                label: 'Delete post',
                iconColor: const Color(0xFFFF3F55),
                textColor: const Color(0xFFFF3F55),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDelete(index);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete post?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Post action executed.')));
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFFF3F55)),
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------- Comments bottom sheet ----------
  void _showCommentsSheet(Map<String, dynamic> postData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _CommentsSheet(
          post: postData,
          onCommentsChanged: (updatedComments) {
            setState(() {
              postData['comments'] = updatedComments;
            });
          },
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white70,
    Color textColor = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label, style: TextStyle(color: textColor, fontSize: 14.5)),
      onTap: onTap,
    );
  }

  Widget _buildAvatarImage(String? url) {
    if (url == null || url.isEmpty) {
      return const CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFF2A2A3A),
        child: Icon(Icons.person, color: Colors.white54, size: 20),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.white.withValues(alpha: 0.1),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF2A2A3A),
          child: const Icon(Icons.person, color: Colors.white54, size: 20),
        ),
      ),
    );
  }

  String _resolveFullMediaUrl(String? mediaPath) {
    if (mediaPath == null || mediaPath.trim().isEmpty) return '';
    final trimmed = mediaPath.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) {
      return 'https://stevenako.thesyndicates.team$trimmed';
    }
    return 'https://stevenako.thesyndicates.team/$trimmed';
  }

  bool _isVideoUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final cleanUrl = url.trim().toLowerCase();
    return cleanUrl.endsWith('.mp4') ||
        cleanUrl.endsWith('.mov') ||
        cleanUrl.endsWith('.avi') ||
        cleanUrl.endsWith('.webm') ||
        cleanUrl.endsWith('.m3u8') ||
        cleanUrl.endsWith('.mkv') ||
        cleanUrl.contains('/posts-videos');
  }

  bool _isDisplayableImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final fullUrl = _resolveFullMediaUrl(url);
    if (_isVideoUrl(fullUrl)) return false;

    final cleanUrl = fullUrl.toLowerCase();
    return cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://');
  }

  Widget _buildPostMediaImage(String? rawUrl) {
    final fullUrl = _resolveFullMediaUrl(rawUrl);
    if (!_isDisplayableImageUrl(fullUrl)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 360.h,
            minHeight: 120.h,
          ),
          child: CachedNetworkImage(
            imageUrl: fullUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 140.h,
              color: Colors.white.withValues(alpha: 0.05),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0E17),
      child: SafeArea(
        child: StreamBuilder<GetAllPostModel>(
          stream: getAllPostRxObj.dataFetcher.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const PostsShimmerLoader();
            }

            final livePosts = snapshot.data?.data?.posts ?? [];

            if (livePosts.isEmpty) {
              return RefreshIndicator(
                color: const Color(0xFF8B5CF6),
                backgroundColor: Colors.black,
                onRefresh: _refreshPosts,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 120.h),
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E2C),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Icon(
                              Icons.dynamic_feed_rounded,
                              color: const Color(0xFF8B5CF6),
                              size: 42.r,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No Posts Yet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Be the first to share something with the community!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF8B5CF6),
              backgroundColor: Colors.black,
              onRefresh: _refreshPosts,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: livePosts.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final Post postModel = livePosts[index];
                  final int postId = postModel.id ?? index;
                  final bool isLiked = _likedPostIds.contains(postId) || (postModel.isLiked == true);
                  final int likesCount = (postModel.likesCount ?? 0) + (_extraLikes[postId] ?? 0);
                  final int commentsCount = postModel.commentsCount ?? 0;

                  String? mediaUrl = postModel.mediaUrl;
                  if ((mediaUrl == null || mediaUrl.isEmpty) &&
                      postModel.media != null &&
                      postModel.media!.isNotEmpty) {
                    mediaUrl = postModel.media!.first.mediaUrl;
                  }

                  final String avatarUrl = postModel.user?.avatar ?? '';
                  final String userName = postModel.user?.name ?? postModel.user?.username ?? 'Stevenako User';
                  final String timeText = postModel.createdAt != null
                      ? '${postModel.createdAt!.hour}:${postModel.createdAt!.minute} '
                      : 'Just now';
                  final String captionText = postModel.caption ?? postModel.title ?? '';

                  final Map<String, dynamic> postDataForSheet = {
                    'userName': userName,
                    'avatar': avatarUrl,
                    'text': captionText,
                    'comments': <Map<String, String>>[],
                  };

                  return _buildSinglePostCard(
                    index: index,
                    postId: postId,
                    avatarUrl: avatarUrl,
                    userName: userName,
                    timeText: timeText,
                    captionText: captionText,
                    mediaUrl: mediaUrl,
                    isLiked: isLiked,
                    likesCount: likesCount,
                    commentsCount: commentsCount,
                    postDataForSheet: postDataForSheet,
                    onLikeTap: () {
                      setState(() {
                        if (_likedPostIds.contains(postId)) {
                          _likedPostIds.remove(postId);
                          _extraLikes[postId] = (_extraLikes[postId] ?? 0) - 1;
                        } else {
                          _likedPostIds.add(postId);
                          _extraLikes[postId] = (_extraLikes[postId] ?? 0) + 1;
                        }
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSinglePostCard({
    required int index,
    required int postId,
    required String avatarUrl,
    required String userName,
    required String timeText,
    required String captionText,
    required String? mediaUrl,
    required bool isLiked,
    required int likesCount,
    required int commentsCount,
    required Map<String, dynamic> postDataForSheet,
    required VoidCallback onLikeTap,
  }) {
    final String resolvedMediaUrl = _resolveFullMediaUrl(mediaUrl);
    final bool hasImage = _isDisplayableImageUrl(resolvedMediaUrl);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: hasImage ? 14.h : 10.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(hasImage ? 16.r : 12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Ensures tight fitting around text for text-only posts
        children: [
          // Header
          Row(
            children: [
              _buildAvatarImage(_resolveFullMediaUrl(avatarUrl)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                    Text(
                      timeText,
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPostOptions(context, index),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.more_horiz, color: Colors.white54),
                ),
              ),
            ],
          ),

          // Caption Text
          if (captionText.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              captionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],

          // Media Content (ONLY rendered if valid image exists, NO dummy boxes)
          if (hasImage) ...[
            _buildPostMediaImage(resolvedMediaUrl),
          ],

          SizedBox(height: hasImage ? 12.h : 8.h),

          // Action Bar
          Row(
            children: [
              GestureDetector(
                onTap: onLikeTap,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? const Color(0xFFFF3F55) : Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$likesCount',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _showCommentsSheet(postDataForSheet),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/mesagenva.png',
                      height: 17.w,
                      width: 17.w,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$commentsCount',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.horizontalSpace(16.w),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: captionText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post copied to clipboard!')),
                  );
                },
                child: Image.asset(
                  'assets/icons/sheee.png',
                  height: 17.w,
                  width: 17.w,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.share_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostsShimmerLoader extends StatefulWidget {
  const PostsShimmerLoader({super.key});

  @override
  State<PostsShimmerLoader> createState() => _PostsShimmerLoaderState();
}

class _PostsShimmerLoaderState extends State<PostsShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.15 + (_controller.value * 0.25);
        final color = Colors.white.withValues(alpha: opacity);

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 64.h, left: 16.w, right: 16.w, bottom: 24.h),
          itemCount: 3,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
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
                            color: color,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 70.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 200.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.r),
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

// ==========================================
// Comments Bottom Sheet Widget
// ==========================================
class _CommentsSheet extends StatefulWidget {
  final Map<String, dynamic> post;
  final ValueChanged<List<Map<String, String>>> onCommentsChanged;

  const _CommentsSheet({required this.post, required this.onCommentsChanged});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<Map<String, String>> _comments;

  // Reply / Edit state
  int? _replyingToIndex;
  int? _editingIndex;

  static const String _currentUserName = 'You';
  static const String _currentUserAvatar =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80';

  @override
  void initState() {
    super.initState();
    _comments = List<Map<String, String>>.from(widget.post['comments']);
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_editingIndex != null) {
        // Save edited comment
        _comments[_editingIndex!]['text'] = text;
        _comments[_editingIndex!]['edited'] = 'true';
        _editingIndex = null;
      } else if (_replyingToIndex != null) {
        // Add as a reply comment (tagged with replyTo name)
        final replyToName = _comments[_replyingToIndex!]['userName'];
        _comments.add({
          'userName': _currentUserName,
          'avatar': _currentUserAvatar,
          'text': text,
          'replyTo': replyToName ?? '',
        });
        _replyingToIndex = null;
      } else {
        _comments.add({
          'userName': _currentUserName,
          'avatar': _currentUserAvatar,
          'text': text,
        });
      }
    });

    widget.onCommentsChanged(_comments);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _startReply(int index) {
    setState(() {
      _replyingToIndex = index;
      _editingIndex = null;
      _controller.clear();
    });
    _focusNode.requestFocus();
  }

  void _startEdit(int index) {
    setState(() {
      _editingIndex = index;
      _replyingToIndex = null;
      _controller.text = _comments[index]['text'] ?? '';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
    _focusNode.requestFocus();
  }

  void _cancelReplyOrEdit() {
    setState(() {
      _replyingToIndex = null;
      _editingIndex = null;
      _controller.clear();
    });
    _focusNode.unfocus();
  }

  void _deleteComment(int index) {
    setState(() {
      _comments.removeAt(index);
      if (_editingIndex == index) _editingIndex = null;
      if (_replyingToIndex == index) _replyingToIndex = null;
    });
    widget.onCommentsChanged(_comments);
  }

  // Bottom sheet with Reply / Edit / Delete options for a comment
  void _showCommentOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.reply, color: Colors.white70),
                title: const Text(
                  'Reply',
                  style: TextStyle(color: Colors.white, fontSize: 14.5),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _startReply(index);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white70,
                ),
                title: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white, fontSize: 14.5),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _startEdit(index);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.copy_rounded,
                  color: Colors.white70,
                ),
                title: const Text(
                  'Copy text',
                  style: TextStyle(color: Colors.white, fontSize: 14.5),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  final text = _comments[index]['text'] ?? '';
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comment copied to clipboard!')),
                  );
                },
              ),
              const Divider(color: Colors.white12, height: 8),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFF3F55),
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Color(0xFFFF3F55), fontSize: 14.5),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDeleteComment(index);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteComment(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete comment?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _deleteComment(index);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFFF3F55)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Comments (${_comments.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.white12, height: 1),

              // Comments list
              Expanded(
                child: _comments.isEmpty
                    ? const Center(
                        child: Text(
                          'No comments yet.\nBe the first to comment!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          final replyTo = comment['replyTo'];
                          final wasEdited = comment['edited'] == 'true';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: GestureDetector(
                              onLongPress: () => _showCommentOptions(index),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                      comment['avatar']!,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (replyTo != null &&
                                            replyTo.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 3,
                                            ),
                                            child: Text(
                                              'Replying to $replyTo',
                                              style: const TextStyle(
                                                color: Color(0xFFFF3F55),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        Text(
                                          comment['userName']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          comment['text']!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                           children: [
                                             if (wasEdited)
                                               const Padding(
                                                 padding: EdgeInsets.only(
                                                   right: 10,
                                                 ),
                                                 child: Text(
                                                   'edited',
                                                   style: TextStyle(
                                                     color: Colors.white30,
                                                     fontSize: 11,
                                                   ),
                                                 ),
                                               ),
                                             GestureDetector(
                                               onTap: () => _startReply(index),
                                               child: const Text(
                                                 'Reply',
                                                 style: TextStyle(
                                                   color: Colors.white54,
                                                   fontSize: 11.5,
                                                   fontWeight: FontWeight.w600,
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 14),
                                             GestureDetector(
                                               onTap: () => _startEdit(index),
                                               child: const Text(
                                                 'Edit',
                                                 style: TextStyle(
                                                   color: Colors.white54,
                                                   fontSize: 11.5,
                                                   fontWeight: FontWeight.w600,
                                                 ),
                                               ),
                                             ),
                                             const SizedBox(width: 14),
                                             GestureDetector(
                                               onTap: () => _confirmDeleteComment(index),
                                               child: const Text(
                                                 'Delete',
                                                 style: TextStyle(
                                                   color: Color(0xFFFF3F55),
                                                   fontSize: 11.5,
                                                   fontWeight: FontWeight.w600,
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                      ],
                                    ),
                                  ),
                                  // 3-dot options button (also opens same sheet)
                                  GestureDetector(
                                    onTap: () => _showCommentOptions(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.white38,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Reply / Edit banner
              if (_replyingToIndex != null || _editingIndex != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: const Color(0xFF2A2A3A),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _editingIndex != null
                              ? 'Editing comment'
                              : 'Replying to ${_comments[_replyingToIndex!]['userName']}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _cancelReplyOrEdit,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white54,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),

              // Input field
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(_currentUserAvatar),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                          decoration: InputDecoration(
                            hintText: _editingIndex != null
                                ? 'Edit your comment...'
                                : _replyingToIndex != null
                                ? 'Write a reply...'
                                : 'Add a comment...',
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF2A2A3A),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _submitComment(),
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _submitComment,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3F55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
