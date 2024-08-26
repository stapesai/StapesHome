import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161622),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161622),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Sessions',
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Where you\'re signed in',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            SessionItem(
              deviceIcon: Icons.phone_iphone,
              deviceName: 'iPhone 14 Pro Max',
              lastActive: '14 June',
            ),
            SessionItem(
              deviceIcon: Icons.phone_iphone,
              deviceName: 'Jason\'s iPhone 14',
              lastActive: '4:20pm',
            ),
            SessionItem(
              deviceIcon: Icons.android,
              deviceName: 'Marvin\'s Samsung A52',
              lastActive: '8:17pm',
            ),
          ],
        ),
      ),
    );
  }
}

class SessionItem extends StatelessWidget {
  final IconData deviceIcon;
  final String deviceName;
  final String lastActive;

  const SessionItem({
    super.key,
    required this.deviceIcon,
    required this.deviceName,
    required this.lastActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(deviceIcon, color: Colors.white),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Last active at $lastActive',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.logout, color: Colors.orange),
        ],
      ),
    );
  }
}
