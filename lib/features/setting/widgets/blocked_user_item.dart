import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/setting/model/my_blocked_users_model.dart';
import 'package:stevenako_flutter/networks/endpoints.dart';

class BlockedUserItem extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const BlockedUserItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String avatarUrl = user.avatar ?? '';
    if (avatarUrl.isNotEmpty && !avatarUrl.startsWith('http')) {
      avatarUrl =
          '$url/${avatarUrl.startsWith('/') ? avatarUrl.substring(1) : avatarUrl}';
    }

    final String name = user.name ?? 'Unknown User';
    final String username = user.username != null && user.username!.isNotEmpty
        ? (user.username!.startsWith('@') ? user.username! : '@${user.username}')
        : '';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF27273A).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                // Avatar image
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: avatarUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.person,
                                color: Colors.white70,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.person,
                              color: Colors.white70,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 16.w),

                // Name and Username details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (username.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          username,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF64748B), // slate-500
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF27273A).withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

