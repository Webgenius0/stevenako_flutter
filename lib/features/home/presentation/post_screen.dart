// ==========================================
// 3. POSTS SUB-SCREEN (Posts Tab)
// ==========================================
import 'package:flutter/material.dart';
import 'package:stevenako_flutter/features/home/presentation/post_deatils_screeen.dart';


class PostsSubScreen extends StatefulWidget {
  const PostsSubScreen({super.key});

  @override
  State<PostsSubScreen> createState() => _PostsSubScreenState();
}

class _PostsSubScreenState extends State<PostsSubScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'userName': 'Courtney Henry',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      'time': '2 hours ago',
      'text': 'Just completed my design exploration on custom Flutter Beziers! Feels amazing to draw paths from scratch. 💻✨',
      'likes': 142,
    },
    {
      'userName': 'Michael Brown',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
      'time': '5 hours ago',
      'text': 'Who is up for a sunset hike tomorrow at Sentinel Rock? The skies are clear! ⛰️🥾',
      'likes': 89,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post saved!')),
                  );
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post hidden')),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete post?', style: TextStyle(color: Colors.white)),
          content: const Text(
            'This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _posts.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Color(0xFFFF3F55))),
            ),
          ],
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
      color: Colors.transparent, // Transparent to show the NavigationMenu gradient
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 64,
        left: 16,
        right: 16,
      ),
      child: ListView.separated(
        itemCount: _posts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = _posts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailsScreen(postData: post),
                ),
              );
            },
            child: Container(
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
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.5),
                          ),
                          Text(
                            post['time'],
                            style: const TextStyle(color: Colors.white30, fontSize: 11),
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
                        const Icon(Icons.favorite, color: Color(0xFFFF3F55), size: 18),
                        const SizedBox(width: 6),
                        Text('${post['likes']}', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                      ],
                    ),
                    const SizedBox(width: 24),
                    const Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 18),
                        SizedBox(width: 6),
                        Text('12', style: TextStyle(color: Colors.white70, fontSize: 12.5)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}