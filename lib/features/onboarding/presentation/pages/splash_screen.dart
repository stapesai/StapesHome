import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/service_locator.dart';

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
    UserModel? userBox = await serviceLocator<AuthLocalDataSource>().getUser();
    UserSessionModel? sessionBox = await serviceLocator<AuthLocalDataSource>().getUserSession();

    bool isLoggedIn = sessionBox != null && userBox != null;

    if (mounted) {
      if (isLoggedIn) {
        GoRouter.of(context).go(AppRouteConstants.main.routePath);
      } else {
        GoRouter.of(context).go(AppRouteConstants.login.routePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // this is the splash screen, it will show the logo of the app until it is ready to show the login screen or the main screen (home screen)
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/logo.svg',
          width: 110.0,
          height: 110.0,
        ),
      ],
    );
  }
}
