import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class ReportUserScreen extends StatefulWidget {
  final String userId;
  final String? userName;

  const ReportUserScreen({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleReportUser() async {
    KeyboardUtil.hideKeyboard(context);

    final reason = _reasonController.text.trim();
    final description = _descriptionController.text.trim();

    if (reason.isEmpty) {
      ToastUtil.showShortToast('Please enter a reason for reporting');
      return;
    }

    if (description.isEmpty) {
      ToastUtil.showShortToast('Please enter a description');
      return;
    }

    final response = await reportUserRxObj.reportUser(
      userId: widget.userId,
      reason: reason,
      description: description,
    );

    if (response != null && mounted) {
      NavigationService.goBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          // Reusable Custom App Bar
                          const CustomAppBar(title: 'Report User'),

                          // Form Content
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24.h),

                                  if (widget.userName != null &&
                                      widget.userName!.isNotEmpty) ...[
                                    Text(
                                      'Report ${widget.userName}',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      'Please provide details about why you are reporting this user.',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF64748B),
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                  ],

                                  // Reason Field
                                  Text(
                                    'Reason',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  TextFormField(
                                    controller: _reasonController,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                    cursorColor: const Color(0xFF9F75FF),
                                    decoration: InputDecoration(
                                      hintText: 'Enter reason (e.g. Harassment, Spam)',
                                      hintStyle: GoogleFonts.inter(
                                        color: const Color(0xFF64748B),
                                        fontSize: 14.sp,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 16.h,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16.r),
                                        borderSide: BorderSide(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16.r),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF9F75FF),
                                          width: 1.5,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF27273A)
                                          .withValues(alpha: 0.15),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  // Description Field
                                  Text(
                                    'Description',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 5,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                    cursorColor: const Color(0xFF9F75FF),
                                    decoration: InputDecoration(
                                      hintText: 'Provide additional details...',
                                      hintStyle: GoogleFonts.inter(
                                        color: const Color(0xFF64748B),
                                        fontSize: 14.sp,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 16.h,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16.r),
                                        borderSide: BorderSide(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16.r),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF9F75FF),
                                          width: 1.5,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF27273A)
                                          .withValues(alpha: 0.15),
                                    ),
                                  ),
                                  SizedBox(height: 32.h),
                                ],
                              ),
                            ),
                          ),

                          // Submit Button
                          ValueListenableBuilder<bool>(
                            valueListenable: reportUserRxObj.isLoading,
                            builder: (context, isLoading, child) {
                              return CustomButton(
                                text: 'Submit Report',
                                isLoading: isLoading,
                                onTap: isLoading ? null : _handleReportUser,
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
