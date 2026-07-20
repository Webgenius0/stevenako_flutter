import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Stack(
            children: [
              // --------------- Background Image ---------------
              Positioned.fill(
                child: Image.asset(AppImages.onboardingOne, fit: BoxFit.cover),
              ),

              // --------------- Gradient Overlay ---------------
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.35),
                        Colors.black.withOpacity(0.8),
                        Colors.black,
                      ],
                      stops: const [0.0, 0.45, 0.75, 1.0],
                    ),
                  ),
                ),
              ),

              // --------------- UI Content (Positioned.fill to take full screen width) ---------------
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 7),

                        // --------------- Title Text ---------------
                        Text(
                          'Welcome',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600, // Semibold
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'to the REALM',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800, // Bold
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // --------------- Subtitle Text ---------------
                        Text(
                          'World is waiting for you to explore.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const Spacer(flex: 1),

                        // --------------- Circular Next Button with Progress Indicator ---------------
                        _buildNextButton(context),

                        SizedBox(height: 36.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: 86.w,
      height: 86.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer progress track / indicator (1/3 progress)
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: CircularProgressIndicator(
              value: 0.33,
              strokeWidth: 2.w,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8B5CF6), // Purple progress color
              ),
            ),
          ),

          // Inner action button
          GestureDetector(
            onTap: () {
              NavigationService.navigateTo(Routes.onboardingScreenTwo);
            },
            child: Container(
              width: 64.w,
              height: 64.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFF1E1A3C,
                ), // Dark Indigo matching the design
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SvgPicture.string(
                '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
                '<path d="M4 12h16M14 6l6 6-6 6" stroke="white" stroke-width="2" stroke-linecap="butt" stroke-linejoin="miter"/>'
                '</svg>',
                width: 24.w,
                height: 24.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
