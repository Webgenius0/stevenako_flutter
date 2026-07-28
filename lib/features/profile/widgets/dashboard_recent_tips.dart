import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardRecentTips extends StatelessWidget {
  const DashboardRecentTips({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tips = [
      {
        'name': 'Marcus Webb',
        'time': '2h ago',
        'amount': '+€5.00',
        'avatar':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
      },
      {
        'name': 'Aisha Diallo',
        'time': '5h ago',
        'amount': '+€2.00',
        'avatar':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      },
      {
        'name': 'Jake Torres',
        'time': '1d ago',
        'amount': '+€1.00',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      },
      {
        'name': 'Priya Nair',
        'time': '2d ago',
        'amount': '+€5.00',
        'avatar':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      },
      {
        'name': 'Alex Kim',
        'time': '3d ago',
        'amount': '+€0.50',
        'avatar':
            'https://images.unsplash.com/photo-1500048993953-d23a436266cf?w=100',
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
            'Recent Tips',
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
            itemCount: tips.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: NetworkImage(tip['avatar']!),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['name']!,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          tip['time']!,
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    tip['amount']!,
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
