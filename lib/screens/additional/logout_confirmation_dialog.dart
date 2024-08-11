import 'package:flutter/material.dart';
import 'package:jarvis/cache/hive.dart';
import 'package:jarvis/cache/sessions_model.dart';
import 'package:jarvis/screens/authentication/login.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  Future<void> _logout(BuildContext context) async {
    final HiveService hiveService = HiveService();
    var sessions = await hiveService.getBoxes<SessionsModel>("SessionBox");

    sessions.clear();
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
    return AlertDialog(
      backgroundColor: const Color(0xFF161622),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title:
          const Text('Confirm Logout?', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Are you sure you want to logout from Jarvis?',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No, Take me back',
              style: TextStyle(color: Colors.orange)),
        ),
        TextButton(
          onPressed: () => _logout(context),
          child: const Text('Yes, Log me out',
              style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }
}
