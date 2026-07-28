import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_app_bar.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_avatar.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_stats_row.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_actions_row.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_tab_button.dart';
import 'package:stevenako_flutter/features/profile/widgets/profile_grid_card.dart';

import 'package:stevenako_flutter/features/profile/widgets/profile_save_post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _activeTab = 0; // 0: Video, 1: Grid, 2: Bookmark

  // Mock media items matching categories
  final List<Map<String, String>> _videoItems = [
    {
      'image':
          'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=400',
      'views': '5.6k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400',
      'views': '5.6k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
      'views': '2.3k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
      'views': '8.9k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=400',
      'views': '12.4k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400',
      'views': '4.1k',
    },
  ];

  final List<Map<String, String>> _gridItems = [
    {
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      'views': '10',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=400',
      'views': '10',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=400',
      'views': '10',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=400',
      'views': '10',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1541614101331-1a5a3a194e92?w=400',
      'views': '10',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=400',
      'views': '10',
    },
  ];

  final List<Map<String, String?>> _saveItems = [
    {
      'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      'username': 'Frances Swann',
      'timeAgo': '2h',
      'content': '',
      'likes': '4.2K',
      'comments': '312',
      'shares': '891',
    },
    {
      'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      'username': 'Frances Swann',
      'timeAgo': '2h',
      'content': "The creator economy is not just a trend — it's a fundamental restructuring of how value flows on the internet. REALM is built for that future.",
      'likes': '4.2K',
      'comments': '312',
      'shares': '891',
    },
    {
      'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      'username': 'Frances Swann',
      'timeAgo': '2h',
      'content': "The creator economy is not just a trend — it's a fundamental restructuring of how value flows on the internet.",
      'likes': '4.2K',
      'comments': '312',
      'shares': '891',
    },
  ];

  List<Map<String, String>> get _currentItems {
    if (_activeTab == 0) return _videoItems;
    return _gridItems;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Stack(
            children: [
              // --------------- Background Image ---------------
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),

              // Gradient Overlay to ensure readable text and sleek appearance
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // --------------- Screen Layout ---------------
              Positioned.fill(
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const ProfileAppBar(
                        name: 'Frances Swann',
                        balance: '250.00',
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 120.h),
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              const ProfileAvatar(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'Frances Swann',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '@Frances487',
                                style: GoogleFonts.inter(
                                  color: Colors.white60,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'I am a funny Video Maker',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF8F8FD9),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              const ProfileStatsRow(
                                likes: '823',
                                followers: '3.7M',
                                following: '925',
                              ),
                              SizedBox(height: 24.h),
                              const ProfileActionsRow(),
                              SizedBox(height: 24.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.h,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ProfileTabButton(
                                      index: 0,
                                      activeTab: _activeTab,
                                      assetPath: 'assets/images/video.png',
                                      onTap: (val) =>
                                          setState(() => _activeTab = val),
                                    ),
                                    ProfileTabButton(
                                      index: 1,
                                      activeTab: _activeTab,
                                      assetPath: 'assets/images/gallery.png',
                                      onTap: (val) =>
                                          setState(() => _activeTab = val),
                                    ),
                                    ProfileTabButton(
                                      index: 2,
                                      activeTab: _activeTab,
                                      assetPath: 'assets/images/save.png',
                                      onTap: (val) =>
                                          setState(() => _activeTab = val),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: _activeTab == 2
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: _saveItems.length,
                                        itemBuilder: (context, index) {
                                          final item = _saveItems[index];
                                          return ProfileSavePostCard(
                                            avatarUrl: item['avatar']!,
                                            username: item['username']!,
                                            timeAgo: item['timeAgo']!,
                                            content: item['content'],
                                            likes: item['likes']!,
                                            comments: item['comments']!,
                                            shares: item['shares']!,
                                          );
                                        },
                                      )
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 12.h,
                                          crossAxisSpacing: 12.w,
                                          childAspectRatio:
                                              _activeTab == 1 ? 0.63 : 0.72,
                                        ),
                                        itemCount: _currentItems.length,
                                        itemBuilder: (context, index) {
                                          final item = _currentItems[index];
                                          return ProfileGridCard(
                                            imageUrl: item['image']!,
                                            viewCount: item['views']!,
                                            showStatsUnder: _activeTab == 1,
                                            overlayIconPath: _activeTab == 2
                                                ? 'assets/images/save.png'
                                                : 'assets/images/play_icon.png',
                                          );
                                        },
                                      ),
                              ),
                            ],
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
      ),
    );
  }
}
