import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:StapesHome/constants/colors.dart';

class ProvisioningScreen extends StatefulWidget {
  final String deviceName;
  final String serviceUuid;
  final String characteristicUuid;

  const ProvisioningScreen({
    Key? key,
    required this.deviceName,
    required this.serviceUuid,
    required this.characteristicUuid,
  }) : super(key: key);

  @override
  createState() => ProvisioningScreenState();
}

class ProvisioningStep {
  final String title;
  bool isCompleted;
  bool isCurrent;

  ProvisioningStep({required this.title, this.isCompleted = false, this.isCurrent = false});
}

class ProvisioningScreenState extends State<ProvisioningScreen> {
  List<ProvisioningStep> steps = [
    ProvisioningStep(title: 'Pairing bluetooth', isCurrent: true),
    ProvisioningStep(title: 'Sending Wi-Fi credentials'),
    ProvisioningStep(title: 'Checking provisioning status'),
  ];

  int currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _startProvisioning();
  }

  Future<void> _startProvisioning() async {
    await _pairBluetooth();
    await _sendWifiCredentials();
    await _checkProvisioningStatus();
  }

  Future<void> _pairBluetooth() async {
    setState(() {
      currentStepIndex = 0;
      steps[0].isCurrent = true;
    });
    // Simulate Bluetooth pairing
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      steps[0].isCompleted = true;
      steps[0].isCurrent = false;
    });
  }

  Future<void> _sendWifiCredentials() async {
    setState(() {
      currentStepIndex = 1;
      steps[1].isCurrent = true;
    });
    // Simulate sending Wi-Fi credentials
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      steps[1].isCompleted = true;
      steps[1].isCurrent = false;
    });
  }

  Future<void> _checkProvisioningStatus() async {
    setState(() {
      currentStepIndex = 2;
      steps[2].isCurrent = true;
    });
    // Simulate checking provisioning status
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      steps[2].isCompleted = true;
      steps[2].isCurrent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF353841), Color(0xFF141414)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 90),
              Text(
                'Provisioning Node',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 58),
              Container(
                width: 122.69,
                height: 132.19,
                child: Lottie.asset(
                  'assets/loties/cube.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 32),
              ...steps.map((step) => _buildStepIndicator(step)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ProvisioningStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step.isCompleted
                  ? Color(0xFFFF9F1C)
                  : step.isCurrent
                      ? Color(0xFFFF9F1C)
                      : Color(0x7FFF9F1C),
            ),
            child: step.isCompleted
                ? Icon(Icons.check, color: Colors.white)
                : step.isCurrent
                    ? CircularProgressIndicator(color: Colors.white)
                    : null,
          ),
          SizedBox(width: 10),
          Text(
            step.title,
            style: TextStyle(
              color: step.isCompleted || step.isCurrent ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 20,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}