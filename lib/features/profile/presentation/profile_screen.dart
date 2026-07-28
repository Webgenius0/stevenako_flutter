import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                      // Reuse CustomAppBar for consistency
                      CustomAppBar(
                        title: 'Profile',
                        onBackPressed: () {
                          // Standard action
                          Navigator.maybePop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF27273A).withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16.r),
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      Routes.settingScreen,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 18.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.settings_outlined,
                                          color: Colors.white,
                                          size: 24.sp,
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: Text(
                                            'Settings',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.white.withValues(alpha: 0.3),
                                          size: 16.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
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