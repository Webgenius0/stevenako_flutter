import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSavePostCard extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String timeAgo;
  final String? content;
  final String? imageUrl;
  final String likes;
  final String comments;
  final String shares;

  const ProfileSavePostCard({
    super.key,
    required this.avatarUrl,
    required this.username,
    required this.timeAgo,
    this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final clean = url.trim().toLowerCase();
    return clean.startsWith('http://') || clean.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final String cleanImage = (imageUrl ?? '').trim();
    final bool hasImage = _isValidImageUrl(cleanImage);
    final bool hasContent = content != null && content!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- Header (User Info) ----------------
        Row(
          children: [
            avatarUrl.trim().isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl.trim(),
                      width: 36.r,
                      height: 36.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 18.r,
                        backgroundColor: const Color(0xFF2A2A3A),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white54,
                          size: 18.r,
                        ),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 18.r,
                    backgroundColor: const Color(0xFF2A2A3A),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white54,
                      size: 18.r,
                    ),
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

        // ---------------- Text Content (Optional) ----------------
        if (hasContent) ...[
          SizedBox(height: 10.h),
          Text(
            content!.trim(),
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.5.sp,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],

        // ---------------- Image Content (Optional - Matching PostsSubScreenTwo) ----------------
        if (hasImage) ...[
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 280.h,
                minHeight: 120.h,
              ),
              child: CachedNetworkImage(
                imageUrl: cleanImage,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: const Color(0xFF1E1E2C),
                  highlightColor: const Color(0xFF2E2E42),
                  child: Container(
                    height: 160.h,
                    color: const Color(0xFF1E1E2C),
                  ),
                ),
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          ),
        ],

        SizedBox(height: 12.h),

        // ---------------- Action Bar (Likes, Comments, Shares) ----------------
        Row(
          children: [
            Icon(
              Icons.favorite_border_rounded,
              color: Colors.white38,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              likes,
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 16.w),
            Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white38,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              comments,
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 16.w),
            Image.asset(
              'assets/images/ShareIcon.png',
              color: Colors.white38,
              width: 16.w,
              height: 16.h,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.reply_rounded,
                color: Colors.white38,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              shares,
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.white.withValues(alpha: 0.08),
          height: 32.h,
          thickness: 1,
        ),
      ],
    );
  }
}
