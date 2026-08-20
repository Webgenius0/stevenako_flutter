import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/custom_login_text_field.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String? email;
  final String? resetToken;
  final String? otp;

  const SetNewPasswordScreen({
    super.key,
    this.email,
    this.resetToken,
    this.otp,
  });

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    KeyboardUtil.hideKeyboard(context);

    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      ToastUtil.showShortToast('Please enter your new password');
      return;
    }

    if (newPassword.length < 6) {
      ToastUtil.showShortToast('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword != newPassword) {
      ToastUtil.showShortToast('Passwords do not match');
      return;
    }

    String email = widget.email?.trim() ?? '';
    String resetToken = widget.resetToken?.trim() ?? widget.otp?.trim() ?? '';

    if (email.isEmpty || resetToken.isEmpty) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is String && resetToken.isEmpty) {
        resetToken = routeArgs.trim();
      } else if (routeArgs is Map) {
        if (email.isEmpty) {
          email = routeArgs['email']?.toString().trim() ?? '';
        }
        if (resetToken.isEmpty) {
          resetToken = routeArgs['reset_token']?.toString().trim() ??
              routeArgs['resetToken']?.toString().trim() ??
              routeArgs['token']?.toString().trim() ??
              routeArgs['otp']?.toString().trim() ??
              '';
        }
      }
    }

    if (email.isEmpty) {
      ToastUtil.showShortToast('Email is missing. Please restart password reset process.');
      return;
    }

    if (resetToken.isEmpty) {
      ToastUtil.showShortToast('Reset token is missing. Please verify OTP again.');
      return;
    }

    final response = await setNewPasswordRxObj.setNewPasswordFun(
      email: email,
      password: newPassword,
      passwordConfirmation: confirmPassword,
      resetToken: resetToken,
    );

    if (response != null &&
        (response.success == true || response.code == 200 || response.code == 201)) {
      NavigationService.navigateToReplacement(
        Routes.successScreen,
      );
    }
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
      child: GestureDetector(
        onTap: () => KeyboardUtil.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox.expand(
            child: Stack(
              children: [
                // --------------- Background Image ---------------
                Positioned.fill(
                  child: Image.asset(AppImages.loginBg, fit: BoxFit.cover),
                ),

                // --------------- Top subtle glow overlay ---------------
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 300.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.0, -1.0),
                        radius: 1.2,
                        colors: [
                          const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // --------------- UI Content ---------------
                Positioned.fill(
                  child: SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 72.h),

                                    // --------------- Title ---------------
                                    Text(
                                      'Set your password?',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    // --------------- Subtitle ---------------
                                    Text(
                                      'Please enter your new password and confirm it below to reset your password.',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                      ),
                                    ),
                                    SizedBox(height: 36.h),

                                    // --------------- New Password Field ---------------
                                    CustomTextField(
                                      controller: _newPasswordController,
                                      labelText: 'New Password',
                                      isPassword: true,
                                      obscureText: _obscureNewPassword,
                                      onToggleObscure: () {
                                        setState(() {
                                          _obscureNewPassword =
                                              !_obscureNewPassword;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 16.h),

                                    // --------------- Confirm Password Field ---------------
                                    CustomTextField(
                                      controller: _confirmPasswordController,
                                      labelText: 'Confirm Password',
                                      isPassword: true,
                                      obscureText: _obscureConfirmPassword,
                                      onToggleObscure: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),

                                    const Spacer(flex: 3),

                                    // --------------- Update Button ---------------
                                    ValueListenableBuilder<bool>(
                                      valueListenable: setNewPasswordRxObj.isLoading,
                                      builder: (context, isLoading, child) {
                                        return CustomButton(
                                          text: 'Update',
                                          isLoading: isLoading,
                                          onTap: isLoading ? null : _handleUpdatePassword,
                                        );
                                      },
                                    ),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
