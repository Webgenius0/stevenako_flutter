import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_icons.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
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
                                    // SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.coin,
                                        ), // A simple round token symbol
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
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
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

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
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
                                      borderRadius: BorderRadius.circular(16.r),
                                      onTap: () {},
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
