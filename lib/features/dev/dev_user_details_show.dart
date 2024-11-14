import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/service_locator.dart';

class DevUserDetailsScreen extends StatelessWidget {
  const DevUserDetailsScreen({super.key});

  Future<Map<String, dynamic>> _loadUserData() async {
    final userSession = await serviceLocator<AuthLocalDataSource>().getUserSession();
    final user = await serviceLocator<AuthLocalDataSource>().getUser();
    return {'session': userSession, 'user': user};
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Clear user session and data
      await serviceLocator<AuthLocalDataSource>().clearSession();

      // Navigate to login screen and remove all previous routes
      if (context.mounted) {
        GoRouter.of(context).go(
          AppRouteConstants.login.routePath,
        );
      }
    } catch (e) {
      // Show error if logout fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e', style: const TextStyle(color: AppColor.errorColor))),
        );
      }
    }
  }

  Widget _buildKeyValuePair(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              key,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildUserSection(UserModel? user) {
    if (user == null) return [_buildKeyValuePair('Status', 'Not logged in')];

    return [
      _buildKeyValuePair('Email', user.email),
      _buildKeyValuePair('First Name', user.firstName),
      _buildKeyValuePair('Last Name', user.lastName),
      _buildKeyValuePair('Date of Birth', user.dob),
      _buildKeyValuePair('Gender', user.gender),
    ];
  }

  List<Widget> _buildSessionSection(UserSessionModel? session) {
    if (session == null) return [_buildKeyValuePair('Status', 'No active session')];

    return [
      _buildKeyValuePair('Session ID', session.sessionId),
      _buildKeyValuePair('User ID', session.userId),
      _buildKeyValuePair('Created At', session.createdAt.toString()),
      _buildKeyValuePair('Last Active', session.lastActiveAt.toString()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Details'),
        actions: [
          TextButton(
            onPressed: () => _handleLogout(context),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data!;
          final UserModel? user = userData['user'];
          final UserSessionModel? session = userData['session'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('User Details', _buildUserSection(user)),
                const SizedBox(height: 16),
                _buildSection('Session Details', _buildSessionSection(session)),
              ],
            ),
          );
        },
      ),
    );
  }
}
