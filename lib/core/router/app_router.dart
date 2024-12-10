import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/features/auth/presentation/pages/forgot_password_otp_verification.dart';
import 'package:stapes_home/features/auth/presentation/pages/login_email_input.dart';
import 'package:stapes_home/features/auth/presentation/pages/forgot_password_reset_password.dart';
import 'package:stapes_home/features/auth/presentation/pages/forgot_password_email_input.dart';
import 'package:stapes_home/features/auth/presentation/pages/login_otp_verification.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_create_new_password.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_details_form.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_email_input.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_otp_verification.dart';
import 'package:stapes_home/features/floors/presentation/widgets/create_floor_widget.dart';
import 'package:stapes_home/features/floors/presentation/widgets/edit_floor_widget.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/pages/iot_provisioning.dart';
import 'package:stapes_home/features/navigation/presentation/pages/navigation_screen.dart';
import 'package:stapes_home/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/create_room_widget.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/edit_room_widget.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';
import 'package:stapes_home/features/scanner/presentation/pages/qr_scanner.dart';
import 'package:stapes_home/features/tv_provisioning/presentation/pages/tv_provisioning.dart';

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
          builder: (context, state) => const ForgotPasswordEmailInputScreen()),

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

      // Main Page - Navigation Screen
      GoRoute(
        name: AppRouteConstants.main.routeName,
        path: AppRouteConstants.main.routePath,
        builder: (context, state) => const NavigationScreen(),
      ),

      // Create Floor Page
      // GoRoute(
      //   name: AppRouteConstants.createFloorPage.routeName,
      //   path: AppRouteConstants.createFloorPage.routePath,
      //   builder: (context, state) => const CreateFloorPage(),
      // ),

      // Create Room Page
      // GoRoute(
      //   name: AppRouteConstants.createRoomPage.routeName,
      //   path: AppRouteConstants.createRoomPage.routePath,
      //   pageBuilder: (context, state) {
      //     final String floorId = state.pathParameters['floorId']!;
      //     return MaterialPage(
      //       child: CreateRoomPage(
      //         floorId: floorId,
      //       ),
      //     );
      //   },
      // ),

      // Create Floor Widget
      GoRoute(
          name: AppRouteConstants.createFloorWidget.routeName,
          path: AppRouteConstants.createFloorWidget.routePath,
          builder: (context, state) => const CreateFloorWidget()),

      // Create Room Widget
      GoRoute(
        name: AppRouteConstants.createRoomWidget.routeName,
        path: AppRouteConstants.createRoomWidget.routePath,
        pageBuilder: (context, state) {
          final String floorId = state.pathParameters['floorId']!;
          return MaterialPage(
            child: CreateRoomWidget(
              floorId: floorId,
            ),
          );
        },
      ),

      // Edit Floor Widget
      GoRoute(
        name: AppRouteConstants.editFloorWidget.routeName,
        path: AppRouteConstants.editFloorWidget.routePath,
        pageBuilder: (context, state) {
          final FloorModel floor = state.extra! as FloorModel;
          return MaterialPage(
            child: EditFloorWidget(
              floor: floor,
            ),
          );
        },
      ),

      // Edit Room Widget
      GoRoute(
        name: AppRouteConstants.editRoomWidget.routeName,
        path: AppRouteConstants.editRoomWidget.routePath,
        pageBuilder: (context, state) {
          final RoomModel room = state.extra! as RoomModel;
          return MaterialPage(
            child: EditRoomWidget(
              room: room,
            ),
          );
        },
      ),

      // QR Scanner Screen
      GoRoute(
        name: AppRouteConstants.qrScanner.routeName,
        path: AppRouteConstants.qrScanner.routePath,
        builder: (context, state) => const QrScannerScreen(),
      ),

      // IoT Provisioning Screens
      // GoRoute(
      //   name: AppRouteConstants.iotProvisioning.routeName,
      //   path: AppRouteConstants.iotProvisioning.routePath,
      //   builder: (context, state) => IotProvisioningScreen(
      //     qrData: state.extra as IotQrModel,
      //   ),
      // ),

      // TV Provisioning Screen
      // GoRoute(
      //   name: AppRouteConstants.tvProvisioning.routeName,
      //   path: AppRouteConstants.tvProvisioning.routePath,
      //   builder: (context, state) => const TvProvisioningScreen(),
      // ),

      // Development Page
      //   GoRoute(
      //     name: AppRouteConstants.devPageUserDetailsShow.routeName,
      //     path: AppRouteConstants.devPageUserDetailsShow.routePath,
      //     builder: (context, state) => const DevUserDetailsScreen(),
      //   ),

      // Dev Test Page (just shows given text)
      //   GoRoute(
      //     name: AppRouteConstants.devPageTest.routeName,
      //     path: AppRouteConstants.devPageTest.routePath,
      //     pageBuilder: (context, state) {
      //       return MaterialPage(
      //         child: DevTestPage(
      //           text: state.pathParameters['text']!,
      //         ),
      //       );
      //     },
      //   ),
      // Dev Test page (Floor Room Selector)
      //   GoRoute(
      //     path: AppRouteConstants.devFloorRoomSelectorWidget.routePath,
      //     name: AppRouteConstants.devFloorRoomSelectorWidget.routeName,
      //     builder: (context, state) => const DevFloorRoomSelPage(),
      //   ),
    ],
  );
}
