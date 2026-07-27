
import 'package:flutter/material.dart';
import 'package:stevenako_flutter/helpers/helper_methods.dart';
import 'package:stevenako_flutter/navigation_menu.dart';
import 'package:stevenako_flutter/splash_screen.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  loadInitialData() async {
    _isLoading = true;
    await setInitValue();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    } else {
      return   NavigationMenu();
    }
    // else {
    //   bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
    //   if (isLoggedIn) {
    //     return const NavigationMenu();
    //   } else {
    //     return const LoginScreen();
    //   }
    // }
  }
}
