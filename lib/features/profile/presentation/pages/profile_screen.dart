// // lib/features/profile/presentation/pages/profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/features/profile/domain/usecases/get_user_profile.dart';
// import 'package:stapes_home/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:stapes_home/features/profile/presentation/bloc/profile_event.dart';
// import 'package:stapes_home/features/profile/presentation/bloc/profile_state.dart';


// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return LogoutConfirmationDialog();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProfileBloc(
//         getUserProfile: context.read<GetUserProfile>(),
//         updateUserProfile: context.read<UpdateUserProfile>(),
//         logoutUser: context.read<LogoutUser>(),
//       )..add(LoadUserProfile()),
//       child: Containaer(
//         decoration: const BoxDecoration(
//           gradient: AppColor.backgroundColorgradient,
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: SafeArea(
//             child: BlocConsumer<ProfileBloc, ProfileState>(
//               listener: (context, state) {
//                 if (state is ProfileError) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.message)),
//                   );
//                 } else if (state is LogoutSuccess) {
//                   // Navigate to login screen
//                   Navigator.pushReplacementNamed(context, '/login');
//                 }
//               },
//               builder: (context, state) {
//                 if (state is ProfileLoading || state is ProfileInitial) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (state is ProfileLoaded) {
//                   final profile = state.profile;
//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 50,
//                             backgroundImage: profile.avatarUrl.isNotEmpty
//                                 ? NetworkImage(profile.avatarUrl)
//                                 : const AssetImage('assets/icons/temp/demo.png')
//                                     as ImageProvider,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             '${profile.firstName} ${profile.lastName}',
//                             style: const TextStyle(
//                               color: AppColor.whiteColor,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             profile.email,
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       EditProfileScreen(profile: profile),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 side: const BorderSide(
//                                   color: AppColor.primaryColor,
//                                   width: 2,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 32,
//                                 vertical: 12,
//                               ),
//                             ),
//                             child: const Text(
//                               'Edit',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           _ProfileOption(
//                             icon: Icons.computer,
//                             text: 'Your sessions',
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const SessionsScreen(),
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 16),
//                           _ProfileOption(
//                             icon: Icons.logout,
//                             text: 'Logout',
//                             onTap: () {
//                               _showLogoutDialog(context);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ProfileOption extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final VoidCallback? onTap;

//   const _ProfileOption({
//     required this.icon,
//     required this.text,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         decoration: BoxDecoration(
//           color: const Color(0xFF11111A),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColor.whiteColor, size: 40),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(
//                   color: AppColor.whiteColor,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//             const Icon(
//               Icons.arrow_forward_ios,
//               color: AppColor.whiteColor,
//               size: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }