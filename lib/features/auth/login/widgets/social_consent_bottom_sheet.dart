import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/setting/presentation/privacy_policy_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/terms_screen.dart';
import 'package:stevenako_flutter/helpers/di.dart';

class SocialConsentBottomSheet extends StatefulWidget {
  final String providerName;

  const SocialConsentBottomSheet({
    super.key,
    this.providerName = 'Google',
  });

  static Future<bool> show(
    BuildContext context, {
    String providerName = 'Google',
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SocialConsentBottomSheet(providerName: providerName),
    );
    return result ?? false;
  }

  @override
  State<SocialConsentBottomSheet> createState() =>
      _SocialConsentBottomSheetState();
}

class _SocialConsentBottomSheetState extends State<SocialConsentBottomSheet> {
  bool _agreedToTerms = false;
  bool _meetsAgeRequirement = false;

  bool get _canProceed => _agreedToTerms && _meetsAgeRequirement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Icon Header
            Center(
              child: Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: const Color(0xFF8B5CF6),
                  size: 28.r,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              'Before Continuing',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),

            // Subtitle
            Text(
              'To sign in or create an account with ${widget.providerName}, please accept our policies and verify your age:',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 13.5.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),

            // Checkbox 1: Terms & Conditions and Privacy Policy
            GestureDetector(
              onTap: () {
                setState(() {
                  _agreedToTerms = !_agreedToTerms;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (val) {
                        setState(() {
                          _agreedToTerms = val ?? false;
                        });
                      },
                      activeColor: const Color(0xFF8B5CF6),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF475569),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          color: const Color(0xFFCBD5E1),
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsScreen(),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Checkbox 2: Minimum Age Requirement
            GestureDetector(
              onTap: () {
                setState(() {
                  _meetsAgeRequirement = !_meetsAgeRequirement;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: Checkbox(
                      value: _meetsAgeRequirement,
                      onChanged: (val) {
                        setState(() {
                          _meetsAgeRequirement = val ?? false;
                        });
                      },
                      activeColor: const Color(0xFF8B5CF6),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF475569),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'I confirm that I am at least 13 years old (or the minimum legal age required in my country).',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFCBD5E1),
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // Agree & Continue Button
            AnimatedOpacity(
              opacity: _canProceed ? 1.0 : 0.45,
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  gradient: _canProceed
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        )
                      : null,
                  color: _canProceed ? null : const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25.r),
                    onTap: _canProceed
                        ? () {
                            appData.write('terms_and_age_accepted', true);
                            Navigator.pop(context, true);
                          }
                        : null,
                    child: Center(
                      child: Text(
                        'Agree & Continue with ${widget.providerName}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
