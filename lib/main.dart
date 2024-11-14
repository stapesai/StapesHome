// Path: lib/main.dart
// Description: This file contains the main entry point of the application.

import 'package:stapes_home/core/router/app_router.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:stapes_home/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:stapes_home/core/network/websocket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Setup GetIt service locator
  setupServiceLocator();

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(UserSessionModelAdapter());

  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class CustomGradientAndPaddingContainer extends StatelessWidget {
  final Widget child;

  const CustomGradientAndPaddingContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Experinted - We can't directly wrap the MaterialApp with this Container because it will cause the app to rebuiid when page is rebuit after any event.
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: AppPadding.pagePadding(context),
      decoration: ShapeDecoration(
        gradient: AppColor.backgroundColorgradient,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradientAndPaddingContainer(
      child: MaterialApp.router(
        routerConfig: AppRouter().route,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ),
    );

    // return FutureBuilder<SessionsModel?>(
    //   future: HiveService().getSessionData().then((sessions) => sessions.isNotEmpty ? sessions.first : null),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       final session = snapshot.data;
    //       final webSocketService = session != null
    //           ? WebSocketService(WebSocketRoutes.getWebSocketUrl(), session.userId, session.sessionId)
    //           : null;

    //       if (webSocketService != null) {
    //         webSocketService.connect();
    //       }

    // return Provider<WebSocketService?>.value(
    //   value: webSocketService,
    //   child: MaterialApp.router(
    //     routeInformationParser: AppRouter.returnRouter().routeInformationParser,
    //     routerDelegate: AppRouter.returnRouter().routerDelegate,
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       splashColor: Colors.transparent,
    //       highlightColor: Colors.transparent,
    //     ),
    //   ),
    // );
    // }
    // return CircularProgressIndicator();
    // },
    // );
  }
}
