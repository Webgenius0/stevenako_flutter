import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_colors.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/chat_list_item.dart';
import 'package:stevenako_flutter/features/message/presentation/conversation_screen.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  // Mock Chat Data representing the 4 threads in the reference design
  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'Courtney Henry',
      'message': 'Hi, John! How are you doing',
      'time': '09:46 am',
      'avatarUrl':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'isActive': true,
    },
    {
      'name': 'James Smith',
      'message': 'Hey, Courtney! I\'m doing well, thanks fo...',
      'time': '10:15 am',
      'avatarUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'isActive': true,
    },
    {
      'name': 'Emily Johnson',
      'message': 'Good morning, everyone! Any plans fo...',
      'time': '10:30 am',
      'avatarUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      'isActive': true,
    },
    {
      'name': 'Michael Brown',
      'message': 'Morning, Emily! I\'m thinking of going hi...',
      'time': '10:45 am',
      'avatarUrl':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      'isActive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              // --------------- Background Image ---------------
              Positioned.fill(
                child: Image.asset(AppImages.bg, fit: BoxFit.cover),
              ),

              // --------------- UI Content Layout ---------------
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --------------- Top Navigation / Badge Row ---------------
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // "All Chat" badge button
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120.r),
                                border: Border.all(color: AppColor.c797A7C),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF7C3AED,
                                    ), // Purple-blue badge
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF7C3AED,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'All Chat',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Right-aligned Utility Buttons (Search & Bell)
                            Row(
                              children: [
                                // Outlined Search Icon
                                Container(
                                  width: 42.w,
                                  height: 42.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                    size: 26.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),

                                // Notification Bell Icon with Subtle Circular Background
                                GestureDetector(
                                  onTap: () {
                                    NavigationService.navigateTo(Routes.messageNotificationScreen);
                                  },
                                  child: Container(
                                    width: 42.w,
                                    height: 42.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.notifications_none_rounded,
                                      color: Colors.white,
                                      size: 22.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // --------------- Custom Search Bar ---------------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1E1E2E).withValues(alpha: .35),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .08),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                            cursorColor: const Color(0xFF7C3AED),
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: GoogleFonts.inter(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: const Color(0xFF9CA3AF),
                                size: 22.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // --------------- Messages Header & Activity Indicators ---------------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Messages',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF22C55E), // Online green
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Activity',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF9CA3AF),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // --------------- Chat Threads List ---------------
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 24.h),
                          itemCount: _chats.length,
                          itemBuilder: (context, index) {
                            final chat = _chats[index];
                            return ChatListItem(
                              avatarUrl: chat['avatarUrl'],
                              name: chat['name'],
                              message: chat['message'],
                              time: chat['time'],
                              isActive: chat['isActive'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConversationScreen(
                                      name: chat['name'],
                                      avatarUrl: chat['avatarUrl'],
                                      isActive: chat['isActive'],
                                    ),
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
