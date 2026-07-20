import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stevenako_flutter/assets_helper/app_images.dart';
import 'package:stevenako_flutter/constants/app_constants.dart';
import 'package:stevenako_flutter/helpers/all_routes.dart';
import 'package:stevenako_flutter/helpers/di.dart';
import 'package:stevenako_flutter/helpers/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // --------------- Animation Controller ---------------
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // --------------- Fade Animation ---------------
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // --------------- Scale Animation ---------------
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // --------------- Start Animation ---------------
    _animationController.forward();

    // --------------- Navigate to next Screen ---------------
    Future.delayed(const Duration(seconds: 3), () {
      NavigationService.navigateToReplacement(Routes.onboardingScreenOne);
    });
  }

  @override
  void dispose() {
    // --------------- Dispose Controller ---------------
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,

        // --------------- Splash Body ---------------
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(AppImages.splashBg, fit: BoxFit.cover),
            ),
            SizedBox(height: 20.h),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // --------------- Animated Logo ---------------
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(
                          AppImages.logo,
                          width: 260.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
