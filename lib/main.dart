// Dart and Flutter imports
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

// Local imports

import 'package:jarvis/utils/sessions_model.dart';

import 'package:jarvis/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Register Hive adapters
  Hive.registerAdapter(SessionsModelAdapter());
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
    );
  }
}
