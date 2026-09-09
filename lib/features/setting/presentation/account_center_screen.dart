import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/setting/model/user_profile_model.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class AccountCenterScreen extends StatefulWidget {
  const AccountCenterScreen({super.key});

  @override
  State<AccountCenterScreen> createState() => _AccountCenterScreenState();
}

class _AccountCenterScreenState extends State<AccountCenterScreen> {
  @override
  void initState() {
    super.initState();
    getUserProfileRxObj.getUserProfile();
  }

  Future<void> _handleDeleteAccount() async {
    final response = await deleteUserRxObj.deleteUserFun();
    if (response != null && mounted) {
      Get.offAll(() => const SignUpScreen());
    }
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
                      const CustomAppBar(title: 'Account Center'),

                      // Scrollable Content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),

                              // --------------- Account Manage Card ---------------
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF27273A,
                                  ).withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 18.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account Manage',
                                      style: GoogleFonts.inter(
                                        color: const Color(
                                          0xFF94A3B8,
                                        ), // slate-400
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.mail_outline_rounded,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: ValueListenableBuilder<bool>(
                                            valueListenable: getUserProfileRxObj.isLoading,
                                            builder: (context, isLoading, child) {
                                              return StreamBuilder<UserProfileModel>(
                                                stream: getUserProfileRxObj.stream,
                                                builder: (context, snapshot) {
                                                  if (isLoading && !snapshot.hasData) {
                                                    return Shimmer.fromColors(
                                                      baseColor: const Color(0xFF27273A),
                                                      highlightColor: const Color(0xFF3B3B54),
                                                      child: Container(
                                                        width: 140.w,
                                                        height: 16.h,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(4.r),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final email = snapshot.data?.data?.user?.email ?? '';
                                                  return Text(
                                                    email.isNotEmpty ? email : 'No email provided',
                                                    style: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // --------------- Change Password Card ---------------
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF27273A,
                                  ).withValues(alpha: 0.4),
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
                                        Routes.changePasswordScreen,
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
                                            Icons.lock_outline_rounded,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 16.w),
                                          Expanded(
                                            child: Text(
                                              'Change Password',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // --------------- Delete Account Card ---------------
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF7F1D1D,
                                  ).withValues(alpha: 0.2), // Light red tint
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF7F1D1D,
                                    ).withValues(alpha: 0.4),
                                    width: 1,
                                  ),
                                ),
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: deleteUserRxObj.isLoading,
                                  builder: (context, isLoading, child) {
                                    return Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        onTap: isLoading
                                            ? null
                                            : _handleDeleteAccount,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 18.h,
                                          ),
                                          child: Row(
                                            children: [
                                              isLoading
                                                  ? Expanded(
                                                      child: Shimmer.fromColors(
                                                        baseColor: const Color(0xFFEF4444).withValues(alpha: 0.5),
                                                        highlightColor: Colors.white,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.cancel_outlined,
                                                              color: const Color(0xFFEF4444),
                                                              size: 20.sp,
                                                            ),
                                                            SizedBox(width: 16.w),
                                                            Text(
                                                              'Deleting Account...',
                                                              style: GoogleFonts.inter(
                                                                color: const Color(0xFFEF4444),
                                                                fontSize: 14.sp,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Icon(
                                                          Icons.cancel_outlined,
                                                          color: const Color(0xFFEF4444),
                                                          size: 20.sp,
                                                        ),
                                                        SizedBox(width: 16.w),
                                                        Text(
                                                          'Delete Account',
                                                          style: GoogleFonts.inter(
                                                            color: const Color(0xFFEF4444),
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
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
