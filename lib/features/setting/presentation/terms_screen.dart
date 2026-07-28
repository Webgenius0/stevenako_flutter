import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
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
                      const CustomAppBar(title: 'Terms of Condition'),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeading('1. Introduction'),
                              _buildParagraph(
                                'Welcome to Stevenako! By creating an account or accessing our services, you agree to comply with and be bound by these Terms of Condition. Please read them carefully.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('2. User Representation'),
                              _buildParagraph(
                                'You represent that you are of legal age to form a binding contract and are not prohibited from using these services under local laws. You are responsible for all activity under your profile account.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('3. Code of Conduct'),
                              _buildParagraph(
                                'Users are strictly prohibited from utilizing the Stevenako application to transmit any unlawful, threatening, abusive, harassing, defamatory, or obscene content, or violating intellectual property rights.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('4. Wallet & Coin Purchases'),
                              _buildParagraph(
                                'All purchases of coins or related digital features are final and non-refundable. You agree to secure your credentials and payment account details to prevent unauthorized transactions.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('5. Modifications & Updates'),
                              _buildParagraph(
                                'We reserve the right, at our sole discretion, to modify or replace these terms at any time. Your continued use of the application constitutes acceptance of updated terms and requirements.',
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

  // Heading helper
  Widget _buildHeading(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Paragraph text helper
  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: const Color(0xFF94A3B8), // slate-400
        fontSize: 13.sp,
        height: 1.6,
      ),
    );
  }
}
