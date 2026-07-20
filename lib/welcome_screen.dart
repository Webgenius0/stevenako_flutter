
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stevenako_flutter/assets_helper/app_icons.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';



class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --------------- Logo & Language Selector Card ---------------
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF3F8F5,
                    ), // Light mint card background
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Stack(
                    children: [
                      // Language Selector at top-right
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'English',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 14.sp,
                                color: const Color(0xFF6B7280),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Centered Logo
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                          child: Image.asset(
                            AppImages.logo_transparent,
                            width: 190.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // --------------- Title ---------------
                Text(
                  'Welcome to Wasel Canada',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),

                SizedBox(height: 8.h),

                // --------------- Subtitle ---------------
                Text(
                  'Buy, Sell, Find Jobs, Discover Businesses, and Connect with Services across Canada.',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 20.h),

                // --------------- Feature Rows ---------------
                _buildFeatureRow(
                  imagePath: AppIcons.buySell,
                  text: 'Buy & Sell near you',
                ),
                _buildFeatureRow(
                  imagePath: AppIcons.job,
                  text: 'Find your next job',
                ),
                _buildFeatureRow(
                  imagePath: AppIcons.business,
                  text: 'Discover local businesses',
                ),
                _buildFeatureRow(
                  imagePath: AppIcons.service,
                  text: 'Connect with services',
                ),

                SizedBox(height: 24.h),

                // --------------- Social Login Buttons ---------------
                CustomButton(
                  icon: SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 22.w,
                    height: 22.w,
                  ),
                  onTap: () {
                    // Google Auth Action
                  },
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  text: 'Continue with Google',
                ),
                SizedBox(height: 14.h),
                CustomButton(
                  text: 'Continue with Apple',
                  icon: SvgPicture.asset(
                    'assets/icons/apple.svg',
                    width: 22.w,
                    height: 22.w,
                  ),
                  onTap: () {
                    // Apple Auth Action
                  },
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                SizedBox(height: 14.h),
                CustomButton(
                  text: 'Continue as Guest',
                  backgroundColor: const Color(0xFFF3F4F6),
                  isLoading: _isLoading,
                  icon: SvgPicture.asset(
                    'assets/icons/guest.svg',
                    width: 20.w,
                    height: 20.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1F2937),
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () async {
                    setState(() => _isLoading = true);
                    // TODO: implement guest auth when provider is ready
                    await Future.delayed(const Duration(milliseconds: 300));
                    setState(() => _isLoading = false);
                    NavigationService.navigateTo(
                      Routes.navigationMenu,
                    );
                  },
                ),

                // --------------- OR Separator ---------------
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'OR',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                      ),
                    ],
                  ),
                ),

                // --------------- Sign Up Button ---------------
                CustomButton(
                  text: 'Sign Up with Email',
                  backgroundColor: const Color(0xFF03045E),
                  textColor: Colors.white,
                  icon: Image.asset(
                    'assets/images/email.png',
                    width: 20.w,
                    height: 20.w,
                  ),
                  onTap: () {
                    NavigationService.navigateTo(Routes.registerScreen);
                  },
                ),

                SizedBox(height: 20.h),

                // --------------- Footer Sign In ---------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(Routes.loginScreen);
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF1B8E5A),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({required String imagePath, required String text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0x171D3B71),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
          ),
          SizedBox(width: 16.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
