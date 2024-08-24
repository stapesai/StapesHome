import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class ProvisioningScreen extends StatefulWidget {
  const ProvisioningScreen({super.key});

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
    ProvisioningStep(title: 'Applying Wi-Fi connection'),
    ProvisioningStep(title: 'Checking provisioning status'),
  ];

  int currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _startProvisioning();
  }

  Future<void> _startProvisioning() async {
    // Here you can start the provisioning process
    // Here you can navigate to the next screen or perform any other action
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'Provisioning Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/icons/vector.png',
                  width: 200,
                  height: 200,
                ),
                Lottie.asset(
                  'assets/lottie/cube.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(height: 30),
            ...steps.map((step) => _buildStepIndicator(step)),
          ],
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
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step.isCompleted
                  ? Colors.orange
                  : step.isCurrent
                      ? Colors.orange
                      : Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          Text(
            step.title,
            style: TextStyle(
              color: step.isCompleted || step.isCurrent ? Colors.white : Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}