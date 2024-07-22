import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/Constants/colors.dart';


class ProvisioningScreen extends StatefulWidget {
  const ProvisioningScreen({super.key});

  @override
  createState() => ProvisioningScreenState();
}

class ProvisioningScreenState extends State<ProvisioningScreen> {
  @override
  void initState() {
    super.initState();
    _checkProvisioningStatus();
  }

  Future<void> _checkProvisioningStatus() async {
    // Check if the device is provisioned
    // If provisioned, redirect to the login screen
    // If not provisioned, redirect to the provisioning screen
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/cube.json',
              width: 400.0,
              height: 400.0,
            ),
          ]
        ),
      ),
    );
  }
}