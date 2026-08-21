import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shimmer/shimmer.dart';

class ChatListItem extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String message;
  final String time;
  final bool isActive;
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.message,
    required this.time,
    this.isActive = false,
    this.onTap,
  });

  String _buildFullImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    const String baseUrl = 'https://stevenako.thesyndicates.team';
    if (url.startsWith('/')) {
      return '$baseUrl$url';
    }
    return '$baseUrl/$url';
  }

  @override
  Widget build(BuildContext context) {
    final String fullAvatarUrl = _buildFullImageUrl(avatarUrl);

    return InkWell(
      onTap: onTap,
      splashColor: Colors.white.withValues(alpha: 0.05),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Row(
          children: [
            // --------------- Avatar with Active Indicator ---------------
            Stack(
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: fullAvatarUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: fullAvatarUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: const Color(0xFF2A2A3C),
                              highlightColor: const Color(0xFF3F3F56),
                              child: Container(
                                color: const Color(0xFF2A2A3C),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF2A2A3C),
                              child: Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF2A2A3C),
                            child: Center(
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                if (isActive)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E), // Active green
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black, // Dark border separator
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16.w),

            // --------------- Details Column (Name & Message) ---------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9CA3AF), // Muted grey message
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // --------------- Status Column (Time & Double Check) ---------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280), // Dimmed time grey
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6.h),
                Icon(
                  Icons.done_all_rounded,
                  color: const Color(0xFF8B5CF6), // Purple double check
                  size: 16.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
