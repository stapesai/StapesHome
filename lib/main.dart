import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/firebase_options.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:device_preview/device_preview.dart';
import 'package:stapes_home/core/router/app_router.dart';
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:stapes_home/core/theme/custom_gradient_and_padding_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: CustomGradientAndPaddingContainer(
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
      ),
    );
  }

}
