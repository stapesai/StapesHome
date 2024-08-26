import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import
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
          body: const Center(
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
            decoration: const BoxDecoration(
              color: Colors.transparent,
              // Removed the blur effect
            ),
            child: Ink(
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  _buildBottomNavigationBarItem(
                    activeIcon: 'assets/icons/navbar/home-active.svg',
                    inactiveIcon: 'assets/icons/navbar/home.svg',
                    label: 'Home',
                    isActive: _selectedIndex == 0,
                  ),
                  _buildBottomNavigationBarItem(
                    activeIcon: 'assets/icons/navbar/devices-active.svg',
                    inactiveIcon: 'assets/icons/navbar/devices.svg',
                    label: 'Devices',
                    isActive: _selectedIndex == 1,
                  ),
                  _buildBottomNavigationBarItem(
                    activeIcon: 'assets/icons/navbar/nodes-active.svg',
                    inactiveIcon: 'assets/icons/navbar/nodes.svg',
                    label: 'Nodes',
                    isActive: _selectedIndex == 2,
                  ),
                  _buildBottomNavigationBarItem(
                    activeIcon: 'assets/icons/navbar/profile-active.svg',
                    inactiveIcon: 'assets/icons/navbar/profile.svg',
                    label: 'Settings',
                    isActive: _selectedIndex == 3,
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                backgroundColor: Colors.transparent,
                unselectedItemColor: AppColor.whiteColor,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ));
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String activeIcon,
    required String inactiveIcon,
    required String label,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          // line above the selected icon
          // if (isActive)
          //   SvgPicture.asset(
          //     'assets/icons/navbar/line.svg',
          //     height: 4,
          //     width: 10,
          //   ),
          SvgPicture.asset(
            isActive ? activeIcon : inactiveIcon,
            height: 43,
            width: 43,
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
