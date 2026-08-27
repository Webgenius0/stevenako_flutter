import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:stevenako_flutter/networks/api_acess.dart';
import 'package:stevenako_flutter/features/profile/model/get_payment_dashboard_model.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_stats_grid.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_earnings_chart.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_recent_tips.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_top_content.dart';
import 'package:stevenako_flutter/features/profile/widgets/dashboard_total_gift.dart';

class DashboardScreen extends StatefulWidget {
  final int? userId;

  const DashboardScreen({super.key, this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  void _fetchDashboard() {
    try {
      log('=== Creator Dashboard: Fetching dashboard data for userId: ${widget.userId} ===');
      getPaymentDashboardRxObj.getDashboard(userId: widget.userId);
    } catch (e, stackTrace) {
      log('=== Creator Dashboard Fetch Exception: $e ===', stackTrace: stackTrace);
    }
  }

  Future<void> _refreshDashboard() async {
    try {
      log('=== Creator Dashboard: Refreshing dashboard data ===');
      await getPaymentDashboardRxObj.getDashboard(userId: widget.userId);
    } catch (e, stackTrace) {
      log('=== Creator Dashboard Refresh Exception: $e ===', stackTrace: stackTrace);
    }
  }

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
            color: Color(0xFF0F0E17),
            image: DecorationImage(
              image: AssetImage('assets/images/dashboard.jpg'),
              fit: BoxFit.cover,
              onError: _onBgImageError,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: getPaymentDashboardRxObj.isLoading,
                    builder: (context, isLoading, child) {
                      return StreamBuilder<GetPaymentDashboardModel>(
                        stream: getPaymentDashboardRxObj.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            log('=== Creator Dashboard Stream Error: ${snapshot.error} ===');
                            return _buildErrorState(snapshot.error.toString());
                          }

                          if (isLoading && !snapshot.hasData) {
                            return _buildShimmerLoader();
                          }

                          try {
                            final model = snapshot.data ??
                                getPaymentDashboardRxObj.dataFetcher.valueOrNull;
                            final dashboardData = model?.data;

                            final stats = dashboardData?.stats;
                            final recentTips = dashboardData?.recentTips;
                            final topContent = dashboardData?.topContent;
                            final totalGift = dashboardData?.totalGift;
                            final settings = dashboardData?.settings;
                            final stripeStatus = dashboardData?.stripeStatus;

                            return RefreshIndicator(
                              color: const Color(0xFF9F75FF),
                              backgroundColor: Colors.black,
                              onRefresh: _refreshDashboard,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 16.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DashboardStatsGrid(stats: stats),
                                    SizedBox(height: 24.h),
                                    const DashboardEarningsChart(),
                                    SizedBox(height: 24.h),
                                    DashboardRecentTips(recentTips: recentTips),
                                    SizedBox(height: 24.h),
                                    DashboardTopContent(topContent: topContent),
                                    SizedBox(height: 24.h),
                                    DashboardTotalGift(
                                      totalGift: totalGift,
                                      stripeStatus: stripeStatus,
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildFooterStats(settings),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            );
                          } catch (e, stackTrace) {
                            log('=== Creator Dashboard Rendering Exception: $e ===', stackTrace: stackTrace);
                            return _buildErrorState('An unexpected error occurred.');
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _onBgImageError(Object exception, StackTrace? stackTrace) {
    log('=== Creator Dashboard Background Image Error: $exception ===');
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

  Widget _buildFooterStats(DashboardSettings? settings) {
    final String rateStr =
        settings?.formattedEarningsRate ?? '€1.00 / 1,000 views';
    final String feeStr =
        settings?.formattedPlatformTipFee ?? '5% (Stripe Connect)';

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
                rateStr,
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
                feeStr,
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

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E2C),
      highlightColor: const Color(0xFF2E2E42),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFFF3F55),
                size: 36.r,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Unable to Load Dashboard',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: _fetchDashboard,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'Retry',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9F75FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
