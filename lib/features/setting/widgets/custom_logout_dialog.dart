import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/auth/login/presentation/login_screen.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class CustomLogoutDialog extends StatefulWidget {
  const CustomLogoutDialog({super.key});

  @override
  State<CustomLogoutDialog> createState() => _CustomLogoutDialogState();
}

class _CustomLogoutDialogState extends State<CustomLogoutDialog> {
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final bool success = await logoutRxObj.logoutFun();

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      Get.offAll(() => const LoginScreen());
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E), // Matches dark dialog theme
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logout Icon Header
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: const Color(0xFF7F1D1D).withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEE8E80).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: const Color(0xFFEE8E80),
                size: 26.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // Dialog Title
            Text(
              'Log Out',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),

            // Dialog Subtitle
            Text(
              'Are you sure you want to log out of your account?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                // Cancel / No Button
                Expanded(
                  child: GestureDetector(
                    onTap: _isLoading ? null : () => Navigator.pop(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 48.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.inter(
                          color: _isLoading
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Confirm / Yes Button with Cupertino Loading Indicator
                Expanded(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleLogout,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 48.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7F1D1D)
                            .withValues(alpha: _isLoading ? 0.5 : 0.85),
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: const Color(0xFFEE8E80).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CupertinoActivityIndicator(
                                  color: Color(0xFFEE8E80),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Logging out...",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFEE8E80),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Yes, Log Out",
                              style: GoogleFonts.inter(
                                color: const Color(0xFFEE8E80),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
