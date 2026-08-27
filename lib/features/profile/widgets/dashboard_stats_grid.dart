import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/get_payment_dashboard_model.dart';

class DashboardStatsGrid extends StatelessWidget {
  final DashboardStats? stats;

  const DashboardStatsGrid({super.key, this.stats});

  @override
  Widget build(BuildContext context) {
    final String totalViewsVal =
        stats?.totalViews?.formatted ?? stats?.totalViews?.value?.toString() ?? '0';
    final String totalViewsTrend =
        stats?.totalViews?.changePercentage ?? '+0%';

    final String peakViewersVal =
        stats?.peakViewers?.formatted ?? stats?.peakViewers?.value?.toString() ?? '0';
    final String peakViewersTrend =
        stats?.peakViewers?.changePercentage ?? '+0%';

    final String durationVal =
        stats?.duration?.value?.toString() ?? stats?.duration?.formatted ?? '0h 0m';
    final String durationTrend =
        stats?.duration?.changePercentage ?? '+0%';

    final String newFollowersVal =
        stats?.newFollowers?.formatted ?? stats?.newFollowers?.value?.toString() ?? '0';
    final String newFollowersTrend =
        stats?.newFollowers?.changePercentage ?? '+0%';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/totall_view.png',
                label: 'Total Views',
                value: totalViewsVal,
                trend: totalViewsTrend,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/peak_viewer.png',
                label: 'Peak Viewers',
                value: peakViewersVal,
                trend: peakViewersTrend,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/duration.png',
                label: 'Duration',
                value: durationVal,
                trend: durationTrend,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/new_follwer.png',
                label: 'New Followers',
                value: newFollowersVal,
                trend: newFollowersTrend,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String imagePath,
    required String label,
    required String value,
    required String trend,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFA78BFA).withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFA78BFA).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                imagePath,
                width: 16.w,
                height: 16.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white70,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: const Color(0xFF10B981),
                    size: 14.sp,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    trend,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF10B981),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
