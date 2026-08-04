import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileGridCard extends StatelessWidget {
  final String imageUrl;
  final String viewCount;
  final bool showStatsUnder;
  final String overlayIconPath;

  const ProfileGridCard({
    super.key,
    required this.imageUrl,
    required this.viewCount,
    this.showStatsUnder = false,
    this.overlayIconPath = 'assets/images/play_icon.png',
  });

  @override
  Widget build(BuildContext context) {
    final imageCard = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF1E1E2C),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF9F75FF),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF1E1E2C),
                  child: const Icon(Icons.error, color: Colors.white54),
                ),
              ),
            ),
            // Bottom shadow overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
            // Views Counter (only if not showing stats below)
            if (!showStatsUnder)
              Positioned(
                bottom: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        overlayIconPath,
                        width: 14.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        viewCount,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (showStatsUnder) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: imageCard),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/heart.png',
                  color: Colors.white,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 4.w),
                Text(
                  '10',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),
                Image.asset(
                  'assets/images/message.png',
                  color: Colors.white,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 4.w),
                Text(
                  '8',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),
                Image.asset(
                  'assets/images/Share.png',
                  color: Colors.white,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return imageCard;
  }
}
