import 'dart:io';
import 'package:stevenako_flutter/features/auth/login/presentation/login_screen.dart';
import 'package:stevenako_flutter/features/message/presentation/all_chat_screen.dart';
import 'package:stevenako_flutter/features/message/presentation/contact_info_screen.dart';
import 'package:stevenako_flutter/navigation_menu.dart';
import 'package:stevenako_flutter/onboarding_screen_one.dart';
import 'package:stevenako_flutter/onboarding_screen_two.dart';
import 'package:stevenako_flutter/onboarding_screen_three.dart';
import 'package:flutter/cupertino.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  static const String welcomeScreen = '/welcomeScreen';
  //---------------- Onboarding Screen Start----------------
  static const String onboardingScreenOne = '/onboardingScreenOne';
  static const String onboardingScreenTwo = '/onboardingScreenTwo';
  static const String onboardingScreenThree = '/onboardingScreenThree';
  //---------------- Onboarding Screen End----------------
  static const String navigationMenu = '/navigationMenu';
  static const String createListingScreen = '/createListingScreen';

  //---------------- Login Screen Start----------------
  static const String loginScreen = '/loginScreen';
  //---------------- Login Screen End----------------

  static const String allChatScreen = '/allChatScreen';
  static const String contactInfoScreen = '/contactInfoScreen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcomeScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const OnboardingScreenOne(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const OnboardingScreenOne(),
              );

      case Routes.onboardingScreenOne:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const OnboardingScreenOne(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const OnboardingScreenOne(),
              );

      case Routes.onboardingScreenTwo:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const OnboardingScreenTwo(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const OnboardingScreenTwo(),
              );

      case Routes.onboardingScreenThree:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const OnboardingScreenThree(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const OnboardingScreenThree(),
              );

      case Routes.navigationMenu:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const NavigationMenu(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const NavigationMenu());

      case Routes.loginScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const LoginScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const LoginScreen());

      case Routes.allChatScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const AllChatScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const AllChatScreen());

      case Routes.contactInfoScreen:
        {
          final args = settings.arguments as Map<String, dynamic>?;
          final name = args?['name'] as String? ?? 'Frances Swann';
          final avatarUrl = args?['avatarUrl'] as String? ?? '';
          return Platform.isAndroid
              ? _FadedTransitionRoute(
                  widget: ContactInfoScreen(name: name, avatarUrl: avatarUrl),
                  settings: settings,
                )
              : CupertinoPageRoute(
                  builder: (context) => ContactInfoScreen(name: name, avatarUrl: avatarUrl),
                );
        }

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
    : super(
        settings: settings,
        reverseTransitionDuration: const Duration(milliseconds: 1),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionDuration: const Duration(milliseconds: 1),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
                child: child,
              );
            },
      );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
