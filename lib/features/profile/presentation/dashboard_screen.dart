import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:stevenako_flutter/features/profile/widgets/dashboard_stats_grid.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_earnings_chart.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_recent_tips.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_top_content.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_total_gift.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dashboard.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DashboardStatsGrid(),
                        SizedBox(height: 24.h),
                        const DashboardEarningsChart(),
                        SizedBox(height: 24.h),
                        const DashboardRecentTips(),
                        SizedBox(height: 24.h),
                        const DashboardTopContent(),
                        SizedBox(height: 24.h),
                        const DashboardTotalGift(),
                        SizedBox(height: 20.h),
                        _buildFooterStats(),
                        SizedBox(height: 24.h),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Creator Dashboard',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }

  Widget _buildFooterStats() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earnings rate',
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                '€1.00 / 1,000 views',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Platform tip fee',
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                '5% (Stripe Connect)',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
