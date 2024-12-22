// // ...existing code...
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stapes_home/features/sessions/presentation/bloc/sessions_bloc.dart';
// import 'package:stapes_home/features/sessions/presentation/bloc/sessions_event.dart';
// import 'package:stapes_home/features/sessions/presentation/bloc/sessions_state.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';

// class SessionsPage extends StatefulWidget {
//   const SessionsPage({super.key});

//   @override
//   State<SessionsPage> createState() => _SessionsPageState();
// }

// class _SessionsPageState extends State<SessionsPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Provide actual user/session details
//     context.read<SessionsBloc>().add(LoadSessionsEvent("user123", "currentSession123"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF161622),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF161622),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.orange),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: BlocBuilder<SessionsBloc, SessionsState>(
//         builder: (context, state) {
//           if (state is SessionsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is SessionsError) {
//             return Center(
//               child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.white)),
//             );
//           } else if (state is SessionsLoaded) {
//             final sessions = state.sessions;
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Your Sessions',
//                     style: TextStyle(color: AppColor.whiteColor, fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Where you\'re signed in',
//                     style: TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: sessions.length,
//                       itemBuilder: (context, index) {
//                         final session = sessions[index];
//                         return SessionItem(
//                           sessionId: session.sessionId,
//                           userId: session.userId,
//                           lastActive: session.lastActiveAt.toString(),
//                           onLogoutTap: () {
//                             context.read<SessionsBloc>().add(
//                               RevokeSessionEvent("user123", session.sessionId),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else if (state is SessionsRevokeSuccess) {
//             context.read<SessionsBloc>().add(LoadSessionsEvent("user123", "currentSession123"));
//             return const Center(
//               child: Text('Session Revoked', style: TextStyle(color: Colors.white)),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

// class SessionItem extends StatelessWidget {
//   final String sessionId;
//   final String userId;
//   final String lastActive;
//   final VoidCallback onLogoutTap;

//   const SessionItem({
//     super.key,
//     required this.sessionId,
//     required this.userId,
//     required this.lastActive,
//     required this.onLogoutTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2C2C2C),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               'Session: $sessionId\nUser: $userId\nLast Active: $lastActive',
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.orange),
//             onPressed: onLogoutTap,
//           ),
//         ],
//       ),
//     );
//   }
// }