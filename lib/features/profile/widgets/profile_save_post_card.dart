import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSavePostCard extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String timeAgo;
  final String? content;
  final String likes;
  final String comments;
  final String shares;

  const ProfileSavePostCard({
    super.key,
    required this.avatarUrl,
    required this.username,
    required this.timeAgo,
    this.content,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  timeAgo,
                  style: GoogleFonts.inter(
                    color: Colors.white60,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (content != null && content!.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            content!,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(
              Icons.favorite_border_rounded,
              color: Colors.white38,
              size: 14.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              likes,
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 16.w),
            Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white38,
              size: 14.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              comments,
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 16.w),

            Image.asset(
              'assets/images/share_icon.png',
              color: Colors.white38,
              width: 16.w,
              height: 16.h,
            ),

            SizedBox(width: 6.w),
            Text(
              shares,
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.white.withValues(alpha: 0.08),
          height: 40.h,
          thickness: 1,
        ),
      ],
    );
  }
}
