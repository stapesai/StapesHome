import 'package:StapesHome/core/api/api_routes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:StapesHome/utils/sessions_model.dart';
import 'package:StapesHome/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:StapesHome/services/websocket_service.dart';
import 'package:StapesHome/utils/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive 
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
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
    return FutureBuilder<SessionsModel?>(
      future: HiveService().getSessionData().then((sessions) => sessions.isNotEmpty ? sessions.first : null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final session = snapshot.data;
          final webSocketService = session != null
              ? WebSocketService(WebsocketRoutes.getWebsocketUrl(), session.userId, session.sessionId)
              : null;

          if (webSocketService != null) {
            webSocketService.connect();
          }

          return Provider<WebSocketService?>.value(
            value: webSocketService,
            child: MaterialApp(
              home: const SplashScreen(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}