import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jarvis/Constants/colors.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'Cache/sessions_model.dart';
import 'Cache/HiveService.dart';
import 'screens/SplashScreen.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final HiveService hiveService = HiveService();
  String sessionId = '';
  String userId = '';

  static final List<Widget> _screens = <Widget>[
    const HomeScreen(sessionId: '', userId: ''), // Placeholder values
    const DeviceScreen(
        sessionId: '', userId: ''), // Ensure this matches the class name
    const NodesScreen(),
    const ProfileScreen(),
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
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
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
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            _buildBottomNavigationBarItem(
              icon: Icons.home,
              label: 'Home',
              isActive: _selectedIndex == 0,
            ),
            _buildBottomNavigationBarItem(
              icon: Icons.lightbulb_outline,
              label: 'Devices',
              isActive: _selectedIndex == 1,
            ),
            _buildBottomNavigationBarItem(
              icon: Icons.memory,
              label: 'Nodes',
              isActive: _selectedIndex == 2,
            ),
            _buildBottomNavigationBarItem(
              icon: Icons.settings,
              label: 'Settings',
              isActive: _selectedIndex == 3,
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

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          AnimatedBar(isActive: isActive),
          Icon(icon),
        ],
      ),
      label: label,
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 50 : 0,
      decoration: const BoxDecoration(
        color: AppColor.iconBarColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
