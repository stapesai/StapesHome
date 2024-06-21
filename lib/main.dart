import 'package:flutter/material.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/SignIn/LoginSignIn.dart'; // Import the LoginScreen
import 'screens/Navigation/HomeScreen.dart';
import 'screens/Navigation/DevicesScreen.dart'; // Make sure this import matches the file name
import 'screens/Navigation/NodesScreen.dart';
import 'screens/Navigation/ProfileScreen.dart';

void main() {
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

  static final List<Widget> _screens = <Widget>[
    HomeScreen(),
    DeviceScreen(), // Ensure this matches the class name
    NodesScreen(),
    ProfileScreen(),
  ];

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
          color: Colors
              .black, // Set the background color of the BottomNavigationBar
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -3), // changes position of shadow to the top
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
          backgroundColor: Colors
              .transparent, // Make the background color transparent to see the container's background color
          unselectedItemColor:
              Colors.white, // Set unselected item color to white
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
