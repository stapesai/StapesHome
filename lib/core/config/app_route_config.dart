// Path: lib/core/config/app_route_config.dart
// Description: This file contains the GoRouter for the application. We'll use this to navigate between screens.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/presentation/auth/pages/create_password.dart';
import 'package:stapes_home/presentation/auth/pages/forgot_password_email_input.dart';
import 'package:stapes_home/presentation/auth/pages/login.dart';
import 'package:stapes_home/presentation/splash/pages/splash_screen.dart';
import 'package:stapes_home/presentation/auth/pages/otp_verification.dart';

class AppRouter {
  GoRouter route = GoRouter(
    routes: [
      // Splash screen
      GoRoute(
          name: AppRouteConstants.splash.routeName,
          path: AppRouteConstants.splash.routePath,
          pageBuilder: (context, state) {
            return MaterialPage(child: const SplashScreen());
          }),

      // Login screen
      GoRoute(
          name: AppRouteConstants.login.routeName,
          path: AppRouteConstants.login.routePath,
          pageBuilder: (context, state) {
            return MaterialPage(child: const LoginScreen());
          }),

      // Otp verification screen
      GoRoute(
          name: AppRouteConstants.otpVerification.routeName,
          path: AppRouteConstants.otpVerification.routePath,
          pageBuilder: (context, state) {
            final VoidCallback onSuccess = state.extra as VoidCallback;
            return MaterialPage(
                child: OtpVerificationScreen(
              transactionId: state.pathParameters['transactionId']!,
              expiryTime: DateTime.parse(state.pathParameters['expiryTime']!),
              onSuccess: onSuccess,
            ));
          }),

      // Forgot password screen
      GoRoute(
          name: AppRouteConstants.forgotPassword.routeName,
          path: AppRouteConstants.forgotPassword.routePath,
          pageBuilder: (context, state) {
            return MaterialPage(child: const ForgotPassword());
          }),

      // Create password screen
      GoRoute(
          name: AppRouteConstants.createPassword.routeName,
          path: AppRouteConstants.createPassword.routePath,
          pageBuilder: (context, state) {
            final Widget nextScreen = state.extra as Widget;
            return MaterialPage(
              child: CreatePasswordScreen(
                title: state.pathParameters['title']!,
                subtitle: state.pathParameters['subtitle']!,
                email: state.pathParameters['email']!,
                transactionId: state.pathParameters['transactionId']!,
                nextScreen: nextScreen,
              ),
            );
          }),

      // Development Page
      GoRoute(
          name: AppRouteConstants.devPage.routeName,
          path: AppRouteConstants.devPage.routePath,
          pageBuilder: (context, state) {
            return MaterialPage(
              child: Text('Development Page'),
            );
          }),
    ],
  );
}
