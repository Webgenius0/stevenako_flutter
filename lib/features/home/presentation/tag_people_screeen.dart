import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

import 'package:stevenako_flutter/features/home/data/rx_add_tag_people/rx.dart';
import 'package:stevenako_flutter/features/home/model/get_tag_people_model.dart';

class TagPeopleScreeen extends StatefulWidget {
  final Set<int> initiallyTaggedIds;

  const TagPeopleScreeen({
    super.key,
    this.initiallyTaggedIds = const {},
  });

  @override
  State<TagPeopleScreeen> createState() => _TagPeopleScreeenState();
}

class _TagPeopleScreeenState extends State<TagPeopleScreeen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _hintColor = Color(0xFF8B8A99);

  final TextEditingController _searchController = TextEditingController();
  late final TagPeopleRx _tagPeopleRxObj;
  late final Set<int> _selectedUserIds;

  @override
  void initState() {
    super.initState();
    _selectedUserIds = {...widget.initiallyTaggedIds};
    _tagPeopleRxObj = TagPeopleRx(
      empty: GetTapPeopleModel(
        success: false,
        code: 0,
        message: "",
        data: null,
      ),
      dataFetcher: BehaviorSubject<GetTapPeopleModel>(),
    );
    _tagPeopleRxObj.fetchTagPeople('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tagPeopleRxObj.dispose();
    super.dispose();
  }

  void _toggle(int id) {
    setState(() {
      if (_selectedUserIds.contains(id)) {
        _selectedUserIds.remove(id);
      } else {
        _selectedUserIds.add(id);
      }
    });
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  void _onContinue() {
    Navigator.of(context).maybePop(_selectedUserIds.toList());
  }

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
              // ---- Header ----
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Tag People',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              // ---- Search input field ----
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Container(
                  height: 52.h,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: _cardBorder),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: _hintColor, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) =>
                              _tagPeopleRxObj.fetchTagPeople(v.trim()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search people...',
                            hintStyle: TextStyle(
                              color: _hintColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _tagPeopleRxObj.fetchTagPeople('');
                          },
                          child: const Icon(
                            Icons.close,
                            color: _hintColor,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ---- StreamBuilder User List ----
              Expanded(
                child: StreamBuilder<GetTapPeopleModel>(
                  stream: _tagPeopleRxObj.stream,
                  builder: (context, snapshot) {
                    final isLoading =
                        snapshot.connectionState == ConnectionState.waiting &&
                            !snapshot.hasData;

                    if (isLoading) {
                      return const _PeopleListShimmer();
                    }

                    final users = snapshot.data?.data?.users ?? [];

                    if (users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_off_outlined,
                              color: _hintColor,
                              size: 44,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No people found'
                                  : 'No matches for "${_searchController.text}"',
                              style: const TextStyle(
                                color: _hintColor,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: users.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final isSelected = user.id != null &&
                            _selectedUserIds.contains(user.id);

                        return _UserRow(
                          user: user,
                          isSelected: isSelected,
                          onTap: () {
                            if (user.id != null) {
                              _toggle(user.id!);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // ---- Bottom Continue CTA Button ----
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _ContinueButton(
                  label: _selectedUserIds.isEmpty
                      ? 'Continue'
                      : 'Continue (${_selectedUserIds.length})',
                  onTap: _onContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer Skeleton Loading Widget for Tag People List
class _PeopleListShimmer extends StatelessWidget {
  const _PeopleListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF262338),
          highlightColor: const Color(0xFF3B3654),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF161426),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80.w,
                        height: 12.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
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

/// User item row widget with CachedNetworkImage and selection checkbox
class _UserRow extends StatelessWidget {
  final User user;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserRow({
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _hintColor = Color(0xFF8B8A99);
  static const Color _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final name = user.name ?? 'User';
    final username = user.username != null && user.username!.isNotEmpty
        ? '@${user.username}'
        : '';
    final avatarUrl = user.avatar ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? _purple : _cardBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(18.r),
            color: const Color(0xFF161426),
          ),
          child: Row(
            children: [
              // Avatar with CachedNetworkImage
              ClipOval(
                child: avatarUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width: 52.w,
                        height: 52.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: const Color(0xFF262338),
                          highlightColor: const Color(0xFF3B3654),
                          child: Container(
                            width: 52.w,
                            height: 52.h,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => _buildFallbackAvatar(name),
                      )
                    : _buildFallbackAvatar(name),
              ),
              const SizedBox(width: 16),

              // Name + username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (username.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        username,
                        style:
                            const TextStyle(color: _hintColor, fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),

              // Selection indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? _purple : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? _purple : _cardBorder,
                    width: 1.6,
                  ),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                        width: 11.w,
                        height: 11.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(String name) {
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
    return Container(
      width: 52.w,
      height: 52.h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ContinueButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          width: double.infinity,
          height: 54.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
