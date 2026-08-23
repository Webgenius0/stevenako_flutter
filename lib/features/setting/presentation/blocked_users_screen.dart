import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/setting/model/my_blocked_users_model.dart';
import 'package:stevenako_flutter/features/setting/widgets/blocked_user_item.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  @override
  void initState() {
    super.initState();
    getMyBlockedUsersRxObj.getMyBlockedUsers();
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

                              // --------------- Users List from API ---------------
                              ValueListenableBuilder<bool>(
                                valueListenable:
                                    getMyBlockedUsersRxObj.isLoading,
                                builder: (context, isLoading, child) {
                                  if (isLoading) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40.h,
                                      ),
                                      child: const Center(
                                        child: CupertinoActivityIndicator(
                                          color: Colors.white,
                                          radius: 14,
                                        ),
                                      ),
                                    );
                                  }

                                  return StreamBuilder<MyBlockedUsersModel>(
                                    stream: getMyBlockedUsersRxObj.stream,
                                    builder: (context, snapshot) {
                                      final users =
                                          snapshot.data?.data?.users ?? [];

                                      if (users.isEmpty) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 40.h,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'No blocked users.',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF94A3B8),
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: users.length,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 16.h),
                                        itemBuilder: (context, index) {
                                          final user = users[index];
                                          return BlockedUserItem(
                                            user: user,
                                            onTap: () {
                                              NavigationService.navigateTo(
                                                Routes.blockedUserDetailScreen,
                                                arguments: {
                                                  'name': user.name ?? '',
                                                  'avatarUrl':
                                                      user.avatar ?? '',
                                                  'userId':
                                                      user.id?.toString() ?? '',
                                                },
                                              );
                                            },
                                          );
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
