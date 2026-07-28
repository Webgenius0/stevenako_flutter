import 'dart:io';
import 'package:stevenako_flutter/features/auth/login/presentation/login_screen.dart';

import 'package:stevenako_flutter/features/message/presentation/all_chat_screen.dart';
import 'package:stevenako_flutter/features/message/presentation/contact_info_screen.dart';

import 'package:stevenako_flutter/features/auth/register/presentation/forget_password.dart';
import 'package:stevenako_flutter/features/auth/register/presentation/forget_password_otp_verify_screen.dart';
import 'package:stevenako_flutter/features/auth/set_new_password/presentation/set_new_password_screen.dart';
import 'package:stevenako_flutter/features/auth/set_new_password/presentation/success_screen.dart';
import 'package:stevenako_flutter/features/auth/sign_up/presentation/sign_up_screen.dart';
import 'package:stevenako_flutter/features/auth/sign_up/presentation/sign_up_verify_otp_screen.dart';
import 'package:stevenako_flutter/features/auth/profile_setup/presentation/profile_setup_screen.dart';
import 'package:stevenako_flutter/features/profile/presentation/edit_profile_screen.dart';
import 'package:stevenako_flutter/features/profile/presentation/dashboard_screen.dart';
import 'package:stevenako_flutter/navigation_menu.dart';
import 'package:stevenako_flutter/onboarding_screen_one.dart';
import 'package:stevenako_flutter/onboarding_screen_two.dart';
import 'package:stevenako_flutter/onboarding_screen_three.dart';
import 'package:stevenako_flutter/features/setting/presentation/setting_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/account_center_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/my_wallet_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/blocked_users_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/blocked_user_detail_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/change_password_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/help_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/terms_screen.dart';
import 'package:stevenako_flutter/features/setting/presentation/privacy_policy_screen.dart';
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

  //---------------- Forget Password Screen Start----------------
  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String forgetPasswordVerifyOtpScreen =
      '/forgetPasswordVerifyOtpScreen';
  static const String setNewPassword = '/setNewPassword';
  static const String successScreen = '/successScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String signUpVerifyOtpScreen = '/signUpVerifyOtpScreen';
  static const String profileSetupScreen = '/profileSetupScreen';
  //---------------- Forget Password Screen End----------------

  static const String settingScreen = '/settingScreen';
  static const String accountCenterScreen = '/accountCenterScreen';
  static const String myWalletScreen = '/myWalletScreen';
  static const String blockedUsersScreen = '/blockedUsersScreen';
  static const String blockedUserDetailScreen = '/blockedUserDetailScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String helpScreen = '/helpScreen';
  static const String termsScreen = '/termsScreen';
  static const String privacyPolicyScreen = '/privacyPolicyScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String dashboardScreen = '/dashboardScreen';

  //---------------- Register Screen Start----------------
  // static const String registerScreen = '/registerScreen';
  // static const String registerVerifyScreen = '/registerVerifyScreen';
  // static const String selectLocationScreen = '/selectLocationScreen';
  // static const String homeScreen = '/homeScreen';

  // static const String forgetPasswordScreen = '/forgetPasswordScreen';
  // static const String forgetPasswordVerifyOtpScreen =
  //     '/forgetPasswordVerifyOtpScreen';
  // static const String setNewPassword = '/setNewPassword';

  // static const String continueAsGuest = '/continueAsGuest';

  // static const String buySellStep1Photos = '/buySellStep1Photos';
  // static const String buySellStep2Details = '/buySellStep2Details';
  // static const String buySellStep3Location = '/buySellStep3Location';
  // static const String buySellStep4Contact = '/buySellStep4Contact';
  // static const String buySellStep5Review = '/buySellStep5Review';
  // static const String buySellDetails = '/buySellDetails';
  // static const String buySellSuccess = '/buySellSuccess';

  // static const String businessStep1Photos = '/businessStep1Photos';
  // static const String businessStep2Info = '/businessStep2Info';
  // static const String businessHoursSetter = '/businessHoursSetter';
  // static const String businessStep3Gallery = '/businessStep3Gallery';
  // static const String businessStep4Location = '/businessStep4Location';
  // static const String businessStep5Contact = '/businessStep5Contact';
  // static const String businessStep6Review = '/businessStep6Review';
  // static const String businessDetails = '/businessDetails';
  // static const String businessSuccess = '/businessSuccess';

  // static const String jobStep1Photos = '/jobStep1Photos';
  // static const String jobStep2Info = '/jobStep2Info';
  // static const String jobStep3Location = '/jobStep3Location';
  // static const String jobStep4Contact = '/jobStep4Contact';
  // static const String jobStep5Review = '/jobStep5Review';
  // static const String jobDetails = '/jobDetails';
  // static const String jobSuccess = '/jobSuccess';

  // static const String serviceStep1Photos = '/serviceStep1Photos';
  // static const String serviceStep2Info = '/serviceStep2Info';
  // static const String serviceStep3Location = '/serviceStep3Location';
  // static const String serviceStep4Contact = '/serviceStep4Contact';
  // static const String serviceStep5Review = '/serviceStep5Review';
  // static const String serviceDetails = '/serviceDetails';
  // static const String serviceSuccess = '/serviceSuccess';
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
                widget: NavigationMenu(),
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
                  builder: (context) =>
                      ContactInfoScreen(name: name, avatarUrl: avatarUrl),
                );
        }
      case Routes.forgetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ForgetPassword(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const ForgetPassword());

      case Routes.settingScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SettingScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const SettingScreen());

      case Routes.accountCenterScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const AccountCenterScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const AccountCenterScreen(),
              );

      case Routes.myWalletScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const MyWalletScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const MyWalletScreen());

      case Routes.blockedUsersScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const BlockedUsersScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const BlockedUsersScreen(),
              );

      case Routes.blockedUserDetailScreen:
        {
          final args = settings.arguments as Map<String, dynamic>?;
          final name = args?['name'] as String? ?? 'Frances Swann';
          final avatarUrl = args?['avatarUrl'] as String? ?? '';
          return Platform.isAndroid
              ? _FadedTransitionRoute(
                  widget: BlockedUserDetailScreen(
                    name: name,
                    avatarUrl: avatarUrl,
                  ),
                  settings: settings,
                )
              : CupertinoPageRoute(
                  builder: (context) =>
                      BlockedUserDetailScreen(name: name, avatarUrl: avatarUrl),
                );
        }

      case Routes.changePasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ChangePasswordScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              );

      case Routes.helpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const HelpScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const HelpScreen());

      case Routes.termsScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const TermsScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const TermsScreen());

      case Routes.privacyPolicyScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const PrivacyPolicyScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const PrivacyPolicyScreen(),
              );

      case Routes.forgetPasswordVerifyOtpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ForgetPasswordOtpVerifyScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const ForgetPasswordOtpVerifyScreen(),
              );

      case Routes.setNewPassword:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SetNewPasswordScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const SetNewPasswordScreen(),
              );

      case Routes.successScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SuccessScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const SuccessScreen());

      case Routes.signUpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SignUpScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(builder: (context) => const SignUpScreen());

      case Routes.signUpVerifyOtpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const SignUpVerifyOtpScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const SignUpVerifyOtpScreen(),
              );

      case Routes.profileSetupScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const ProfileSetupScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const ProfileSetupScreen(),
              );

      case Routes.editProfileScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const EditProfileScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const EditProfileScreen(),
              );

      case Routes.dashboardScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
                widget: const DashboardScreen(),
                settings: settings,
              )
            : CupertinoPageRoute(
                builder: (context) => const DashboardScreen(),
              );

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
