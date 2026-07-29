import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ============================================================
// SearchScren — Search bar + user results list with verified
// badges and back button navigation.
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

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  void _onUserTap(_SearchUser user) {
    // TODO: Navigate to UserProfileScreen if needed
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
              // ---- Header with Back button + Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 56.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: _cardBorder),
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _focusNode,
                                autofocus: true,
                                onChanged: (v) => setState(() => _query = v),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: 'Search..',
                                  hintStyle: TextStyle(
                                    color: _hintColor,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                            if (_query.isNotEmpty)
                              GestureDetector(
                                onTap: _clearSearch,
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // ---- Results list
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(color: _hintColor, fontSize: 15.sp),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                        itemCount: results.length,
                        separatorBuilder: (context, index) => SizedBox(height: 24.h),
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
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                user.avatarUrl,
                width: 64.w,
                height: 64.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64.w,
                  height: 64.h,
                  color: const Color(0xFF2A2A3A),
                  child: const Icon(Icons.person, color: Colors.white54),
                ),
              ),
            ),
            SizedBox(width: 16.w),
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (user.isVerified) ...[
                        SizedBox(width: 8.w),
                        Icon(Icons.verified, color: _purple, size: 20.sp),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.handle,
                    style: TextStyle(
                      color: _hintColor,
                      fontSize: 16.sp,
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