import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
                      const CustomAppBar(title: 'Privacy Policy'),

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
                              _buildHeading('1. Information We Collect'),
                              _buildParagraph(
                                'We collect data that you directly provide when registering, customizing your bio, uploading dynamic profile photos, executing transactions in your coin wallet, or communicating with contacts.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('2. How We Use Information'),
                              _buildParagraph(
                                'We use the collected information to power core chat services, verify active user credentials, secure transaction logs, and continuously improve platform performance.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('3. Sharing Your Information'),
                              _buildParagraph(
                                'Stevenako does not sell, trade, or distribute your private profile information or chat logs to any third-party marketing services or external platforms.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('4. Data Security'),
                              _buildParagraph(
                                'We employ top-tier industrial security standards to prevent data breaches, illegal intrusion, and data losses. Remember, securing your private credentials remains your shared responsibility.',
                              ),
                              SizedBox(height: 20.h),
                              _buildHeading('5. Your Rights'),
                              _buildParagraph(
                                'You maintain complete control to access, update, export, or permanently request deletion of all personal profile information or associated chat history under Settings.',
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
