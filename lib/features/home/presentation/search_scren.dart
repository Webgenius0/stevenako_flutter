import 'package:flutter/material.dart';

// ============================================================
// SearchScren — Search bar + user results list with verified
// badges. Matches the provided design 1:1.
// (Class name kept exactly as given, typo and all, so it stays
// a drop-in replacement for your existing stub.)
// ============================================================

class _SearchUser {
  final String name;
  final String handle;
  final String avatarUrl;
  final bool isVerified;

  const _SearchUser({
    required this.name,
    required this.handle,
    required this.avatarUrl,
    this.isVerified = false,
  });
}

class SearchScren extends StatefulWidget {
  const SearchScren({super.key});

  @override
  State<SearchScren> createState() => _SearchScrenState();
}

class _SearchScrenState extends State<SearchScren> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardBorder = Color(0xFF3A3850);
  static const Color _hintColor = Color(0xFF8B8A99);
  static const Color _purple = Color(0xFF7C3AED);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';

  // TODO: Replace with real search results from your backend.
  final List<_SearchUser> _allUsers = const [
    _SearchUser(
      name: 'Smith Alex',
      handle: '@smith_alex',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      isVerified: true,
    ),
    _SearchUser(
      name: 'Johnson Emily',
      handle: '@johnson_emily',
      avatarUrl: 'https://i.pravatar.cc/150?img=51',
      isVerified: true,
    ),
    _SearchUser(
      name: 'Williams John',
      handle: '@williams_john',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      isVerified: true,
    ),
    _SearchUser(
      name: 'Brown Sarah',
      handle: '@brown_sarah',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      isVerified: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<_SearchUser> get _filtered {
    if (_query.trim().isEmpty) return _allUsers;
    final q = _query.toLowerCase();
    return _allUsers
        .where((u) =>
    u.name.toLowerCase().contains(q) ||
        u.handle.toLowerCase().contains(q))
        .toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  void _onUserTap(_SearchUser user) {
    // TODO: navigate to this user's profile
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: _cardBorder),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          autofocus: true,
                          onChanged: (v) => setState(() => _query = v),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search..',
                            hintStyle: TextStyle(
                              color: _hintColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: _clearSearch,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.close,
                                color: Colors.white, size: 24),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ---- Results list
              Expanded(
                child: results.isEmpty
                    ? const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: _hintColor, fontSize: 15),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final user = results[index];
                    return _SearchResultRow(
                      user: user,
                      onTap: () => _onUserTap(user),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Reusable row
// ============================================================

class _SearchResultRow extends StatelessWidget {
  final _SearchUser user;
  final VoidCallback onTap;

  const _SearchResultRow({required this.user, required this.onTap});

  static const Color _hintColor = Color(0xFF8B8A99);
  static const Color _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                user.avatarUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xFF2A2A3A),
                  child: const Icon(Icons.person, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (user.isVerified) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.verified,
                            color: _purple, size: 20),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.handle,
                    style: const TextStyle(
                      color: _hintColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}