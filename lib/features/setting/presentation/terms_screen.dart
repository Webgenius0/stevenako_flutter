import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    children: [
                      const CustomAppBar(title: 'Terms & Conditions'),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Last Updated Badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: const Color(0xFF8B5CF6)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  'Last Updated: October 2026',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFA78BFA),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 14.h),

                              Text(
                                'Welcome to RealmWorld',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              Text(
                                'These Terms and Conditions ("Terms") govern your use of the RealmWorld mobile application, website, and related services ("Services"). By creating an account or accessing the platform, you agree to comply with and be bound by these Terms.',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 14.sp,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              _buildSectionCard(
                                number: '1',
                                title: 'Eligibility & Account Security',
                                bullets: [
                                  'You must be at least 13 years old (or the applicable minimum age required in your region) to register for an account.',
                                  'You agree to provide accurate and truthful information upon signup and keep your profile details updated.',
                                  'You are responsible for maintaining the confidentiality of your credentials and for all activities that occur under your account.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '2',
                                title: 'User-Generated Content & Zero Tolerance',
                                bullets: [
                                  'Users may share text posts, high-resolution photos, short-form reels/videos, comments, and direct messages.',
                                  'Zero-Tolerance Policy: We strictly prohibit hate speech, harassment, bullying, sexual violence, pornography, illegal substances, and graphic violence.',
                                  'We reserve the right to review, flag, immediately take down content, or ban accounts that violate these safety standards.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '3',
                                title: 'Content Moderation & User Safety',
                                bullets: [
                                  'Reporting: You can report any abusive or objectionable post, comment, or user directly using the in-app "Report" button.',
                                  'Blocking: You can immediately block any user from their profile or chat. Blocked users cannot message you or view your content.',
                                  'Our moderation team reviews reported violations within 24 hours to take corrective actions or remove content.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '4',
                                title: 'In-App Wallet, Deposits & Tipping',
                                bullets: [
                                  'Users can top up their in-app wallet balance to support creators and mentors through virtual tips and gifts.',
                                  'All deposits into your wallet are non-refundable once processed, except where required by mandatory local law.',
                                  'Tips and gifts sent to creators are voluntary and final. Transactions cannot be reversed once confirmed.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '5',
                                title: 'Creator Earnings & Withdrawals',
                                bullets: [
                                  'Creators and mentors who receive tips can withdraw earnings via Stripe Connect once identity verification is complete.',
                                  'Payouts are subject to minimum balance limits, banking clearance times, and applicable processing fees.',
                                  'Accounts engaged in fraud, artificial engagement, or chargeback abuse will forfeit pending balances and face termination.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '6',
                                title: 'Intellectual Property',
                                bullets: [
                                  'You retain all intellectual property rights to the original content you post on RealmWorld.',
                                  'By posting, you grant RealmWorld a worldwide, non-exclusive, royalty-free license to host, display, and distribute your content within the platform.',
                                  'You may not post content that infringes upon third-party copyrights, trademarks, or personal privacy.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '7',
                                title: 'Account Deletion & Termination',
                                bullets: [
                                  'You may delete your account and personal data at any time via Settings > Account Center > Delete Account.',
                                  'We reserve the right to suspend or terminate accounts that breach these Terms without prior notice.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '8',
                                title: 'Contact Information',
                                bullets: [
                                  'For any questions or legal inquiries regarding these Terms, contact our team at support@realmworldapp.live.',
                                  'Official Website: https://dashboard.realmworldapp.live',
                                ],
                              ),

                              SizedBox(height: 24.h),
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

  Widget _buildSectionCard({
    required String number,
    required String title,
    required List<String> bullets,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF161524).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFA78BFA),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...bullets.map(
            (bullet) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, right: 8.w),
                    child: Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      bullet,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 13.sp,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
