

import 'dart:io';

import 'package:stevenako_flutter/navigation_menu.dart';
import 'package:stevenako_flutter/welcome_screen.dart';
import 'package:flutter/cupertino.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  //---------------- Welcome Screen Start----------------
  static const String welcomeScreen = '/welcomeScreen';
  //---------------- Welcome Screen End----------------

  //---------------- Login Screen Start----------------
  static const String loginScreen = '/loginScreen';
  //---------------- Login Screen End----------------

  //---------------- Register Screen Start----------------
  static const String registerScreen = '/registerScreen';
  static const String registerVerifyScreen = '/registerVerifyScreen';
  static const String selectLocationScreen = '/selectLocationScreen';
  static const String homeScreen = '/homeScreen';

  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String forgetPasswordVerifyOtpScreen =
      '/forgetPasswordVerifyOtpScreen';
  static const String setNewPassword = '/setNewPassword';

  static const String navigationMenu = '/navigationMenu';
  static const String continueAsGuest = '/continueAsGuest';

  static const String createListingScreen = '/createListingScreen';
  static const String buySellStep1Photos = '/buySellStep1Photos';
  static const String buySellStep2Details = '/buySellStep2Details';
  static const String buySellStep3Location = '/buySellStep3Location';
  static const String buySellStep4Contact = '/buySellStep4Contact';
  static const String buySellStep5Review = '/buySellStep5Review';
  static const String buySellDetails = '/buySellDetails';
  static const String buySellSuccess = '/buySellSuccess';

  static const String businessStep1Photos = '/businessStep1Photos';
  static const String businessStep2Info = '/businessStep2Info';
  static const String businessHoursSetter = '/businessHoursSetter';
  static const String businessStep3Gallery = '/businessStep3Gallery';
  static const String businessStep4Location = '/businessStep4Location';
  static const String businessStep5Contact = '/businessStep5Contact';
  static const String businessStep6Review = '/businessStep6Review';
  static const String businessDetails = '/businessDetails';
  static const String businessSuccess = '/businessSuccess';

  static const String jobStep1Photos = '/jobStep1Photos';
  static const String jobStep2Info = '/jobStep2Info';
  static const String jobStep3Location = '/jobStep3Location';
  static const String jobStep4Contact = '/jobStep4Contact';
  static const String jobStep5Review = '/jobStep5Review';
  static const String jobDetails = '/jobDetails';
  static const String jobSuccess = '/jobSuccess';

  static const String serviceStep1Photos = '/serviceStep1Photos';
  static const String serviceStep2Info = '/serviceStep2Info';
  static const String serviceStep3Location = '/serviceStep3Location';
  static const String serviceStep4Contact = '/serviceStep4Contact';
  static const String serviceStep5Review = '/serviceStep5Review';
  static const String serviceDetails = '/serviceDetails';
  static const String serviceSuccess = '/serviceSuccess';

}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ----------- Welcome Routes start-----------
      case Routes.welcomeScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: WelcomeScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => WelcomeScreen());

     

      case Routes.navigationMenu:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const NavigationMenu(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const NavigationMenu());

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
