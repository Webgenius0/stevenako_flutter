import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/assets_helper/app_icons.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/custom_login_text_field.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/social_login_button.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/helpers/toast.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    KeyboardUtil.hideKeyboard(context);

    final name = _fullNameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      ToastUtil.showShortToast('Please enter your full name');
      return;
    }

    if (username.isEmpty) {
      ToastUtil.showShortToast('Please enter a username');
      return;
    }

    if (email.isEmpty) {
      ToastUtil.showShortToast('Please enter your email address');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ToastUtil.showShortToast('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      ToastUtil.showShortToast('Please enter a password');
      return;
    }

    if (password.length < 6) {
      ToastUtil.showShortToast('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword != password) {
      ToastUtil.showShortToast('Passwords do not match');
      return;
    }

    final response = await registerRxObj.registerFun(
      name: name,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    if (response != null &&
        (response.success == true || response.code == 200 || response.code == 201)) {
      NavigationService.navigateTo(
        Routes.signUpVerifyOtpScreen,
        arguments: {'email': email},
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
                                    SizedBox(height: 56.h),

                                    // --------------- Title ---------------
                                    Text(
                                      'Create your\naccount',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    // --------------- Subtitle ---------------
                                    Text(
                                      'It only takes a minute to join the fun.',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 28.h),

                                    // --------------- Full Name Field ---------------
                                    CustomTextField(
                                      controller: _fullNameController,
                                      labelText: 'Full name',
                                      hintText: 'Enter full name',
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Username Field ---------------
                                    CustomTextField(
                                      controller: _usernameController,
                                      labelText: 'username',
                                      hintText: 'Enter username',
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Email Field ---------------
                                    CustomTextField(
                                      controller: _emailController,
                                      labelText: 'Email address',
                                      hintText: 'Enter email address',
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Password Field ---------------
                                    CustomTextField(
                                      controller: _passwordController,
                                      labelText: 'Password',
                                      hintText: 'Enter password',
                                      isPassword: true,
                                      obscureText: _obscurePassword,
                                      onToggleObscure: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Confirm Password Field ---------------
                                    CustomTextField(
                                      controller: _confirmPasswordController,
                                      labelText: 'Confirm Password',
                                      hintText: 'Enter confirm password',
                                      isPassword: true,
                                      obscureText: _obscureConfirmPassword,
                                      onToggleObscure: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),

                                    const Spacer(flex: 3),
                                    SizedBox(height: 24.h),

                                    // --------------- Sign Up Button ---------------
                                    ValueListenableBuilder<bool>(
                                      valueListenable: registerRxObj.isLoading,
                                      builder: (context, isLoading, child) {
                                        return CustomButton(
                                          text: 'Sign Up',
                                          isLoading: isLoading,
                                          onTap: isLoading ? null : _handleSignUp,
                                        );
                                      },
                                    ),
                                    SizedBox(height: 24.h),

                                    // --------------- Divider ---------------
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Divider(
                                            color: Color(0xFF1E293B),
                                            thickness: 1.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                          ),
                                          child: Text(
                                            'or',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF9CA3AF),
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Divider(
                                            color: Color(0xFF1E293B),
                                            thickness: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24.h),

                                    // --------------- Social Register Buttons ---------------
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SocialLoginButton(
                                          iconPath: AppIcons.google,
                                          onTap: () {
                                            // Google Sign Up
                                          },
                                        ),
                                        SizedBox(width: 16.w),
                                        SocialLoginButton(
                                          iconPath: AppIcons.apple,
                                          onTap: () {
                                            // Apple Sign Up
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 28.h),

                                    // --------------- Login Navigation ---------------
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Already have an account? ',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 14.sp,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Login',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF8B5CF6),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  NavigationService.navigateToReplacement(
                                                    Routes.loginScreen,
                                                  );
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
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
