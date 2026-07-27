import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Redirect to login screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      NavigationService.navigateToReplacement(Routes.loginScreen);
    });
  }

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
                child: Image.asset(AppImages.loginBg, fit: BoxFit.cover),
              ),

              // --------------- Top subtle glow overlay ---------------
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 350.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -1.0),
                      radius: 1.3,
                      colors: [
                        const Color(0xFF8B5CF6).withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // --------------- UI Content ---------------
              Positioned.fill(
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // --------------- Success Icon & Confetti Stack ---------------
                          SizedBox(
                            width: 200.w,
                            height: 200.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Confetti pieces positioned around the center circle
                                _buildConfettiPiece(
                                  top: 30.h,
                                  left: 30.w,
                                  angle: 0.2,
                                  color: const Color(0xFFC084FC),
                                  width: 8.w,
                                  height: 16.w,
                                ),
                                _buildConfettiPiece(
                                  top: 15.h,
                                  left: 100.w,
                                  angle: -0.4,
                                  color: const Color(0xFF8B5CF6),
                                  width: 12.w,
                                  height: 8.w,
                                ),
                                _buildConfettiPiece(
                                  top: 40.h,
                                  right: 30.w,
                                  angle: 0.6,
                                  color: const Color(0xFF6B7280),
                                  width: 6.w,
                                  height: 14.w,
                                ),
                                _buildConfettiPiece(
                                  bottom: 45.h,
                                  left: 25.w,
                                  angle: -0.5,
                                  color: const Color(0xFF4B5563),
                                  width: 14.w,
                                  height: 7.w,
                                ),
                                _buildConfettiPiece(
                                  bottom: 25.h,
                                  right: 35.w,
                                  angle: 0.3,
                                  color: const Color(0xFF8B5CF6),
                                  width: 9.w,
                                  height: 15.w,
                                ),
                                _buildConfettiPiece(
                                  top: 90.h,
                                  left: 15.w,
                                  angle: 0.9,
                                  color: const Color(0xFFC084FC),
                                  width: 12.w,
                                  height: 12.w,
                                ),
                                _buildConfettiPiece(
                                  top: 80.h,
                                  right: 15.w,
                                  angle: -0.8,
                                  color: const Color(0xFFC084FC),
                                  width: 8.w,
                                  height: 10.w,
                                ),
                                _buildConfettiPiece(
                                  bottom: 75.h,
                                  left: 45.w,
                                  angle: 0.5,
                                  color: const Color(0xFF8B5CF6),
                                  width: 7.w,
                                  height: 14.w,
                                ),
                                _buildConfettiPiece(
                                  bottom: 60.h,
                                  right: 20.w,
                                  angle: -0.3,
                                  color: const Color(0xFF6B7280),
                                  width: 12.w,
                                  height: 6.w,
                                ),

                                // Center Success Circle
                                Container(
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF9050F0),
                                        Color(0xFF5B21B6),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF8B5CF6,
                                        ).withOpacity(0.4),
                                        blurRadius: 24,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 32.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // --------------- Title ---------------
                          Text(
                            'Successful',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFC084FC),
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // --------------- Subtitle ---------------
                          Text(
                            'You have recovered your password\nsuccessfully.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildConfettiPiece({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double angle,
    required Color color,
    required double width,
    required double height,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}
