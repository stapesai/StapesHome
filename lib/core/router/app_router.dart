import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/features/auth/presentation/pages/forgot_password_otp_verification.dart';
import 'package:stapes_home/features/auth/presentation/pages/login_email_input.dart';
import 'package:stapes_home/features/auth/presentation/pages/forgot_password_reset_password.dart';
import 'package:stapes_home/features/auth/presentation/pages/forgot_password_email_input.dart';
import 'package:stapes_home/features/auth/presentation/pages/login_otp_verification.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_create_new_password.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_details_form.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_email_input.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_otp_verification.dart';
import 'package:stapes_home/features/dev/dev_test_page.dart';
import 'package:stapes_home/features/dev/dev_user_details_show.dart';
import 'package:stapes_home/features/navigation/presentation/pages/navigation_screen.dart';
import 'package:stapes_home/features/onboarding/presentation/pages/splash_screen.dart';

class AppRouter {
  GoRouter route = GoRouter(
    initialLocation: AppRouteConstants.splash.routePath,
    routes: [
      // Splash screen
      GoRoute(
        name: AppRouteConstants.splash.routeName,
        path: AppRouteConstants.splash.routePath,
        builder: (context, state) => const SplashScreen(),
      ),

      // Login screen
      GoRoute(
        name: AppRouteConstants.login.routeName,
        path: AppRouteConstants.login.routePath,
        builder: (context, state) => const LoginEmailInputScreen(),
      ),

      // Login OTP Verification screen
      GoRoute(
        name: AppRouteConstants.loginOtpVerification.routeName,
        path: AppRouteConstants.loginOtpVerification.routePath,
        pageBuilder: (context, state) {
          final String email = state.pathParameters['email']!;
          final String transactionId = state.pathParameters['transactionId']!;
          final DateTime expiryTime = DateTime.parse(state.pathParameters['expiryTime']!);
          return MaterialPage(
            child: LoginOtpVerificationScreen(
              email: email,
              transactionId: transactionId,
              expiryTime: expiryTime,
            ),
          );
        },
      ),

      // SignUp Email Input screen
      GoRoute(
        name: AppRouteConstants.signUpEmailInput.routeName,
        path: AppRouteConstants.signUpEmailInput.routePath,
        builder: (context, state) => const SignUpEmailInputScreen(),
      ),

      // SignUp OTP Verification screen
      GoRoute(
        name: AppRouteConstants.signUpOtpVerification.routeName,
        path: AppRouteConstants.signUpOtpVerification.routePath,
        pageBuilder: (context, state) {
          final String transactionId = state.pathParameters['transactionId']!;
          final DateTime expiryTime = DateTime.parse(state.pathParameters['expiryTime']!);
          final String email = state.pathParameters['email']!;
          return MaterialPage(
            child: SignUpOtpVerificationScreen(
              transactionId: transactionId,
              expiryTime: expiryTime,
              email: email,
            ),
          );
        },
      ),

      // SignUp Create Password screen
      GoRoute(
        name: AppRouteConstants.signUpCreatePassword.routeName,
        path: AppRouteConstants.signUpCreatePassword.routePath,
        pageBuilder: (context, state) {
          final String transactionId = state.pathParameters['transactionId']!;
          final String email = state.pathParameters['email']!;
          return MaterialPage(
            child: SignUpCreateNewPasswordScreen(
              transactionId: transactionId,
              email: email,
            ),
          );
        },
      ),

      // SignUp Details Form screen
      GoRoute(
        name: AppRouteConstants.signUpDetailsForm.routeName,
        path: AppRouteConstants.signUpDetailsForm.routePath,
        pageBuilder: (context, state) {
          final String transactionId = state.pathParameters['transactionId']!;
          final String email = state.pathParameters['email']!;
          final String password = state.pathParameters['password']!;
          return MaterialPage(
            child: SignUpDetailsFormScreen(
              transactionId: transactionId,
              email: email,
              password: password,
            ),
          );
        },
      ),

      // Forgot password screen
      GoRoute(
          name: AppRouteConstants.forgotPassword.routeName,
          path: AppRouteConstants.forgotPassword.routePath,
          pageBuilder: (context, state) {
            return MaterialPage(child: const ForgotPasswordEmailInputScreen());
          }),

      // Forgot Password OTP Verification screen
      GoRoute(
        name: AppRouteConstants.forgotPasswordOtpVerification.routeName,
        path: AppRouteConstants.forgotPasswordOtpVerification.routePath,
        pageBuilder: (context, state) {
          final String email = state.pathParameters['email']!;
          final String transactionId = state.pathParameters['transactionId']!;
          final DateTime expiryTime = DateTime.parse(state.pathParameters['expiryTime']!);
          return MaterialPage(
            child: ForgotPasswordOtpVerificationScreen(
              email: email,
              transactionId: transactionId,
              expiryTime: expiryTime,
            ),
          );
        },
      ),

      // Forgot Password Reset Password screen
      GoRoute(
        name: AppRouteConstants.forgotPasswordResetPassword.routeName,
        path: AppRouteConstants.forgotPasswordResetPassword.routePath,
        pageBuilder: (context, state) {
          final String email = state.pathParameters['email']!;
          final String transactionId = state.pathParameters['transactionId']!;
          return MaterialPage(
            child: ForgotPasswordResetPasswordScreen(
              email: email,
              transactionId: transactionId,
            ),
          );
        },
      ),

      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     return NavigationScreen(
      //       navigationShell: navigationShell,
      //     );
      //   },
      //   branches: [
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: AppRouteConstants.home.routePath,
      //           builder: (context, state) => const DevUserDetailsScreen(),
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: AppRouteConstants.devices.routePath,
      //           builder: (context, state) => const DevTestPage(text: 'Devices Page'),
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: AppRouteConstants.nodes.routePath,
      //           builder: (context, state) => const DevTestPage(text: 'Nodes Page'),
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       routes: [
      //         GoRoute(
      //           path: AppRouteConstants.settings.routePath,
      //           builder: (context, state) => const DevTestPage(text: 'Settings Page'),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),

      // Main Page Route - Temporary
      GoRoute(
        name: AppRouteConstants.main.routeName,
        path: AppRouteConstants.main.routePath,
        builder: (context, state) => const NavigationScreen(),
      ),

      // Development Page
      GoRoute(
        name: AppRouteConstants.devPageUserDetailsShow.routeName,
        path: AppRouteConstants.devPageUserDetailsShow.routePath,
        builder: (context, state) => const DevUserDetailsScreen(),
      ),

      // Dev Test Page (just shows given text)
      GoRoute(
        name: AppRouteConstants.devPageTest.routeName,
        path: AppRouteConstants.devPageTest.routePath,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: DevTestPage(
              text: state.pathParameters['text']!,
            ),
          );
        },
      ),
    ],
  );
}
