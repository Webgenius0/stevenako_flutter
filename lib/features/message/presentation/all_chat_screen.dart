import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stevenako_flutter/assets_helper/app_colors.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/model/get_all_messae_model.dart';
import 'package:stevenako_flutter/features/message/presentation/conversation_screen.dart';

import 'package:stevenako_flutter/features/message/widgets/chat_list_item.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllMessageListRxObj.getMessages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0 && now.day == dateTime.day) {
      return DateFormat('hh:mm a').format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(dateTime);
    } else {
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF1E1E2E).withValues(alpha: 0.6),
          highlightColor: const Color(0xFF3F3F56).withValues(alpha: 0.4),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 200.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 45.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E).withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFFEF4444).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFEF4444),
                size: 48.sp,
              ),
              SizedBox(height: 12.h),
              Text(
                'Failed to load messages',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                errorMessage.isNotEmpty
                    ? errorMessage
                    : 'Something went wrong while fetching your conversations.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 18.h),
              ElevatedButton.icon(
                onPressed: () {
                  getAllMessageListRxObj.getMessages();
                },
                icon: Icon(Icons.refresh_rounded, size: 18.sp),
                label: Text(
                  'Retry',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.forum_outlined,
              color: const Color(0xFF7C3AED),
              size: 40.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Conversations Yet',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your active chat conversations will appear here.',
            style: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 20.h),
          IconButton(
            onPressed: () => getAllMessageListRxObj.getMessages(),
            icon: Icon(
              Icons.refresh_rounded,
              color: const Color(0xFF7C3AED),
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResultsState(String query) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: const Color(0xFF9CA3AF),
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No results found',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'No conversations match "$query"',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF9CA3AF),
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: Icon(
                Icons.cancel_outlined,
                size: 16.sp,
                color: const Color(0xFF7C3AED),
              ),
              label: Text(
                'Clear search',
                style: GoogleFonts.inter(
                  color: const Color(0xFF7C3AED),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                                padding: const EdgeInsets.all(4.0),
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
                                SizedBox(width: 8.w),
                                // Notification Bell Icon with Subtle Circular Background
                                GestureDetector(
                                  onTap: () {
                                    NavigationService.navigateTo(
                                      Routes.messageNotificationScreen,
                                    );
                                  },
                                  child: Container(
                                    width: 42.w,
                                    height: 42.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
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
                            color: const Color(
                              0xFF1E1E2E,
                            ).withValues(alpha: .35),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: _searchController.text.isNotEmpty
                                  ? const Color(
                                      0xFF7C3AED,
                                    ).withValues(alpha: .5)
                                  : Colors.white.withValues(alpha: .08),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => setState(() {}),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                            cursorColor: const Color(0xFF7C3AED),
                            decoration: InputDecoration(
                              hintText:
                                  'Search by name, username or message...',
                              hintStyle: GoogleFonts.inter(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: _searchController.text.isNotEmpty
                                    ? const Color(0xFF7C3AED)
                                    : const Color(0xFF9CA3AF),
                                size: 22.sp,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.cancel_rounded,
                                        color: const Color(0xFF9CA3AF),
                                        size: 20.sp,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
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
                            Row(
                              children: [
                                Text(
                                  'All Messages',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: const BoxDecoration(
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

                      // --------------- Live Chat Threads Stream ---------------
                      Expanded(
                        child: StreamBuilder<GetAllMesageListModel>(
                          stream: getAllMessageListRxObj.stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                !snapshot.hasData) {
                              return _buildShimmerLoading();
                            }

                            if (snapshot.hasError) {
                              return _buildErrorState(
                                snapshot.error.toString(),
                              );
                            }

                            final model = snapshot.data;
                            if (model == null) {
                              return _buildShimmerLoading();
                            }

                            final conversations =
                                model.data?.conversations ?? [];
                            if (conversations.isEmpty) {
                              if (model.success == false) {
                                return _buildErrorState(
                                  model.message ?? 'Error fetching messages',
                                );
                              }
                              return _buildEmptyState();
                            }

                            final searchQuery = _searchController.text
                                .trim()
                                .toLowerCase();
                            final filtered = conversations.where((
                              conversation,
                            ) {
                              if (searchQuery.isEmpty) return true;
                              final name =
                                  conversation.otherUser?.name?.toLowerCase() ??
                                  '';
                              final username =
                                  conversation.otherUser?.username
                                      ?.toLowerCase() ??
                                  '';
                              final msg =
                                  conversation.latestMessage?.message
                                      ?.toLowerCase() ??
                                  '';
                              return name.contains(searchQuery) ||
                                  username.contains(searchQuery) ||
                                  msg.contains(searchQuery);
                            }).toList();

                            if (filtered.isEmpty) {
                              return _buildNoSearchResultsState(
                                _searchController.text.trim(),
                              );
                            }

                            return RefreshIndicator(
                              color: const Color(0xFF7C3AED),
                              backgroundColor: const Color(0xFF1E1E2E),
                              onRefresh: () async {
                                await getAllMessageListRxObj.getMessages();
                              },
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding: EdgeInsets.only(bottom: 24.h),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final conversation = filtered[index];
                                  final otherUser = conversation.otherUser;
                                  final latestMessage =
                                      conversation.latestMessage;
                                  final avatarUrl = otherUser?.avatar ?? '';
                                  final name =
                                      otherUser?.name ?? 'Unknown User';
                                  final message = latestMessage?.message ?? '';
                                  final timeStr = _formatTime(
                                    latestMessage?.createdAt ??
                                        conversation.updatedAt,
                                  );

                                  return ChatListItem(
                                    avatarUrl: avatarUrl,
                                    name: name,
                                    message: message,
                                    time: timeStr,
                                    isActive: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConversationScreen(
                                                name: name,
                                                avatarUrl: avatarUrl,
                                                isActive: true,
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
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
