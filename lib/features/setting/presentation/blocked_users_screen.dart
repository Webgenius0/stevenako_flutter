import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/setting/widgets/blocked_user_item.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final List<Map<String, String>> _blockedUsers = [
    {
      'name': 'Frances Swann',
      'username': '@Frances487',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&fit=crop',
    },
    {
      'name': 'Frances Swann',
      'username': '@Frances487',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&fit=crop',
    },
    {
      'name': 'Frances Swann',
      'username': '@Frances487',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&fit=crop',
    },
  ];

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

              // --------------- Screen Layout ---------------
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Reusable Custom App Bar
                      const CustomAppBar(title: 'Blocked Users'),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),

                              // --------------- Section Heading ---------------
                              Text(
                                'Users',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // --------------- Users List ---------------
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _blockedUsers.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 16.h),
                                itemBuilder: (context, index) {
                                  final user = _blockedUsers[index];
                                  return BlockedUserItem(
                                    user: user,
                                    onTap: () {
                                      NavigationService.navigateTo(
                                        Routes.blockedUserDetailScreen,
                                        arguments: {
                                          'name': user['name'],
                                          'avatarUrl': user['avatarUrl'],
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 32.h),
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
