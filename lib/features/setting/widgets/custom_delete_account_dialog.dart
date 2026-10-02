import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';

class CustomDeleteAccountDialog extends StatefulWidget {
  const CustomDeleteAccountDialog({super.key});

  @override
  State<CustomDeleteAccountDialog> createState() =>
      _CustomDeleteAccountDialogState();
}

class _CustomDeleteAccountDialogState extends State<CustomDeleteAccountDialog> {
  bool _isLoading = false;

  Future<void> _handleDeleteAccount() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await deleteUserRxObj.deleteUserFun();

    if (!mounted) return;

    if (response != null) {
      await appData.erase();
      DioSingleton.instance.update('');
      if (!mounted) return;
      Navigator.pop(context);
      Get.offAll(() => const SignUpScreen());
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
          color: const Color(0xFF1E1E2E),
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
            // Delete Icon Header
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444),
                size: 26.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // Dialog Title
            Text(
              'Delete Account',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),

            // Dialog Subtitle
            Text(
              'Are you sure you want to permanently delete your account? All your posts, profile data, and media will be erased permanently.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
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

                // Confirm / Delete Button
                Expanded(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleDeleteAccount,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 48.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444)
                            .withValues(alpha: _isLoading ? 0.4 : 0.9),
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CupertinoActivityIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Deleting...",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Delete",
                              style: GoogleFonts.inter(
                                color: Colors.white,
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
