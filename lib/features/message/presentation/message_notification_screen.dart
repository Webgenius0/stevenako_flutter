import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/model/msg_notification_model.dart'
    as msg_model;
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class MessageNotificationScreen extends StatefulWidget {
  const MessageNotificationScreen({super.key});

  @override
  State<MessageNotificationScreen> createState() =>
      _MessageNotificationScreenState();
}

class _MessageNotificationScreenState extends State<MessageNotificationScreen> {
  @override
  void initState() {
    super.initState();
    getMsgNotificationRxObj.getMsgNotification();
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24 && dateTime.day == now.day) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('E, h:mm a').format(dateTime);
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'message':
      case 'chat':
        return Icons.chat_bubble_outline_rounded;
      case 'post':
      case 'like':
        return Icons.favorite_border_rounded;
      case 'comment':
        return Icons.comment_outlined;
      case 'withdrawal':
      case 'payment':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.expand(
          child: Stack(
            children: [
              // --------------- Background Image ---------------
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),

              // --------------- Screen Layout ---------------
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Reusable Custom App Bar
                      const CustomAppBar(title: 'Notifications'),

                      // Notification List
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: getMsgNotificationRxObj.isLoading,
                          builder: (context, isLoading, child) {
                            if (isLoading) {
                              return const Center(
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: 14,
                                ),
                              );
                            }

                            return StreamBuilder<
                              msg_model.MsgNotificationModel
                            >(
                              stream: getMsgNotificationRxObj.stream,
                              builder: (context, snapshot) {
                                final notifications =
                                    snapshot.data?.data?.notifications ?? [];

                                if (notifications.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.notifications_off_outlined,
                                          size: 56.sp,
                                          color: const Color(0xFF94A3B8),
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'No notifications yet',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'You will see your notifications here',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF94A3B8),
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return RefreshIndicator(
                                  color: const Color(0xFF9F75FF),
                                  backgroundColor: const Color(0xFF1F1F2C),
                                  onRefresh: () async {
                                    await getMsgNotificationRxObj
                                        .getMsgNotification();
                                  },
                                  child: ListView.separated(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                          parent: BouncingScrollPhysics(),
                                        ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 16.h,
                                    ),
                                    itemCount: notifications.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 12.h),
                                    itemBuilder: (context, index) {
                                      final item = notifications[index];
                                      final notifData = item.data;
                                      final title =
                                          notifData?.title ??
                                          notifData?.senderUsername ??
                                          'Notification';
                                      final message = notifData?.message ?? '';
                                      final isUnread = item.readAt == null;
                                      final icon = _getNotificationIcon(
                                        notifData?.type,
                                      );
                                      final timeStr = _formatTime(
                                        item.createdAt,
                                      );

                                      return Container(
                                        padding: EdgeInsets.all(14.w),
                                        decoration: BoxDecoration(
                                          color: isUnread
                                              ? const Color(
                                                  0xFF27273A,
                                                ).withValues(alpha: 0.6)
                                              : const Color(
                                                  0xFF27273A,
                                                ).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          border: Border.all(
                                            color: isUnread
                                                ? const Color(
                                                    0xFF9F75FF,
                                                  ).withValues(alpha: 0.3)
                                                : Colors.white.withValues(
                                                    alpha: 0.05,
                                                  ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Icon Container
                                            Container(
                                              width: 42.w,
                                              height: 42.w,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF9F75FF,
                                                ).withValues(alpha: 0.15),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                icon,
                                                color: const Color(0xFF9F75FF),
                                                size: 20.sp,
                                              ),
                                            ),
                                            SizedBox(width: 12.w),

                                            // Content
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          title,
                                                          style:
                                                              GoogleFonts.inter(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    isUnread
                                                                    ? FontWeight
                                                                          .bold
                                                                    : FontWeight
                                                                          .w600,
                                                              ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      if (timeStr.isNotEmpty)
                                                        Text(
                                                          timeStr,
                                                          style:
                                                              GoogleFonts.inter(
                                                                color:
                                                                    const Color(
                                                                      0xFF94A3B8,
                                                                    ),
                                                                fontSize: 11.sp,
                                                              ),
                                                        ),
                                                    ],
                                                  ),
                                                  if (message.isNotEmpty) ...[
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      message,
                                                      style: GoogleFonts.inter(
                                                        color: const Color(
                                                          0xFFCBD5E1,
                                                        ),
                                                        fontSize: 12.sp,
                                                        height: 1.4,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),

                                            // Unread indicator dot
                                            if (isUnread) ...[
                                              SizedBox(width: 8.w),
                                              Container(
                                                width: 8.w,
                                                height: 8.w,
                                                margin: EdgeInsets.only(
                                                  top: 4.h,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF9F75FF),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
