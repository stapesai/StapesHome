// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:stapes_home/core/common/widgets/button.dart';
// import 'package:stapes_home/core/common/widgets/input/textfield.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/core/theme/app_font_sizes.dart';
// import 'package:stapes_home/features/rooms/domain/usecases/create_room_usecase.dart';
// import 'package:stapes_home/features/rooms/presentation/bloc/create_room_bloc.dart';
// import 'package:stapes_home/features/rooms/presentation/bloc/create_room_event.dart';
// import 'package:stapes_home/features/rooms/presentation/bloc/create_room_state.dart';
// import 'package:stapes_home/service_locator.dart';

// class CreateRoomPage extends StatefulWidget {
//   final String floorId;
//   const CreateRoomPage({super.key, required this.floorId});

//   @override
//   createState() => _CreateRoomPageState();
// }

// class _CreateRoomPageState extends State<CreateRoomPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController typeController = TextEditingController();

//   static const _pageTitle = Text(
//     'Create a new room',
//     style: TextStyle(
//       color: AppColor.whiteColor,
//       fontSize: AppFontSizes.pageHeading,
//       fontFamily: 'Ubuntu',
//       fontWeight: FontWeight.w700,
//     ),
//   );

//   static const _pageSubtitle = Text(
//     'Enter the details for creating a new room.',
//     style: TextStyle(
//       color: AppColor.whiteColor,
//       fontSize: AppFontSizes.pageSubHeading,
//       fontFamily: 'Ubuntu',
//       fontWeight: FontWeight.w400,
//     ),
//   );

//   @override
//   void dispose() {
//     nameController.dispose();
//     typeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

//     return BlocProvider(
//       create: (context) => CreateRoomBloc(
//         createRoomUseCase: serviceLocator<CreateRoomUseCase>(),
//       ),
//       child: BlocListener<CreateRoomBloc, CreateRoomState>(
//         listener: (context, state) {
//           if (state is CreateRoomError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: AppColor.errorColor,
//                 content: Text(state.message),
//               ),
//             );
//           } else if (state is CreateRoomSuccess) {
//             Navigator.pop(context);
//           }
//         },
//         child: KeyboardDismissOnTap(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             resizeToAvoidBottomInset: true,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               title: const Text('Create a new room',
//                   style: TextStyle(color: AppColor.whiteColor), textAlign: TextAlign.right),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: AppColor.whiteColor),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//             body: SafeArea(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: screenSize.height * 0.05),
//                   _pageTitle,
//                   SizedBox(height: screenSize.height * 0.02),
//                   _pageSubtitle,
//                   SizedBox(height: screenSize.height * 0.04),
//                   CustomTextField(
//                     hintText: 'Room Name',
//                     controller: nameController,
//                   ),
//                   SizedBox(height: screenSize.height * 0.02),
//                   CustomTextField(
//                     hintText: 'Room Type',
//                     controller: typeController,
//                   ),
//                   const Spacer(),
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeOut,
//                     margin: EdgeInsets.only(
//                       bottom: keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.02 : screenSize.height * 0.1,
//                     ),
//                     child: Center(
//                       child: BlocBuilder<CreateRoomBloc, CreateRoomState>(
//                         builder: (context, state) {
//                           return CustomButton(
//                             text: 'Create',
//                             isLoading: state is CreateRoomLoading,
//                             onPressed: () {
//                               context.read<CreateRoomBloc>().add(
//                                     CreateRoomSubmitted(
//                                       floorId: widget.floorId,
//                                       name: nameController.text,
//                                       type: typeController.text,
//                                     ),
//                                   );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
