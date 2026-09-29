import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';
import 'package:stevenako_flutter/helpers/toast.dart';

import 'package:stevenako_flutter/networks/api_acess.dart';

class HomeReportBottomSheet extends StatefulWidget {
  final dynamic postId;

  const HomeReportBottomSheet({
    super.key,
    this.postId,
  });

  static Future<void> show(BuildContext context, {dynamic postId}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) => HomeReportBottomSheet(postId: postId),
    );
  }

  @override
  State<HomeReportBottomSheet> createState() => _HomeReportBottomSheetState();
}

class _HomeReportBottomSheetState extends State<HomeReportBottomSheet> {
  final TextEditingController _detailsController = TextEditingController();
  int _selectedReasonIndex = -1;

  final List<Map<String, dynamic>> _reportReasons = const [
    {
      'key': 'spam',
      'title': 'Spam or Scam',
      'subtitle': 'Misleading links, fake accounts, or fraudulent activity',
      'icon': Icons.warning_amber_rounded,
    },
    {
      'key': 'inappropriate_content',
      'title': 'Inappropriate Content',
      'subtitle': 'Nudity, sexual content, violence, or sensitive media',
      'icon': Icons.visibility_off_outlined,
    },
    {
      'key': 'harassment',
      'title': 'Harassment or Bullying',
      'subtitle': 'Targeted threats, abusive behavior, or intimidation',
      'icon': Icons.sentiment_very_dissatisfied_outlined,
    },
    {
      'key': 'hate_speech',
      'title': 'Hate Speech or Discrimination',
      'subtitle': 'Attacks based on identity, race, religion, or orientation',
      'icon': Icons.block_rounded,
    },
    {
      'key': 'technical_issue',
      'title': 'Bug or Technical Issue',
      'subtitle': 'Glitch, broken feature, or unexpected app error',
      'icon': Icons.bug_report_outlined,
    },
    {
      'key': 'other',
      'title': 'Other',
      'subtitle': 'Something else that violates community guidelines',
      'icon': Icons.more_horiz_rounded,
    },
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    KeyboardUtil.hideKeyboard(context);

    if (_selectedReasonIndex < 0) {
      ToastUtil.showShortToast('Please select a reason for reporting');
      return;
    }

    final item = _reportReasons[_selectedReasonIndex];
    final selectedReason = (item['key'] ?? item['title']) as String;
    final reasonTitle = item['title'] as String;
    final details = _detailsController.text.trim();
    final dynamic targetPostId = widget.postId ?? 1;

    final response = await reportPostRxObj.reportPost(
      postId: targetPostId,
      reason: selectedReason,
      description: details.isNotEmpty ? details : reasonTitle,
    );

    if (response != null && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => KeyboardUtil.hideKeyboard(context),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF161524),
            borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                // Drag handle
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.5.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.report_outlined,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Report System',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Help us keep the community safe & trustworthy',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF94A3B8),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white60,
                          size: 22.sp,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),
                Divider(
                  color: Colors.white.withValues(alpha: 0.08),
                  height: 1,
                ),

                // Scrollable Body
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select a reason for reporting',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Reasons list
                        ...List.generate(_reportReasons.length, (index) {
                          final item = _reportReasons[index];
                          final bool isSelected = _selectedReasonIndex == index;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedReasonIndex = index;
                                  });
                                },
                                borderRadius: BorderRadius.circular(14.r),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7C3AED).withValues(alpha: 0.18)
                                        : const Color(0xFF1E1D2E),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF8B5CF6)
                                          : Colors.white.withValues(alpha: 0.06),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
                                              : Colors.white.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Icon(
                                          item['icon'] as IconData,
                                          color: isSelected
                                              ? const Color(0xFFA78BFA)
                                              : Colors.white70,
                                          size: 18.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'] as String,
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 13.5.sp,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              item['subtitle'] as String,
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF94A3B8),
                                                fontSize: 11.sp,
                                                height: 1.25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 20.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? const Color(0xFF8B5CF6)
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF8B5CF6)
                                                : Colors.white38,
                                            width: 1.8,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 13.sp,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        SizedBox(height: 12.h),

                        // Additional Details Input
                        Text(
                          'Additional details (optional)',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _detailsController,
                          maxLines: 3,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13.5.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Describe the issue or share relevant details...',
                            hintStyle: GoogleFonts.inter(
                              color: const Color(0xFF64748B),
                              fontSize: 13.sp,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1E1D2E),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: const BorderSide(
                                color: Color(0xFF8B5CF6),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // Confidentiality Notice
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: const Color(0xFFA78BFA),
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Your report is confidential and reviewed by our moderation team within 24 hours.',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFCBD5E1),
                                    fontSize: 11.sp,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Action Buttons
                        ValueListenableBuilder<bool>(
                          valueListenable: reportPostRxObj.isLoading,
                          builder: (context, isLoading, _) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: OutlinedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => Navigator.of(context).pop(),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.white.withValues(alpha: 0.15),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14.r),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 13.h),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.inter(
                                        color: Colors.white70,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7C3AED),
                                          Color(0xFF402380),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7C3AED)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _handleSubmit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14.r),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 13.h),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                              width: 20.w,
                                              height: 20.w,
                                              child: const CupertinoActivityIndicator(
                                                color: Colors.white,
                                                radius: 10,
                                              ),
                                            )
                                          : Text(
                                              'Submit Report',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                      ],
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
