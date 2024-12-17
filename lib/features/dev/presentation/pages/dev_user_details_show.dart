import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/service_locator.dart';

class DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool hasError;

  const DetailSection({
    super.key,
    required this.title,
    required this.children,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
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
        Container(
          decoration: BoxDecoration(
            color: hasError ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasError ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
            ),
          ),
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
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
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
}

class DevUserDetailsScreen extends StatefulWidget {
  const DevUserDetailsScreen({super.key});

  @override
  State<DevUserDetailsScreen> createState() => _DevUserDetailsScreenState();
}

class _DevUserDetailsScreenState extends State<DevUserDetailsScreen> {
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    print('DevUserDetailsScreen initState');
    super.initState();
    _userDataFuture = _loadUserData();
    // BlocProvider.of<WebsocketBloc>(context).add(GetWebsocketMessageHistory());
  }

  @override
  void dispose() {
    print('DevUserDetailsScreen dispose');
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    final userSession = await serviceLocator<AuthLocalDataSource>().getUserSession();
    final user = await serviceLocator<AuthLocalDataSource>().getUser();
    return {'session': userSession, 'user': user};
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await serviceLocator<AuthLocalDataSource>().clearSession();
      if (context.mounted) {
        GoRouter.of(context).go(AppRouteConstants.login.routePath);
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar(context, 'Error logging out', type: SnackbarType.error);
      }
    }
  }

  // Widget _buildWebsocketSection(WebsocketBloc websocketBloc) {
  //   return BlocListener<WebsocketBloc, WebsocketState>(
  //     bloc: websocketBloc,
  //     listener: (context, state) {
  //       DevWebsocketMessage? message;
  //       if (state is WebsocketDeviceStatusUpdateMessageState) {
  //         message = DevWebsocketMessage(type: WebsocketIncommingMessageType.deviceStatusUpdate, data: state.update);
  //       } else if (state is WebsocketNodeStatusUpdateMessageState) {
  //         message = DevWebsocketMessage(type: WebsocketIncommingMessageType.nodeStatusUpdate, data: state.update);
  //       } else if (state is WebsocketErrorMessageState) {
  //         message = DevWebsocketMessage(type: WebsocketIncommingMessageType.error, data: state.error);
  //       }

  //       if (message != null) {
  //         setState(() {
  //           _messages.insert(0, message!);
  //           _listKey.currentState?.insertItem(0);
  //         });
  //       }
  //     },
  //     child: _buildSection(
  //       'Websocket Service',
  //       [
  //         SizedBox(
  //           height: 500,
  //           child: AnimatedList(
  //             key: _listKey,
  //             reverse: false,
  //             initialItemCount: _messages.length,
  //             itemBuilder: (context, index, animation) {
  //               final message = _messages[index];
  //               switch (message.type) {
  //                 case WebsocketIncommingMessageType.deviceStatusUpdate:
  //                   return DeviceStatusUpdateWidget(data: message.data, animation: animation);
  //                 case WebsocketIncommingMessageType.nodeStatusUpdate:
  //                   return NodeStatusUpdateWidget(data: message.data, animation: animation);
  //                 case WebsocketIncommingMessageType.error:
  //                   return ErrorMessageWidget(data: message.data, animation: animation);
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // WebsocketBloc websocketBloc = context.read<WebsocketBloc>();
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
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          bool hasError = snapshot.hasError || snapshot.data == null;
          final userData = snapshot.data;
          final UserModel? user = userData?['user'];
          final UserSessionModel? session = userData?['session'];

          if (hasError) {
            return ListView(
              children: [
                DetailSection(
                  title: 'User Details',
                  hasError: true,
                  children: [
                    DetailRow(label: 'Error', value: '${snapshot.error}'),
                  ],
                ),
                const SizedBox(height: 16),
                DetailSection(
                  title: 'Session Details',
                  hasError: true,
                  children: const [
                    DetailRow(label: 'Error', value: 'Session data unavailable'),
                  ],
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DetailSection(
                title: 'User Details',
                children: [
                  DetailRow(label: 'Email', value: user?.email ?? ''),
                  DetailRow(label: 'First Name', value: user?.firstName ?? ''),
                  DetailRow(label: 'Last Name', value: user?.lastName ?? ''),
                  DetailRow(label: 'Date of Birth', value: user?.dob ?? ''),
                  DetailRow(label: 'Gender', value: user?.gender ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              DetailSection(
                title: 'Session Details',
                children: [
                  DetailRow(label: 'Session ID', value: session?.sessionId ?? ''),
                  DetailRow(label: 'User ID', value: session?.userId ?? ''),
                  DetailRow(label: 'Created At', value: session?.createdAt.toString() ?? ''),
                  DetailRow(label: 'Last Active', value: session?.lastActiveAt.toString() ?? ''),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
