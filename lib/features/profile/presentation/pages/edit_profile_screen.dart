// // lib/features/profile/presentation/pages/edit_profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/features/profile/domain/entities/user_profile.dart';
// import 'package:stapes_home/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:stapes_home/features/profile/presentation/bloc/profile_event.dart';

// class EditProfileScreen extends StatefulWidget {
//   final UserProfile profile;

//   const EditProfileScreen({Key? key, required this.profile}) : super(key: key);

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   // Controllers
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _dobController;
//   late TextEditingController _emailController;

//   // Date Picker
//   DateTime? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     final profile = widget.profile;
//     _firstNameController = TextEditingController(text: profile.firstName);
//     _lastNameController = TextEditingController(text: profile.lastName);
//     _emailController = TextEditingController(text: profile.email);
//     _dobController = TextEditingController(
//       text: "${profile.dateOfBirth.toLocal()}".split(' ')[0],
//     );
//     _selectedDate = profile.dateOfBirth;
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _dobController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       helpText: 'Select Date of Birth',
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dobController.text = "${picked.toLocal()}".split(' ')[0];
//       });
//     }
//   }

//   void _saveChanges() {
//     final updatedProfile = UserProfile(
//       firstName: _firstNameController.text,
//       lastName: _lastNameController.text,
//       email: _emailController.text,
//       dateOfBirth: _selectedDate ?? widget.profile.dateOfBirth,
//       avatarUrl: widget.profile.avatarUrl,
//     );
//     context.read<ProfileBloc>().add(UpdateUserProfileEvent(updatedProfile));
//     Navigator.pop(context); // Go back to the profile screen
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: AppColor.backgroundColorgradient,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: AppColor.primaryColor),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: const Text('Edit Profile'),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Avatar
//                 Center(
//                   child: Stack(
//                     alignment: Alignment.bottomRight,
//                     children: [
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundColor: const Color(0xFF28282F),
//                         child: Icon(
//                           Icons.person,
//                           size: 80,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.white,
//                           radius: 20,
//                           child: IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.black),
//                             onPressed: () {
//                               // Implement avatar change functionality
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 // Form Fields
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       _buildTextField(
//                         controller: _firstNameController,
//                         hintText: 'First Name',
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         controller: _lastNameController,
//                         hintText: 'Last Name',
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         controller: _dobController,
//                         hintText: 'Date of Birth',
//                         readOnly: true,
//                         onTap: () => _selectDate(context),
//                         suffixIcon: Icons.calendar_today,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         controller: _emailController,
//                         hintText: 'Email',
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Save Button
//                 ElevatedButton(
//                   onPressed: _saveChanges,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.primaryColor,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text(
//                     'Save Changes',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     IconData? suffixIcon,
//   }) {
//     return TextField(
//       controller: controller,
//       readOnly: readOnly,
//       onTap: onTap,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(color: Colors.white70),
//         filled: true,
//         fillColor: const Color(0xFF28282F),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         suffixIcon: suffixIcon != null
//             ? Icon(suffixIcon, color: Colors.white70)
//             : null,
//       ),
//     );
//   }
// }