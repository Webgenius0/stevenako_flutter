import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                      const CustomAppBar(title: 'Privacy Policy'),
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
                                'RealmWorld Privacy Policy',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              Text(
                                'At RealmWorld ("we", "our", or "us"), we value your trust and are committed to protecting your personal data and privacy. This Privacy Policy outlines what information we collect, how it is handled, and your privacy rights under applicable data protection regulations (including GDPR, CCPA, and Apple/Google store policies).',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 14.sp,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 20.h),

                              _buildSectionCard(
                                number: '1',
                                title: 'Information We Collect',
                                bullets: [
                                  'Account Details: When you register, we collect your name, username, email address, and encrypted credentials.',
                                  'User-Generated Content: Photos, videos/reels, captions, text posts, comments, and direct messages you create or share.',
                                  'Optional Location Data: Only collected when you explicitly choose to tag a geographic location on a post.',
                                  'Financial & Transaction Records: Top-up amounts, withdrawal histories, and tip amounts (sensitive credit card details are handled directly by certified processors such as Stripe and are never stored on our servers).',
                                ],
                              ),

                              _buildSectionCard(
                                number: '2',
                                title: 'How We Use Your Information',
                                bullets: [
                                  'To provide, operate, and maintain feed personalization, video playback, and social messaging.',
                                  'To process tips, gifts, and wallet transactions between users and creators securely.',
                                  'To enforce our community guidelines, detect suspicious activity, and prevent harassment or fraudulent behavior.',
                                  'To communicate vital account alerts, security updates, and customer support responses.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '3',
                                title: 'Device Permissions & Purpose',
                                bullets: [
                                  'Camera Permission: Used only when you choose to capture photos or record video reels directly in the app.',
                                  'Photo Library: Used only to select existing photos and videos from your device for profile pictures or feed uploads.',
                                  'Microphone Permission: Used strictly to record audio while capturing video reels.',
                                  'Location Permission: Optional; requested only when you choose the "Add Location" feature on a post.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '4',
                                title: 'Third-Party Services',
                                bullets: [
                                  'Payment Processing: Stripe processes payment card details and creator bank connections under PCI-DSS compliance.',
                                  'Authentication & Infrastructure: Firebase is utilized for Google authentication and secure push notification delivery.',
                                  'We do not sell, rent, or trade your personal information to third-party data brokers or advertisers.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '5',
                                title: 'Data Retention & Account Deletion',
                                bullets: [
                                  'You have the permanent right to request full erasure of your account and personal data at any time.',
                                  'Account deletion is directly accessible in Settings > Account Center > Delete Account.',
                                  'Upon confirmation of account deletion, your profile, credentials, and uploaded posts are permanently erased from our active database.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '6',
                                title: 'Children\'s Privacy (COPPA Compliance)',
                                bullets: [
                                  'RealmWorld is strictly designed for users aged 13 and older.',
                                  'We do not knowingly collect personal data from children under 13. Accounts discovered to belong to underage users will be terminated immediately.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '7',
                                title: 'Data Security Measures',
                                bullets: [
                                  'We implement industry-standard encryption protocols (HTTPS/TLS) for data in transit.',
                                  'Access to user account information is strictly restricted to authorized systems with authenticated API tokens.',
                                ],
                              ),

                              _buildSectionCard(
                                number: '8',
                                title: 'Contact Us & Data Privacy Inquiries',
                                bullets: [
                                  'For any questions or privacy inquiries, contact our Data Protection Officer at privacy@realmworldapp.live.',
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
