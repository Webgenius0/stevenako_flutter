import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardTopContent extends StatelessWidget {
  const DashboardTopContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> contents = [
      {
        'rank': '1',
        'title': 'Golden hour in Barcelona',
        'subtitle': 'Video · 2.4M views',
        'value': '€2,400',
      },
      {
        'rank': '2',
        'title': '5-ingredient pasta that changed my',
        'subtitle': 'Video · 1.8M views',
        'value': '€1,800',
      },
      {
        'rank': '3',
        'title': 'Creator economy thread',
        'subtitle': 'Post · 890K views',
        'value': '€890',
      },
      {
        'rank': '4',
        'title': 'Lisbon travel photos',
        'subtitle': 'Photos · 650K views',
        'value': '€650',
      },
    ];

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
            itemCount: contents.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final item = contents[index];
              return Row(
                children: [
                  Text(
                    item['rank']!,
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
                          item['title']!,
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
                          item['subtitle']!,
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
                    item['value']!,
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
