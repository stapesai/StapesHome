import 'package:flutter/material.dart';
import 'package:stapes_home/utils/hive.dart';
import 'package:stapes_home/screens/authentication/login.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import "package:stapes_home/widgets/button.dart";

// TODO: move to dialog.dart and then remove this file

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  Future<void> _logout(BuildContext context) async {
    final HiveService hiveService = HiveService();

    // Clear the SessionBox
    await hiveService.clearBox("SessionBox");

    // Optionally, close all boxes to ensure clean state
    await hiveService.closeAllBoxes();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 285,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 7.50,
              offset: Offset(0, 4),
              spreadRadius: 13,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm Logout?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 24,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Are you sure you want to logout \nfrom Jarvis",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  CustomButton(
                      text: "No, Take me back",
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(height: 10),
                  CustomButton(
                      text: "Yes,Log me out",
                      onPressed: () {
                        _logout(context);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
