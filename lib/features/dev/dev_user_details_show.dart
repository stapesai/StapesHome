import 'dart:ui';

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
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, {bool hasError = false}) {
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
              color: Colors.white,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: hasError ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: hasError ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: hasError ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Developer Details',
          style: TextStyle(color: Colors.white),
        ),
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

          bool hasError = snapshot.hasError || snapshot.data == null;
          final userData = snapshot.data;
          final UserModel? user = userData?['user'];
          final UserSessionModel? session = userData?['session'];

          if (hasError) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('User Details', [_buildKeyValuePair('Error', '${snapshot.error}')], hasError: true),
                  const SizedBox(height: 16),
                  _buildSection('Session Details', [_buildKeyValuePair('Error', 'Session data unavailable')],
                      hasError: true),
                ],
              ),
            );
          }

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
