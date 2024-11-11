// Path: lib/core/config/app_route_config.dart
// Description: This file contains the GoRouter for the application. We'll use this to navigate between screens.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/presentation/auth/pages/login.dart';
import 'package:stapes_home/presentation/splash/pages/splash_screen.dart';

class AppRouter {
  GoRouter route = GoRouter(
    routes: [
      // Splash screen
      GoRoute(
          name: AppRouteConstants.splash.routeName,
          path: AppRouteConstants.splash.routePath,
          pageBuilder: (context, state) {
            return MaterialPage(child: SplashScreen());
          }),

      // Login screen
      GoRoute(
          name: AppRouteConstants.login.routeName,
          path: AppRouteConstants.login.routePath,
          pageBuilder: (context, state) {
            return MaterialPage(child: LoginScreen());
          }),
    ],
  );
}
