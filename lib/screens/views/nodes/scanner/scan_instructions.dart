import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class SimpleInstructionPanel extends StatelessWidget {
  const SimpleInstructionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final fontSize = isTablet ? 22.0 : 18.0;

    return DraggableScrollableSheet(
      initialChildSize: 0.10,
      minChildSize: 0.10,
      maxChildSize: 0.4,
      snap: true,
      snapSizes: const [0.10, 0.4],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColor.instructionPanelColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Instructions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.primaryColor, // Replace with AppColor.primaryColor
                  fontSize: fontSize + 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildInstructionStep('1. Scan the QR code on the device.', fontSize),
              _buildInstructionStep('2. Enter Wi-Fi credentials.', fontSize),
              _buildInstructionStep('3. Enter device name and correct node number.', fontSize),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionStep(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(color: AppColor.whiteColor, fontSize: fontSize),
      ),
    );
  }
}
