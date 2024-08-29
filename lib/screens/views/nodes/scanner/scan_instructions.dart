import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';

class ScanInstructions extends StatelessWidget {
  const ScanInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
        final fontSize = isTablet ? 22.0 : 18.0;

        return DraggableScrollableSheet(
          initialChildSize: 0.15,
          minChildSize: 0.15,
          maxChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.instructionPanelColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Instructions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: fontSize + 4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      _buildInstructionStep(
                        '1. Scan the QR code on the device.',
                        fontSize,
                      ),
                      _buildInstructionStep(
                        '2. Enter Wi-Fi credentials.',
                        fontSize,
                      ),
                      _buildInstructionStep(
                        '3. Enter device name and correct node number.',
                        fontSize,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInstructionStep(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}
