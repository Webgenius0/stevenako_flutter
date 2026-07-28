import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/totall_view.png',
                label: 'Total Views',
                value: '15.4K',
                trend: '12%',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/peak_viewer.png',
                label: 'Peak Viewers',
                value: '2.1K',
                trend: '12%',
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
                value: '1h 30m',
                trend: '12%',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                imagePath: 'assets/images/new_follwer.png',
                label: 'New Followers',
                value: '+245',
                trend: '12%',
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
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
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
