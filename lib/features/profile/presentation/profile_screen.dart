import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';

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
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400',
      'views': '1.2k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      'views': '6.7k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
      'views': '3.5k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=400',
      'views': '9.1k',
    },
  ];

  final List<Map<String, String>> _bookmarkItems = [
    {
      'image':
          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
      'views': '7.8k',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=400',
      'views': '5.0k',
    },
  ];

  List<Map<String, String>> get _currentItems {
    if (_activeTab == 0) return _videoItems;
    if (_activeTab == 1) return _gridItems;
    return _bookmarkItems;
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
                      // --------------- Custom App Bar ---------------
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Frances Swann',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                // Wallet Balance Pill
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.myWalletScreen,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF27273A,
                                      ).withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF8B5CF6,
                                        ).withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.credit_card_outlined,
                                          color: const Color(0xFF9F75FF),
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        Container(
                                          width: 1,
                                          height: 12.h,
                                          color: Colors.white24,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          '250.00',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                // Settings Gear Icon
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.settingScreen,
                                    );
                                  },
                                  child: Icon(
                                    Icons.settings_outlined,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // --------------- Scrollable Profile Content ---------------
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            bottom: 120.h,
                          ), // space for bottom nav
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),

                              // Profile Picture with Edit overlay
                              Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 96.r,
                                      height: 96.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white24,
                                          width: 2,
                                        ),
                                        image: const DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.profileSetupScreen,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5.r),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1E1E2C),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // User Name, tag, and bio
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

                              // Stats Row
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem('823', 'Likes'),
                                    _buildDivider(),
                                    _buildStatItem('3.7M', 'Followers'),
                                    _buildDivider(),
                                    _buildStatItem('925', 'Following'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // Dashboard & Edit Buttons
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          // Dashboard Action
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: BorderSide(
                                            color: Colors.white.withValues(
                                              alpha: 0.15,
                                            ),
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14.h,
                                          ),
                                          backgroundColor: Colors.transparent,
                                        ),
                                        icon: Icon(
                                          Icons.show_chart_outlined,
                                          size: 20.sp,
                                        ),
                                        label: Text(
                                          'Dashboard',
                                          style: GoogleFonts.inter(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(
                                                0xFF9F75FF,
                                              ), // Lighter purple
                                              Color(0xFF7C3AED), // Rich purple
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30.r,
                                          ),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.profileSetupScreen,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 14.h,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            size: 20.sp,
                                          ),
                                          label: Text(
                                            'Edit Profile',
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // Custom Tab Bar
                              Row(
                                children: [
                                  _buildTabButton(0, Icons.videocam_outlined),
                                  _buildTabButton(1, Icons.grid_view_rounded),
                                  _buildTabButton(
                                    2,
                                    Icons.bookmark_border_rounded,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),

                              // Grid contents based on active tab
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12.h,
                                        crossAxisSpacing: 12.w,
                                        childAspectRatio: 0.72,
                                      ),
                                  itemCount: _currentItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _currentItems[index];
                                    return _buildGridCard(
                                      item['image']!,
                                      item['views']!,
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

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white54,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 24.h, color: Colors.white12);
  }

  Widget _buildTabButton(int index, IconData icon) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF9F75FF) : Colors.white60,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.h,
              width: isActive ? 60.w : 0,
              decoration: BoxDecoration(
                color: const Color(0xFF9F75FF),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(String imageUrl, String viewCount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF1E1E2C),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF9F75FF),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF1E1E2C),
                  child: const Icon(Icons.error, color: Colors.white54),
                ),
              ),
            ),
            // Bottom shadow overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
            // Views Counter
            Positioned(
              bottom: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      viewCount,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
