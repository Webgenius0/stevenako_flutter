import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/assets_helper/app_icons.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/custom_login_text_field.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/remember_me_check_box_widget.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/social_login_button.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'dennis416@gmail.com');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                          const Color(0xFF8B5CF6).withOpacity(0.18),
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
                                      'Welcome Back',
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
                                      'Pick up right where the scroll left off.',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 36.h),

                                    // --------------- Email Field ---------------
                                    CustomTextField(
                                      controller: _emailController,
                                      labelText: 'Email address',
                                      hintText: 'Enter email address',
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(height: 16.h),

                                    // --------------- Password Field ---------------
                                    CustomTextField(
                                      controller: _passwordController,
                                      labelText: 'Password',
                                      isPassword: true,
                                      obscureText: _obscurePassword,
                                      onToggleObscure: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 16.h),

                                    // --------------- Remember Me & Forgot Password ---------------
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RememberMeCheckbox(
                                          value: _rememberMe,
                                          onChanged: (val) {
                                            setState(() {
                                              _rememberMe = val;
                                            });
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            NavigationService.navigateTo(
                                              Routes.forgetPasswordScreen,
                                            );
                                          },
                                          child: Text(
                                            'Forgot password?',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF9CA3AF),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(flex: 3),

                                    // --------------- Login Button ---------------
                                    CustomButton(
                                      text: 'Login',
                                      onTap: () {
                                        // Handle login action
                                        NavigationService.navigateToReplacement(
                                          Routes.navigationMenu,
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

                                    // --------------- Social Login Buttons ---------------
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SocialLoginButton(
                                          iconPath: AppIcons.google,
                                          onTap: () {
                                            // Google Login
                                          },
                                        ),
                                        SizedBox(width: 16.w),
                                        SocialLoginButton(
                                          iconPath: AppIcons.apple,
                                          onTap: () {
                                            // Apple Login
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32.h),

                                    // --------------- Sign Up Navigation ---------------
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Don’t have an account? ',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 14.sp,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Sign up',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF8B5CF6),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  NavigationService.navigateTo(
                                                    Routes.signUpScreen,
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
