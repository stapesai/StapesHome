import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
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
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Implement logout functionality here
          },
          child: const Text('Yes, Log me out',
              style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }
}
