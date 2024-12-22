import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/sessions/domain/entities/sessions_entity.dart';
import 'package:stapes_home/features/sessions/presentation/bloc/sessions_bloc.dart';
import 'package:stapes_home/features/sessions/presentation/bloc/sessions_event.dart';
import 'package:stapes_home/features/sessions/presentation/bloc/sessions_state.dart';
import 'package:intl/intl.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() {
    context.read<SessionsBloc>().add(
          LoadSessionsEvent(
            userId: "user123",
            sessionId: "currentSession123",
          ),
        );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColor.backgroundColorgradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<SessionsBloc, SessionsState>(
          listener: (context, state) {
            if (state is SessionsError) {
              _showErrorSnackBar(state.message);
            }
          },
          builder: (context, state) {
            if (state is SessionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is SessionsLoaded) {
              return _SessionsList(sessions: state.sessions);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SessionsList extends StatelessWidget {
  final List<SessionEntity> sessions;

  const _SessionsList({required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(
        child: Text(
          'No active sessions',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Sessions',
            style: TextStyle(
              color: AppColor.whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Where you\'re signed in',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return SessionItem(session: session);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SessionItem extends StatelessWidget {
  final SessionEntity session;

  const SessionItem({
    super.key,
    required this.session,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onLongPress: () => _showRevokeDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.computer,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session ${session.sessionId.substring(0, 8)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last active: ${_formatDateTime(session.lastActiveAt)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.orange),
                  onPressed: () => _showRevokeDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRevokeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Revoke Session',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to end this session?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SessionsBloc>().add(
                    RevokeSessionEvent(
                      userId: session.userId,
                      sessionId: session.sessionId,
                    ),
                  );
            },
            child: const Text(
              'Revoke',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}