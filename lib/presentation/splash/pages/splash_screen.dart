// Path: lib/presentation/splash/pages/splash_screen.dart
// Description: This file contains the splash screen for the application. This screen will show the logo of the app until it is ready to show the login screen or the main screen (home screen).

import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:stapes_home/utils/sessions_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Hive.openBox<SessionsModel>('SessionBox');
    var sessionBox = Hive.box<SessionsModel>('SessionBox');
    bool isLoggedIn = sessionBox.isNotEmpty;

    if (isLoggedIn) {
      if (mounted) {
        // GoRouter.of(context).go(AppRouteConstants.home.routePath);
        throw UnimplementedError('GoRouter is not implemented for home page');
      }
    } else {
      if (mounted) {
        GoRouter.of(context).go(AppRouteConstants.login.routePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // this is the splash screen, it will show the logo of the app until it is ready to show the login screen or the main screen (home screen)
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColor.backgroundColorgradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/logo.svg',
              width: 110.0,
              height: 110.0,
            ),
          ],
        ),
      ),
    );
  }
}
