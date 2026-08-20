import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';
import 'package:stevenako_flutter/onboarding_screen_one.dart';
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/helpers/helper_methods.dart';
import 'package:stevenako_flutter/navigation_menu.dart';
import 'package:stevenako_flutter/networks/dio/dio.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    await setInitValue();

    final String? token = appData.read(kKeyAccessToken);
    final bool loggedIn = appData.read(kKeyIsLoggedIn) ?? false;

    if (token != null && token.toString().trim().isNotEmpty && loggedIn) {
      DioSingleton.instance.update(token.toString().trim());
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.splashBg,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.logo,
                    width: 220.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const CupertinoActivityIndicator(
                      radius: 16,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Preparing your experience...',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoggedIn) {
      return const NavigationMenu();
    } else {
      return const OnboardingScreenOne();
    }
  }
}
