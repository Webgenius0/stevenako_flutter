import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/features/home/presentation/qr_code_screeen.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/features/setting/widgets/custom_logout_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Show dialog with a QR Code

  // Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const CustomLogoutDialog(),
    );
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
                      const CustomAppBar(title: 'Settings'),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),

                              // --------------- Section Title ---------------
                              Text(
                                'Your Account',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // --------------- Account Center Card ---------------
                              _buildSettingCard(
                                icon: Icons.person_outline_rounded,
                                label: 'Account Center',
                                onTap: () {
                                  NavigationService.navigateTo(
                                    Routes.accountCenterScreen,
                                  );
                                },
                              ),
                              SizedBox(height: 12.h),

                              // --------------- QR & Wallet Grid ---------------
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSettingCard(
                                      icon: Icons.qr_code_scanner_rounded,
                                      label: 'QR Code',
                                      onTap: () {
                                        Get.to(QrCodeScreeen());
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _buildSettingCard(
                                      icon: Icons.wallet_giftcard_outlined,
                                      label: 'My Wallet',
                                      onTap: () {
                                        NavigationService.navigateTo(
                                          Routes.myWalletScreen,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),

                              Divider(
                                color: Colors.white.withValues(alpha: 0.05),
                                height: 1,
                              ),
                              SizedBox(height: 16.h),

                              // --------------- Notification & Blocked ---------------
                              _buildSettingCard(
                                icon: Icons.notifications_none_rounded,
                                label: 'Notification & Activity',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Notifications clicked'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 12.h),
                              _buildSettingCard(
                                icon: Icons.person_off_outlined,
                                label: 'Blocked Users',
                                onTap: () {
                                  NavigationService.navigateTo(
                                    Routes.blockedUsersScreen,
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),

                              Divider(
                                color: Colors.white.withValues(alpha: 0.05),
                                height: 1,
                              ),
                              SizedBox(height: 16.h),

                              // --------------- Support / Info ---------------
                              _buildSettingCard(
                                icon: Icons.info_outline_rounded,
                                label: 'Help and FAQ',
                                onTap: () {
                                  NavigationService.navigateTo(
                                    Routes.helpScreen,
                                  );
                                },
                              ),
                              SizedBox(height: 12.h),
                              _buildSettingCard(
                                icon: Icons.description_outlined,
                                label: 'Terms of Condition',
                                onTap: () {
                                  NavigationService.navigateTo(
                                    Routes.termsScreen,
                                  );
                                },
                              ),
                              SizedBox(height: 12.h),
                              _buildSettingCard(
                                icon: Icons.verified_user_outlined,
                                label: 'Privacy Policy',
                                onTap: () {
                                  NavigationService.navigateTo(
                                    Routes.privacyPolicyScreen,
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),

                              Divider(
                                color: Colors.white.withValues(alpha: 0.05),
                                height: 1,
                              ),
                              SizedBox(height: 24.h),

                              // --------------- Log Out Card ---------------
                              _buildLogOutCard(
                                icon: Icons.logout_rounded,
                                label: 'Log Out',
                                onTap: () {
                                  _showLogoutDialog();
                                },
                              ),
                              SizedBox(height: 32.h),
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

  // Helper widget builder for generic setting list item/cards
  Widget _buildSettingCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF27273A).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22.sp),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget builder for logout buttons (Dark red background)
  Widget _buildLogOutCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7F1D1D).withValues(alpha: 0.6), // Maroon red
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFEE8E80),
                  size: 22.sp,
                ), // warm coral text shade
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFEE8E80),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
