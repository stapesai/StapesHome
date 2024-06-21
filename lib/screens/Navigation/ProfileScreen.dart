import 'package:flutter/material.dart';
import 'package:jarvis/screens/Additional/EditProfile.dart'; // Ensure the correct import path
import 'package:jarvis/screens/Additional/SessionsScreen.dart';
import 'package:jarvis/screens/Additional/LogoutConfirmationDialog.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Adjust this color to match your theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/profile_picture.png'), // Replace with actual image asset
              ),
              SizedBox(height: 16),
              Text(
                'John Doe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'john@email.com',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 32),
              ProfileOption(
                icon: Icons.dark_mode,
                text: 'Dark mode',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Colors.orange,
                ),
              ),
              SizedBox(height: 16),
              ProfileOption(
                icon: Icons.computer,
                text: 'Your sessions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SessionsScreen()),
                  );
                },
              ),
              SizedBox(height: 16),
              ProfileOption(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutConfirmationDialog();
      },
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileOption({
    required this.icon,
    required this.text,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            trailing ??
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
