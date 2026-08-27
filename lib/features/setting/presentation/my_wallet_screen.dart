import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_icons.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:stevenako_flutter/helpers/toast.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  void _showHelpAndFeedbackSheet(BuildContext context) {
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    final user = getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;
    final String userEmail = user?.email ?? '';

    String selectedCategory = 'Wallet & Coins';
    bool isSubmitting = false;

    final List<String> categories = [
      'Wallet & Coins',
      'Live Rewards',
      'Reels & Video',
      'Report a Bug',
      'General Feedback',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B182B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(24.r),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle Indicator
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
                      SizedBox(height: 16.h),

                      // Sheet Title
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9F75FF)
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.support_agent_rounded,
                              color: const Color(0xFF9F75FF),
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Help & Feedback',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'We would love to hear from you or assist you',
                                style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Category Selector Chips
                      Text(
                        'Select Category',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: categories.map((category) {
                          final bool isSelected = selectedCategory == category;
                          return ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setSheetState(() {
                                  selectedCategory = category;
                                });
                              }
                            },
                            selectedColor: const Color(0xFF9F75FF),
                            backgroundColor: const Color(0xFF27273A),
                            labelStyle: GoogleFonts.inter(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF9F75FF)
                                    : Colors.white12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 18.h),

                      // Subject TextFormField
                      Text(
                        'Subject',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: subjectController,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: 'E.g., Issue with coin balance',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 13.sp,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF27273A),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF9F75FF),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Feedback Description TextFormField
                      Text(
                        'Description / Feedback',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: messageController,
                        maxLines: 4,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText:
                              'Please describe your issue or feedback in detail...',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 13.sp,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF27273A),
                          contentPadding: EdgeInsets.all(16.r),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF9F75FF),
                            ),
                          ),
                        ),
                      ),

                      if (userEmail.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.white38,
                              size: 14.r,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Support reply will be sent to $userEmail',
                              style: GoogleFonts.inter(
                                color: Colors.white38,
                                fontSize: 11.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: 24.h),

                      // Submit Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  final subject = subjectController.text.trim();
                                  final message = messageController.text.trim();

                                  if (subject.isEmpty) {
                                    ToastUtil.showShortToast(
                                      'Please enter a subject',
                                    );
                                    return;
                                  }

                                  if (message.isEmpty) {
                                    ToastUtil.showShortToast(
                                      'Please describe your issue',
                                    );
                                    return;
                                  }

                                  setSheetState(() => isSubmitting = true);

                                  try {
                                    await Future.delayed(
                                      const Duration(milliseconds: 800),
                                    );
                                    ToastUtil.showShortToast(
                                      'Thank you! Your feedback has been submitted.',
                                    );
                                    if (sheetContext.mounted) {
                                      Navigator.of(sheetContext).pop();
                                    }
                                  } catch (e) {
                                    ToastUtil.showShortToast(
                                      'Failed to submit feedback. Try again.',
                                    );
                                  } finally {
                                    if (mounted) {
                                      setSheetState(() => isSubmitting = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9F75FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 4,
                          ),
                          child: isSubmitting
                              ? SizedBox(
                                  width: 22.r,
                                  height: 22.r,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : Text(
                                  'Submit Feedback',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                      const CustomAppBar(title: 'My Wallet'),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),

                              // --------------- Coins Wallet Card ---------------
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  image: const DecorationImage(
                                    image: AssetImage(AppImages.card),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                padding: EdgeInsets.all(24.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Coins',
                                          style: GoogleFonts.inter(
                                            color: Colors.white.withValues(
                                              alpha: 0.7,
                                            ),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 14.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.4,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              'Get Coins',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.coin,
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          '16',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Divider(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      height: 1,
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Live Rewards',
                                              style: GoogleFonts.inter(
                                                color: Colors.white.withValues(
                                                  alpha: 0.6,
                                                ),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              '\$0.00',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 18.w,
                                            vertical: 12.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Withdraw',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.5),
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                'Balance',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32.h),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  'Services',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // --------------- Help & Feedback Service Button ---------------
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF27273A,
                                    ).withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(100.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100.r),
                                      onTap: () =>
                                          _showHelpAndFeedbackSheet(context),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                          vertical: 18.h,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info_outline_rounded,
                                              color: Colors.white,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              'Help & Feedback',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
}
