
// ==========================================
// 3. POSTS SUB-SCREEN (Posts Tab)
// ==========================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostsSubScreen extends StatelessWidget {
  const PostsSubScreen({super.key});

  final List<Map<String, dynamic>> _posts = const [
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
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.5),
                          ),
                          Text(
                            post['time'],
                            style: const TextStyle(color: Colors.white30, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.white54),
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
                        Icon(Icons.favorite, color: const Color(0xFFFF3F55), size: 18),
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
          );
        },
      ),
    );
  }
}
