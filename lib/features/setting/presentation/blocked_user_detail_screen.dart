import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/setting/widgets/settings_action_card.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class BlockedUserDetailScreen extends StatefulWidget {
  final String name;
  final String avatarUrl;
  final String? userId;

  const BlockedUserDetailScreen({
    super.key,
    required this.name,
    required this.avatarUrl,
    this.userId,
  });

  @override
  State<BlockedUserDetailScreen> createState() =>
      _BlockedUserDetailScreenState();
}

class _BlockedUserDetailScreenState extends State<BlockedUserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final String displayUsername = widget.name == 'Frances Swann'
        ? '@Frances487'
        : '@${widget.name.replaceAll(' ', '').toLowerCase()}${widget.name.length * 7}';

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
                      // Reusable Custom App Bar (Matches design header text "Blocked Users")
                      const CustomAppBar(title: 'Blocked Users'),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 24.h),

                              // --------------- Profile Avatar ---------------
                              Container(
                                width: 100.r,
                                height: 100.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.r),
                                  child: widget.avatarUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: widget.avatarUrl,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Container(
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
                              SizedBox(height: 16.h),

                              // --------------- Name & Handle ---------------
                              Text(
                                widget.name,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                displayUsername,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF64748B), // slate-500
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 40.h),

                              // --------------- Action Cards ---------------
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  children: [
                                    // Action: Unblock User
                                    ValueListenableBuilder<bool>(
                                      valueListenable:
                                          blockOrUnblockUserRxObj.isLoading,
                                      builder: (context, isLoading, child) {
                                        return SettingsActionCard(
                                          label: isLoading
                                              ? 'Processing...'
                                              : 'Unblock User',
                                          icon: Icons.person_add_outlined,
                                          onTap: isLoading
                                              ? () {}
                                              : () async {
                                                  if (widget.userId != null &&
                                                      widget
                                                          .userId!
                                                          .isNotEmpty) {
                                                    final res =
                                                        await blockOrUnblockUserRxObj
                                                            .blockOrUnblockUser(
                                                              widget.userId!,
                                                            );
                                                    if (res != null &&
                                                        context.mounted) {
                                                      getMyBlockedUsersRxObj
                                                          .getMyBlockedUsers();
                                                      NavigationService.goBack();
                                                    }
                                                  } else {
                                                    ToastUtil.showShortToast(
                                                      'User ID not found',
                                                    );
                                                  }
                                                },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 16.h),

                                    // Action: Report User (Red Card)
                                    SettingsActionCard(
                                      label: 'Report User',
                                      icon: Icons.person_off_outlined,
                                      isDangerous: true,
                                      onTap: () {
                                        if (widget.userId != null &&
                                            widget.userId!.isNotEmpty) {
                                          NavigationService.navigateTo(
                                            Routes.reportUserScreen,
                                            arguments: {
                                              'userId': widget.userId,
                                              'name': widget.name,
                                            },
                                          );
                                        } else {
                                          ToastUtil.showShortToast(
                                            'User ID not found',
                                          );
                                        }
                                      },
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
