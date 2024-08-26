import 'package:flutter/material.dart';
import 'package:jarvis/utils/hive.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/screens/routes/devices.dart';
import 'package:jarvis/screens/routes/home.dart';
import 'package:jarvis/screens/routes/nodes.dart';
import 'package:jarvis/screens/routes/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // (home page)
  final HiveService hiveService = HiveService();
  String sessionId = '';
  String userId = '';

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    var sessions = await hiveService.getSessionData();
    if (sessions.isNotEmpty) {
      var session = sessions.first;
      setState(() {
        sessionId = session.sessionId;
        userId = session.userId;
        _screens = [
          HomeScreen(sessionId: sessionId, userId: userId),
          DeviceScreen(sessionId: sessionId, userId: userId),
          const NodesScreen(),
          const ProfileScreen(),
        ];
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
    if (_screens.isEmpty) {
      return Container(
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: _screens[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Ink(
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  _buildBottomNavigationBarItem(
                    icon: Icons.add_home_work_rounded,
                    label: 'Home',
                    isActive: _selectedIndex == 0,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: Icons.lightbulb_outline_rounded,
                    label: 'Devices',
                    isActive: _selectedIndex == 1,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: Icons.memory_outlined,
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
          ),
        ));
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
          Icon(
            icon,
            size: 43,
          ),
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
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
