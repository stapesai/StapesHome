import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart'; // Ensure the correct import path
import 'package:StapesHome/screens/views/profile/edit_profile.dart'; // Ensure the correct import path
import 'package:StapesHome/screens/views/profile/logout_dialog.dart';
import 'package:StapesHome/screens/views/profile/sessions_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: AppColor.backgroundColorgradient,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/icons/temp/demo.png'), // Replace with actual image asset
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'john@email.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.orange, width: 2)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ProfileOption(
                    icon: Icons.dark_mode_outlined,
                    text: 'Dark mode',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileOption(
                    icon: Icons.computer,
                    text: 'Your sessions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SessionsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ProfileOption(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  ProfileOption(
                    icon: Icons.location_history,
                    text: 'About Us',
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  ProfileOption(
                    icon: Icons.help,
                    text: 'Get Help',
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LogoutConfirmationDialog();
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
    super.key,
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
          color: const Color(0xFF11111A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColor.whiteColor,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: const TextStyle(color: AppColor.whiteColor, fontSize: 20, fontFamily: 'Malgun Gothic'),
                ),
              ],
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios, color: AppColor.whiteColor, size: 16),
          ],
        ),
      ),
    );
  }
}
