import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/all_routes.dart';
import '../../../helpers/navigation_service.dart';
import '../data/user_search_api/rx.dart';
import '../model/user_search_model.dart';

// ============================================================
// SearchScren — live API search with debounce + profile tap
// ============================================================

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
  final UserSearchRx _rx = UserSearchRx();

  String _query = '';
  List<SearchedUser> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  Timer? _debounce;

  // ──────────────────────────────────────────────────────────
  // Lifecycle
  // ──────────────────────────────────────────────────────────

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────
  // Search with 500ms debounce
  // ──────────────────────────────────────────────────────────

  void _onQueryChanged(String value) {
    setState(() => _query = value);

    _debounce?.cancel();

    if (value.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final users = await _rx.searchUsers(query: value.trim());
      if (!mounted) return;
      setState(() {
        _results = users;
        _isLoading = false;
        _hasSearched = true;
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onQueryChanged('');
  }

  void _onBack() => Navigator.of(context).maybePop();

  // ──────────────────────────────────────────────────────────
  // Navigate to user profile
  // ──────────────────────────────────────────────────────────

  void _onUserTap(SearchedUser user) {
    NavigationService.navigateTo(
      Routes.profileScreen,
      arguments: {'userId': user.id},
    );
  }

  // ──────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
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
              // ── Header: back + search field ─────────────────
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
                                onChanged: _onQueryChanged,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: 'Search users...',
                                  hintStyle: TextStyle(
                                    color: _hintColor,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                            if (_isLoading)
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFF7C3AED),
                                  ),
                                ),
                              )
                            else if (_query.isNotEmpty)
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

              // ── Results ────────────────────────────────────
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Empty query — show hint
    if (_query.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, color: _hintColor, size: 48.sp),
            SizedBox(height: 12.h),
            Text(
              'Type a name or username to search',
              style: TextStyle(color: _hintColor, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    // Loading
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
        ),
      );
    }

    // No results after search
    if (_hasSearched && _results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search, color: _hintColor, size: 48.sp),
            SizedBox(height: 12.h),
            Text(
              'No users found for "$_query"',
              style: TextStyle(color: _hintColor, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    // Results list
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      itemCount: _results.length,
      separatorBuilder: (_, __) => SizedBox(height: 24.h),
      itemBuilder: (context, index) {
        final user = _results[index];
        return _SearchResultRow(
          user: user,
          onTap: () => _onUserTap(user),
        );
      },
    );
  }
}

// ============================================================
// Reusable row widget
// ============================================================

class _SearchResultRow extends StatelessWidget {
  final SearchedUser user;
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
            // ── Avatar ──────────────────────────────────────
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.avatar ?? '',
                width: 64.w,
                height: 64.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 64.w,
                  height: 64.w,
                  color: const Color(0xFF2A2A3A),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 64.w,
                  height: 64.w,
                  color: const Color(0xFF2A2A3A),
                  child: const Icon(Icons.person, color: Colors.white54),
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // ── Name + Username ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '@${user.username ?? ''}',
                    style: TextStyle(
                      color: _hintColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            // ── Follow indicator ─────────────────────────────
            if (user.isFollow == true)
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: _purple.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Following',
                  style: TextStyle(
                    color: _purple,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}