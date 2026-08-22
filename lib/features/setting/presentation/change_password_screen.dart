import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/presentation/login_screen.dart';
import 'package:stevenako_flutter/features/message/widgets/custom_app_bar.dart';
import 'package:stevenako_flutter/features/setting/widgets/custom_password_field.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    KeyboardUtil.hideKeyboard(context);

    final currentPassword = _currentController.text.trim();
    final newPassword = _newController.text.trim();
    final confirmPassword = _confirmController.text.trim();

    if (currentPassword.isEmpty) {
      ToastUtil.showShortToast('Please enter your current password');
      return;
    }

    if (newPassword.isEmpty) {
      ToastUtil.showShortToast('Please enter your new password');
      return;
    }

    if (newPassword.length < 6) {
      ToastUtil.showShortToast('New password must be at least 6 characters');
      return;
    }

    if (confirmPassword.isEmpty) {
      ToastUtil.showShortToast('Please confirm your new password');
      return;
    }

    if (confirmPassword != newPassword) {
      ToastUtil.showShortToast('Passwords do not match');
      return;
    }

    final response = await changePasswordRxObj.changePasswordFun(
      oldPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: confirmPassword,
    );

    if (response != null) {
      await logoutRxObj.logoutFun();
      if (mounted) {
        Get.offAll(() => const LoginScreen());
      }
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
      child: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          // Reusable Custom App Bar
                          const CustomAppBar(title: 'Change Password'),

                          // Form Fields
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  SizedBox(height: 24.h),

                                  // Current Password Input
                                  CustomPasswordField(
                                    controller: _currentController,
                                    labelText: 'Current Password',
                                  ),
                                  SizedBox(height: 16.h),
                                  // New Password Input
                                  CustomPasswordField(
                                    controller: _newController,
                                    labelText: 'New Password',
                                  ),
                                  SizedBox(height: 16.h),

                                  // Confirm Password Input
                                  CustomPasswordField(
                                    controller: _confirmController,
                                    labelText: 'Confirm Password',
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ValueListenableBuilder<bool>(
                            valueListenable: changePasswordRxObj.isLoading,
                            builder: (context, isLoading, child) {
                              return CustomButton(
                                text: 'Change',
                                isLoading: isLoading,
                                onTap: isLoading ? null : _handleChangePassword,
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
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
