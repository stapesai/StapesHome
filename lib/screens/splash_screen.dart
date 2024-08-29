import 'dart:async';
import 'package:StapesHome/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:StapesHome/screens/routes/main.dart';
import 'package:StapesHome/utils/sessions_model.dart';
import 'package:StapesHome/screens/authentication/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Hive.openBox<SessionsModel>('SessionBox');
    var sessionBox = Hive.box<SessionsModel>('SessionBox');
    bool isLoggedIn = sessionBox.isNotEmpty;

    if (isLoggedIn) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // this is the splash screen, it will show the logo of the app until it is ready to show the login screen or the main screen (home screen)
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColor.backgroundColorgradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/logo.svg',
              width: 120.0,
              height: 120.0,
            ),
          ],
        ),
      ),
    );
  }
}
