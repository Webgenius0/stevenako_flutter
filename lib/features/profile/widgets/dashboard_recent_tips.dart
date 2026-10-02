import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../model/get_payment_dashboard_model.dart';

class DashboardRecentTips extends StatelessWidget {
  final List<dynamic>? recentTips;

  const DashboardRecentTips({super.key, this.recentTips});

  @override
  Widget build(BuildContext context) {
    try {
      final List<dynamic> items = recentTips ?? [];

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
                'Recent Tips',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'No recent tips yet',
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
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final item = items[index];
                String name = 'Anonymous Supporter';
                String time = 'Recently';
                String amount = '+€0.00';
                String avatar = '';

                if (item is RecentTip) {
                  final senderName = item.sender?.name?.trim();
                  final senderUsername = item.sender?.username?.trim();
                  if (senderName != null && senderName.isNotEmpty) {
                    name = senderName;
                  } else if (senderUsername != null && senderUsername.isNotEmpty) {
                    name = senderUsername;
                  }

                  time = item.timeAgo ?? item.createdAt ?? 'Recently';
                  amount = item.formattedAmount ??
                      (item.amount != null ? '+€${item.amount}' : '+€0.00');
                  avatar = item.sender?.avatar ?? '';
                } else if (item is Map) {
                  final sender = item['sender'] is Map ? item['sender'] as Map : null;
                  final senderName = sender?['name']?.toString().trim();
                  final senderUsername = sender?['username']?.toString().trim();
                  final tipName = item['name']?.toString().trim();
                  final tipUsername = item['username']?.toString().trim();

                  if (senderName != null && senderName.isNotEmpty) {
                    name = senderName;
                  } else if (senderUsername != null && senderUsername.isNotEmpty) {
                    name = senderUsername;
                  } else if (tipName != null && tipName.isNotEmpty) {
                    name = tipName;
                  } else if (tipUsername != null && tipUsername.isNotEmpty) {
                    name = tipUsername;
                  }

                  time = item['time_ago']?.toString() ??
                      item['time']?.toString() ??
                      item['created_at']?.toString() ??
                      'Recently';

                  amount = item['formatted_amount']?.toString() ??
                      (item['amount'] != null ? '+€${item['amount']}' : '+€0.00');

                  avatar = sender?['avatar']?.toString() ??
                      item['avatar']?.toString() ??
                      item['avatar_url']?.toString() ??
                      '';
                }

                return Row(
                  children: [
                    ClipOval(
                      child: avatar.trim().isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: avatar.trim(),
                              width: 36.r,
                              height: 36.r,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: const Color(0xFF1E1E2C),
                                highlightColor: const Color(0xFF2E2E42),
                                child: Container(
                                  width: 36.r,
                                  height: 36.r,
                                  color: const Color(0xFF1E1E2C),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 18.r,
                                backgroundColor: const Color(0xFF2A2A3A),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: Colors.white54,
                                  size: 18.r,
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
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            time,
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
                      amount,
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
    } catch (e, stackTrace) {
      log('Error rendering DashboardRecentTips: $e', stackTrace: stackTrace);
      return const SizedBox.shrink();
    }
  }
}
