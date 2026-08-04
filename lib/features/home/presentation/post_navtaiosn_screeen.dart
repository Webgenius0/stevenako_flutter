// ==========================================
// 3. POSTS SUB-SCREEN (Posts Tab)
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostsSubScreen extends StatefulWidget {
  const PostsSubScreen({super.key});

  @override
  State<PostsSubScreen> createState() => _PostsSubScreenState();
}

class _PostsSubScreenState extends State<PostsSubScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'userName': 'Courtney Henry',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'time': '2 hours ago',
      'text':
          'Just completed my design exploration on custom Flutter Beziers! Feels amazing to draw paths from scratch. 💻✨',
      'likes': 142,
      'comments': <Map<String, String>>[
        {
          'userName': 'Alex Turner',
          'avatar':
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
          'text': 'This looks amazing! 🔥',
        },
        {
          'userName': 'Priya Shah',
          'avatar':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&auto=format&fit=crop&q=80',
          'text': 'Bezier curves are so satisfying to build.',
        },
      ],
    },
    {
      'userName': 'Michael Brown',
      'avatar':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
      'time': '5 hours ago',
      'text':
          'Who is up for a sunset hike tomorrow at Sentinel Rock? The skies are clear! ⛰️🥾',
      'likes': 89,
      'comments': <Map<String, String>>[
        {
          'userName': 'David Miller',
          'avatar':
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
          'text': 'Count me in!',
        },
      ],
    },
  ];

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
              _buildOptionTile(
                icon: Icons.share_outlined,
                label: 'Share post',
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share link copied!')),
                  );
                },
              ),
              _buildOptionTile(
                icon: Icons.visibility_off_outlined,
                label: 'Hide post',
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Post hidden')));
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
                setState(() {
                  _posts.removeAt(index);
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Post deleted')));
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
  void _showCommentsSheet(int postIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _CommentsSheet(
          post: _posts[postIndex],
          onCommentsChanged: (updatedComments) {
            setState(() {
              _posts[postIndex]['comments'] = updatedComments;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0E17),
      padding: const EdgeInsets.only(top: 64, left: 16, right: 16),
      child: ListView.separated(
        itemCount: _posts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = _posts[index];
          final commentCount = (post['comments'] as List).length;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(post['avatar']),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['userName'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                            ),
                          ),
                          Text(
                            post['time'],
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
                const SizedBox(height: 12),
                // Text
                Text(
                  post['text'],
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                // Actions row
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Color(0xFFFF3F55),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${post['likes']}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => _showCommentsSheet(index),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/mesagenva.png',
                            height: 17.w,
                            width: 17.w,
                          ),

                          const SizedBox(width: 6),
                          Text(
                            '$commentCount',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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
    final isOwnComment = _comments[index]['userName'] == _currentUserName;

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
              if (isOwnComment) ...[
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
              ],
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
