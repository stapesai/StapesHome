import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'Cache/sessions_model.dart';
import 'Cache/HiveService.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/SignIn/LoginSignIn.dart';
import 'screens/Navigation/HomeScreen.dart';
import 'screens/Navigation/DevicesScreen.dart';
import 'screens/Navigation/NodesScreen.dart';
import 'screens/Navigation/ProfileScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Register Hive adapters
  Hive.registerAdapter(SessionsModelAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final HiveService hiveService = HiveService();
  String sessionId = '';
  String userId = '';

  static List<Widget> _screens = <Widget>[
    const HomeScreen(sessionId: '', userId: ''), // Placeholder values
    DeviceScreen(
        sessionId: '', userId: ''), // Ensure this matches the class name
    NodesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    var sessions = await hiveService.getBoxes<SessionsModel>("SessionBox");
    if (sessions.isNotEmpty) {
      var session = sessions.first;
      setState(() {
        sessionId = session.sessionId;
        userId = session.userId;
        _screens[0] = HomeScreen(sessionId: sessionId, userId: userId);
        _screens[1] = DeviceScreen(sessionId: sessionId, userId: userId);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              label: 'Devices',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.memory),
              label: 'Nodes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
