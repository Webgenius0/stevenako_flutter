import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/assets_helper/app_icons.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/model/login_model.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/custom_login_text_field.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/remember_me_check_box_widget.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/social_login_button.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';
import 'package:stevenako_flutter/helpers/toast.dart';

import '../data/rx.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final SigninRx _signinRx;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  // Rate Limiting variables
  int _failedAttempts = 0;
  int _lockoutSeconds = 0;
  Timer? _coolDownTimer;

  static const int _maxAllowedAttempts = 3;
  static const int _lockoutDurationSeconds = 60;

  @override
  void initState() {
    super.initState();

    _signinRx = SigninRx(
      empty: const PostLoginModel(
        success: false,
        code: 0,
        message: '',
        data: null,
      ),
      dataFetcher: BehaviorSubject<PostLoginModel>(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _coolDownTimer?.cancel();
    _signinRx.dataFetcher.close();
    super.dispose();
  }

  void _startLockoutTimer() {
    _coolDownTimer?.cancel();
    setState(() {
      _lockoutSeconds = _lockoutDurationSeconds;
    });

    _coolDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_lockoutSeconds <= 1) {
        timer.cancel();
        setState(() {
          _lockoutSeconds = 0;
          _failedAttempts = 0;
        });
      } else {
        setState(() {
          _lockoutSeconds--;
        });
      }
    });
  }

  // ---------------------------------------------------------------------------
  // EMAIL VALIDATION
  // ---------------------------------------------------------------------------

  String? _validateEmail(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // PASSWORD VALIDATION
  // ---------------------------------------------------------------------------

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // VALIDATION ERROR
  // ---------------------------------------------------------------------------

  void _showValidationError(String message) {
    ToastUtil.showShortToast(message);
  }

  // ---------------------------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------------------------

  Future<void> _handleLogin() async {
    // Prevent login if locked out or loading
    if (_lockoutSeconds > 0) {
      ToastUtil.showShortToast(
          'Too many failed attempts. Please wait $_lockoutSeconds seconds.');
      return;
    }

    if (_isLoading) return;

    // Hide keyboard
    KeyboardUtil.hideKeyboard(context);

    // Validate email
    final emailError = _validateEmail(_emailController.text);

    if (emailError != null) {
      _showValidationError(emailError);
      return;
    }

    // Validate password
    final passwordError = _validatePassword(_passwordController.text);

    if (passwordError != null) {
      _showValidationError(passwordError);
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _signinRx.signInFun(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (result.success == true) {
        _failedAttempts = 0;
        _coolDownTimer?.cancel();
        NavigationService.navigateToReplacement(Routes.navigationMenu);
      } else {
        _handleFailedAttempt();
      }
    } catch (e) {
      if (!mounted) return;
      _handleFailedAttempt();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleFailedAttempt() {
    _failedAttempts++;
    if (_failedAttempts >= _maxAllowedAttempts) {
      _startLockoutTimer();
      ToastUtil.showShortToast(
          'Too many failed login attempts. Please wait 60 seconds.');
    } else {
      final remaining = _maxAllowedAttempts - _failedAttempts;
      ToastUtil.showShortToast(
          'Incorrect email or password. $remaining attempt${remaining == 1 ? '' : 's'} remaining.');
    }
  }

  // ---------------------------------------------------------------------------
  // FORGOT PASSWORD
  // ---------------------------------------------------------------------------

  void _handleForgotPassword() {
    if (_isLoading) return;

    KeyboardUtil.hideKeyboard(context);

    NavigationService.navigateTo(Routes.forgetPasswordScreen);
  }

  // ---------------------------------------------------------------------------
  // SIGN UP
  // ---------------------------------------------------------------------------

  void _handleSignUp() {
    if (_isLoading) return;

    KeyboardUtil.hideKeyboard(context);

    NavigationService.navigateTo(Routes.signUpScreen);
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = _isLoading || _lockoutSeconds > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () {
          KeyboardUtil.hideKeyboard(context);
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox.expand(
            child: Stack(
              children: [
                // ----------------------------------------------------------------
                // BACKGROUND IMAGE
                // ----------------------------------------------------------------
                Positioned.fill(
                  child: Image.asset(AppImages.loginBg, fit: BoxFit.cover),
                ),

                // ----------------------------------------------------------------
                // TOP GLOW
                // ----------------------------------------------------------------
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

                // ----------------------------------------------------------------
                // CONTENT
                // ----------------------------------------------------------------
                Positioned.fill(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 56.h),

                          // ------------------------------------------------
                          // TITLE
                          // ------------------------------------------------
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

                          // ------------------------------------------------
                          // SUBTITLE
                          // ------------------------------------------------
                          Text(
                            'Pick up right where the scroll left off.',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // ------------------------------------------------
                          // RATE LIMIT LOCKOUT BANNER
                          // ------------------------------------------------
                          if (_lockoutSeconds > 0) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3F55)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: const Color(0xFFFF3F55)
                                      .withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    color: const Color(0xFFFF3F55),
                                    size: 22.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      'Too many failed attempts. Try again in 00:${_lockoutSeconds.toString().padLeft(2, "0")}',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFFFF3F55),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],

                          // ------------------------------------------------
                          // EMAIL
                          // ------------------------------------------------
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email address',
                            hintText: 'Enter email address',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: 16.h),

                          // ------------------------------------------------
                          // PASSWORD
                          // ------------------------------------------------
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onToggleObscure: () {
                              if (_isLoading) return;

                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          SizedBox(height: 16.h),

                          // ------------------------------------------------
                          // REMEMBER + FORGOT
                          // ------------------------------------------------
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              RememberMeCheckbox(
                                value: _rememberMe,
                                onChanged: (val) {
                                  if (_isLoading) return;

                                  setState(() {
                                    _rememberMe = val;
                                  });
                                },
                              ),

                              GestureDetector(
                                onTap: _handleForgotPassword,
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

                          SizedBox(height: 40.h),

                          // ------------------------------------------------
                          // LOGIN BUTTON WITH RATE LIMITING & LOADING
                          // ------------------------------------------------
                          CustomButton(
                            text: _lockoutSeconds > 0
                                ? 'Locked (00:${_lockoutSeconds.toString().padLeft(2, "0")})'
                                : 'Login',
                            isLoading: _isLoading,
                            onTap: isButtonDisabled ? null : _handleLogin,
                          ),

                          SizedBox(height: 24.h),

                          // ------------------------------------------------
                          // DIVIDER
                          // ------------------------------------------------
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

                          // ------------------------------------------------
                          // SOCIAL LOGIN
                          // ------------------------------------------------
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              SocialLoginButton(
                                iconPath: AppIcons.google,
                                onTap: isButtonDisabled
                                    ? () {}
                                    : () {
                                        // Google Login
                                      },
                              ),

                              SizedBox(width: 16.w),

                              SocialLoginButton(
                                iconPath: AppIcons.apple,
                                onTap: isButtonDisabled
                                    ? () {}
                                    : () {
                                        // Apple Login
                                      },
                              ),
                            ],
                          ),

                          SizedBox(height: 32.h),

                          // ------------------------------------------------
                          // SIGN UP
                          // ------------------------------------------------
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
                                      ..onTap = _handleSignUp,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
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
