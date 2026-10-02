import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/features/auth/google_sing_in/google_singin.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/assets_helper/app_icons.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/custom_login_text_field.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/social_login_button.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/di.dart';
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
  bool _agreedToTerms = false;
  bool _confirmedAge = false;

  final _googleService = GoogleServicesAccount();
  bool _isSocialLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_onFieldChanged);
    _passwordController.removeListener(_onFieldChanged);
    _confirmPasswordController.removeListener(_onFieldChanged);
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isButtonActive {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    return email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        _agreedToTerms &&
        _confirmedAge;
  }

  Future<void> _handleSignUp() async {
    KeyboardUtil.hideKeyboard(context);

    final rawName = _fullNameController.text.trim();
    final rawUsername = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

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

    if (!_agreedToTerms) {
      ToastUtil.showShortToast(
        'Please agree to the Terms & Conditions and Privacy Policy before signing up.',
      );
      return;
    }

    if (!_confirmedAge) {
      ToastUtil.showShortToast(
        'You must meet the minimum age requirement to create an account.',
      );
      return;
    }

    final emailPrefix = email.contains('@') ? email.split('@').first : email;
    final name = rawName.isNotEmpty
        ? rawName
        : (rawUsername.isNotEmpty ? rawUsername : emailPrefix);
    final username = rawUsername.isNotEmpty ? rawUsername : emailPrefix;

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

  Future<void> _handleGoogleSignUp() async {
    if (_isSocialLoading) return;
    KeyboardUtil.hideKeyboard(context);

    if (!_agreedToTerms) {
      ToastUtil.showShortToast(
        'Please agree to the Terms & Conditions and Privacy Policy before signing up.',
      );
      return;
    }

    if (!_confirmedAge) {
      ToastUtil.showShortToast(
        'You must meet the minimum age requirement to create an account.',
      );
      return;
    }

    setState(() => _isSocialLoading = true);

    try {
      final credential = await _googleService.signInWithGoogle();

      if (!mounted) return;

      if (credential != null) {
        appData.write('terms_and_age_accepted', true);
        NavigationService.navigateToReplacement(Routes.navigationMenu);
      } else {
        ToastUtil.showShortToast('Google Sign-In was cancelled.');
      }
    } catch (e) {
      if (!mounted) return;
      ToastUtil.showShortToast('Google Sign-In failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isSocialLoading = false);
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
                                    SizedBox(height: 16.h),

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
                                      labelText: 'Full name (Optional)',
                                      hintText: 'Enter full name',
                                    ),
                                    SizedBox(height: 14.h),

                                    // --------------- Username Field ---------------
                                    CustomTextField(
                                      controller: _usernameController,
                                      labelText: 'Username (Optional)',
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
                                    _PasswordStrengthIndicator(
                                      password: _passwordController.text,
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

                                    SizedBox(height: 18.h),

                                    // --------------- Terms & Conditions Checkbox ---------------
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 22.w,
                                          height: 22.h,
                                          child: Checkbox(
                                            value: _agreedToTerms,
                                            activeColor: const Color(0xFF8B5CF6),
                                            checkColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            side: const BorderSide(
                                              color: Color(0xFF4B5563),
                                              width: 1.5,
                                            ),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                            onChanged: (val) {
                                              setState(() {
                                                _agreedToTerms = val ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              setState(() {
                                                _agreedToTerms = !_agreedToTerms;
                                              });
                                            },
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'I agree to the ',
                                                style: GoogleFonts.inter(
                                                  color: const Color(0xFF9CA3AF),
                                                  fontSize: 13.sp,
                                                  height: 1.35,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'Terms & Conditions',
                                                    style: GoogleFonts.inter(
                                                      color: const Color(0xFF8B5CF6),
                                                      fontWeight: FontWeight.w600,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        NavigationService.navigateTo(
                                                          Routes.termsScreen,
                                                        );
                                                      },
                                                  ),
                                                  const TextSpan(text: ' and '),
                                                  TextSpan(
                                                    text: 'Privacy Policy',
                                                    style: GoogleFonts.inter(
                                                      color: const Color(0xFF8B5CF6),
                                                      fontWeight: FontWeight.w600,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        NavigationService.navigateTo(
                                                          Routes.privacyPolicyScreen,
                                                        );
                                                      },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),

                                    // --------------- Minimum Age Checkbox ---------------
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 22.w,
                                          height: 22.h,
                                          child: Checkbox(
                                            value: _confirmedAge,
                                            activeColor: const Color(0xFF8B5CF6),
                                            checkColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            side: const BorderSide(
                                              color: Color(0xFF4B5563),
                                              width: 1.5,
                                            ),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: VisualDensity.compact,
                                            onChanged: (val) {
                                              setState(() {
                                                _confirmedAge = val ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              setState(() {
                                                _confirmedAge = !_confirmedAge;
                                              });
                                            },
                                            child: Text(
                                              'I confirm that I meet the minimum age requirement (at least 13 years old).',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF9CA3AF),
                                                fontSize: 13.sp,
                                                height: 1.35,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                          onTap: (!isLoading && _isButtonActive)
                                              ? _handleSignUp
                                              : null,
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
                                    _isSocialLoading
                                        ? const Center(
                                            child: CupertinoActivityIndicator(
                                              radius: 14,
                                              color: Color(0xFF8B5CF6),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SocialLoginButton(
                                                iconPath: AppIcons.google,
                                                onTap: _handleGoogleSignUp,
                                              ),
                                              if (Platform.isIOS) ...[
                                                SizedBox(width: 16.w),
                                                SocialLoginButton(
                                                  iconPath: AppIcons.apple,
                                                  onTap: () {
                                                    // Apple Sign Up
                                                  },
                                                ),
                                              ],
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

// =============================================================================
// PASSWORD STRENGTH INDICATOR WITH ANIMATIONS
// =============================================================================

class _PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const _PasswordStrengthIndicator({required this.password});

  bool get _hasMinLength => password.length >= 6;
  bool get _hasUppercase => password.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => password.contains(RegExp(r'[a-z]'));
  bool get _hasDigits => password.contains(RegExp(r'[0-9]'));

  int get _score {
    if (password.isEmpty) return 0;
    int s = 0;
    if (_hasMinLength) s++;
    if (_hasUppercase) s++;
    if (_hasLowercase) s++;
    if (_hasDigits) s++;
    return s;
  }

  String get _label {
    switch (_score) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  Color get _color {
    switch (_score) {
      case 1:
        return const Color(0xFFEF4444); // Red
      case 2:
        return const Color(0xFFF59E0B); // Amber
      case 3:
        return const Color(0xFF8B5CF6); // Purple
      case 4:
        return const Color(0xFF10B981); // Emerald
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF111827).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _color.withValues(alpha: 0.35),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: _color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Strength label & 4 segmented bars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password Strength (Optional)',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.inter(
                    color: _color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  child: Text(_label),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // 4 Segmented Strength Bars with AnimatedContainer
            Row(
              children: List.generate(4, (index) {
                final bool isActive = index < _score;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isActive ? _color : const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 12.h),

            // Checklist requirements in 2x2 grid or compact rows
            Wrap(
              spacing: 12.w,
              runSpacing: 6.h,
              children: [
                _buildRuleItem('At least 6 chars', _hasMinLength),
                _buildRuleItem('Uppercase (A-Z)', _hasUppercase),
                _buildRuleItem('Lowercase (a-z)', _hasLowercase),
                _buildRuleItem('Number (0-9)', _hasDigits),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String title, bool isMet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 14.w,
          height: 14.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isMet
                ? const Color(0xFF10B981)
                : const Color(0xFF374151).withValues(alpha: 0.6),
          ),
          alignment: Alignment.center,
          child: Icon(
            isMet ? Icons.check : Icons.close,
            size: 10.sp,
            color: isMet ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(width: 6.w),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.inter(
            color: isMet ? Colors.white : const Color(0xFF9CA3AF),
            fontSize: 11.5.sp,
            fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
          ),
          child: Text(title),
        ),
      ],
    );
  }
}
