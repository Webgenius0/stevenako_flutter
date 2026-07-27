import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/common_widgets/custom_button.dart';
import 'package:stevenako_flutter/features/auth/login/widgets/custom_login_text_field.dart';
import 'package:stevenako_flutter/helpers/keyboard.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                                      'Forgot your password?',
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
                                      'Please enter the email address associated with your account, and we\'ll email you a link to reset your password.',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
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

                                    const Spacer(flex: 3),

                                    // --------------- Send Code Button ---------------
                                    CustomButton(
                                      text: 'Send Code',
                                      onTap: () {
                                        // Handle send code
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
