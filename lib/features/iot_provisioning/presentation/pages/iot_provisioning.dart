// lib/features/iot_provisioning/presentation/pages/iot_provisioning.dart

import 'package:flutter/material.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';

class IotProvisioningScreen extends StatelessWidget {
  final IotQrModel deviceData;

  const IotProvisioningScreen({
    super.key,
    required this.deviceData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'IoT Device Provisioning\nThis feature will be implemented soon.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
