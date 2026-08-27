import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/get_payment_dashboard_model.dart';

class DashboardTopContent extends StatelessWidget {
  final List<TopContent>? topContent;

  const DashboardTopContent({super.key, this.topContent});

  @override
  Widget build(BuildContext context) {
    final List<TopContent> items = topContent ?? [];

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
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
            Text(
              'Top Content',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'No top content available yet',
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
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
          Text(
            'Top Content',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final item = items[index];
              final String rankStr = '${item.rank ?? (index + 1)}';
              final String titleStr = item.title ?? 'Untitled Post';
              final String typeStr = item.typeLabel ?? item.type ?? 'Post';
              final String viewsStr = item.formattedViews ?? '${item.viewsCount ?? 0} views';
              final String subtitleStr = '$typeStr · $viewsStr';
              final String earningsStr = item.formattedEarnings ?? '€${item.earnings ?? 0}';

              return Row(
                children: [
                  Text(
                    rankStr,
                    style: GoogleFonts.inter(
                      color: Colors.white30,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleStr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          subtitleStr,
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    earningsStr,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF10B981),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
