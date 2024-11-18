import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/core/theme/custom_gradient_and_padding_container.dart';
import 'package:stapes_home/service_locator.dart';

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

  // Initialize SQLite database
  try {
    final sqliteService = serviceLocator<SQLiteService>();
    await sqliteService.initializeDatabase();
  } catch (e) {
    debugPrint('Failed to initialize database: $e');
    rethrow;
  }
  // debugPaintSizeEnabled = true;
  // runApp(const MyApp());
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradientAndPaddingContainer(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        // showPerformanceOverlay: true,

        // DevicePreview
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,

        // App Router
        routerConfig: AppRouter().route,

        // Theme
        themeMode: ThemeMode.dark,
        // theme: ThemeData(
        //   splashColor: Colors.transparent,
        //   highlightColor: Colors.transparent,
        // ),
      ),
    );

    // return FutureBuilder<SessionsModel?>(
    //   future: HiveService().getSessionData().then((sessions) => sessions.isNotEmpty ? sessions.first : null),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       final session = snapshot.data;
    //       final webSocketService = session != null
    //           ? WebsocketService(WebsocketRoutes.getWebsocketUrl(), session.userId, session.sessionId)
    //           : null;

    //       if (webSocketService != null) {
    //         webSocketService.connect();
    //       }

    // return Provider<WebsocketService?>.value(
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
