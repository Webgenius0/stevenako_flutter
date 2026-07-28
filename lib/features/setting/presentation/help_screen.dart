import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I secure my wallet?',
      'answer':
          'To ensure maximum wallet security, please use a strong password, enable biometrics if available, and never share your QR codes, private keys, or wallet credentials with anyone else.',
    },
    {
      'question': 'How can I get more coins?',
      'answer':
          'Navigate to the "My Wallet" section under settings, and tap the "Get Coins" button. You can select your preferred payment provider to complete the purchase.',
    },
    {
      'question': 'How can I block or report a user?',
      'answer':
          'Go to the user\'s profile or chat settings, tap the top-right options icon, and select "Block this Contact" or "Report User" from the actions menu.',
    },
    {
      'question': 'Is my personal data encrypted?',
      'answer':
          'Yes, we use advanced end-to-end encryption protocols (AES-256) to secure all private chat messaging, document exchanges, and wallet transactions.',
    },
    {
      'question': 'Why is my file upload failing?',
      'answer':
          'Please ensure that your internet connection is active, and check that the document format (e.g. PDF, DOCX, TXT) and file size are within allowed platform limits.',
    },
  ];

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
                      const CustomAppBar(title: 'Help & FAQ'),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),
                              Text(
                                'Frequently Asked Questions',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // FAQ Accordion items
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _faqs.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 12.h),
                                itemBuilder: (context, index) {
                                  final faq = _faqs[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF27273A,
                                      ).withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        iconColor: const Color(0xFF9F75FF),
                                        collapsedIconColor: Colors.white,
                                        title: Text(
                                          faq['question']!,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        childrenPadding: EdgeInsets.only(
                                          left: 16.w,
                                          right: 16.w,
                                          bottom: 16.h,
                                        ),
                                        children: [
                                          Text(
                                            faq['answer']!,
                                            style: GoogleFonts.inter(
                                              color: const Color(
                                                0xFF94A3B8,
                                              ), // slate-400
                                              fontSize: 13.sp,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),

                      // --------------- Help Support Button ---------------
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 24.h,
                        ),
                        child: CustomButton(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Support ticket created.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          text: 'Contact Support',
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
}
