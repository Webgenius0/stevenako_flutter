import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/setting/model/faqs_model.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
    getFaqsRxObj.getFaqs();
  }

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

                              // FAQ Accordion items from API
                              ValueListenableBuilder<bool>(
                                valueListenable: getFaqsRxObj.isLoading,
                                builder: (context, isLoading, child) {
                                  if (isLoading) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40.h,
                                      ),
                                      child: const Center(
                                        child: CupertinoActivityIndicator(
                                          color: Colors.white,
                                          radius: 14,
                                        ),
                                      ),
                                    );
                                  }

                                  return StreamBuilder<FaqsModel>(
                                    stream: getFaqsRxObj.stream,
                                    builder: (context, snapshot) {
                                      final faqs =
                                          snapshot.data?.data?.faqs ?? [];

                                      if (faqs.isEmpty) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 40.h,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'No FAQs available.',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF94A3B8),
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: faqs.length,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 12.h),
                                        itemBuilder: (context, index) {
                                          final faq = faqs[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF27273A,
                                              ).withValues(alpha: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.05,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                dividerColor:
                                                    Colors.transparent,
                                              ),
                                              child: ExpansionTile(
                                                iconColor: const Color(
                                                  0xFF9F75FF,
                                                ),
                                                collapsedIconColor:
                                                    Colors.white,
                                                title: Text(
                                                  faq.question ?? '',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                childrenPadding:
                                                    EdgeInsets.only(
                                                      left: 16.w,
                                                      right: 16.w,
                                                      bottom: 16.h,
                                                    ),
                                                children: [
                                                  Text(
                                                    faq.answer ?? '',
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
                                      );
                                    },
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
