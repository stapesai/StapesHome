// import 'package:flutter/material.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/core/theme/app_font_sizes.dart';
// import 'package:stapes_home/core/theme/app_padding.dart';
// import 'package:stapes_home/features/common/presentation/widgets/floor_room_sel_widget.dart';
// import 'package:stapes_home/features/common/presentation/widgets/iot/light_widget.dart';
// import 'package:stapes_home/features/common/presentation/widgets/light_widget.dart';
// import 'package:stapes_home/core/models/device_model.dart';
// import 'package:stapes_home/core/error/failures.dart';
// import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
// import 'package:stapes_home/features/devices/domain/usecases/get_devices_by_room_id_usecase.dart';
// import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';
// import 'package:stapes_home/service_locator.dart';
// import 'package:dartz/dartz.dart';

// class DevicesPage extends StatefulWidget {
//   const DevicesPage({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _DevicesPageState createState() => _DevicesPageState();
// }

// class _DevicesPageState extends State<DevicesPage> {
//   String activeFloorId = '';
//   String activeRoomId = '';
//   List<DeviceModel> devices = [];
//   bool isLoading = false;
//   String? errorMessage;

//   final GetDevicesByRoomIdUseCase getDevicesByRoomIdUseCase = serviceLocator<GetDevicesByRoomIdUseCase>();

//   void handleFloorSelected(String floorId) {
//     setState(() {
//       activeFloorId = floorId;
//     });
//   }

//   void handleRoomSelected(String roomId) {
//     setState(() {
//       activeRoomId = roomId;
//       _fetchDevices(roomId);
//     });
//   }

//   Future<void> _fetchDevices(String roomId) async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     final result = await getDevicesByRoomIdUseCase(
//       GetDevicesByRoomIdParams(roomId: roomId),
//       refresh: true,
//     );

//     // result.fold(
//     //   (failure) {
//     //     setState(() {
//     //       errorMessage = _mapFailureToMessage(failure);
//     //       isLoading = false;
//     //     });
//     //   },
//     //   (response) {
//     //     setState(() {
//     //       devices = response.entities;
//     //       isLoading = false;
//     //     });
//     //   },
//     );
//   }

//   // String _mapFailureToMessage(Failure failure) {
//   //   // Customize error messages based on fai
//   //.
//   //failure type
//   //   if (failure is ServerFailure) {
//   //     return 'Server error occurred. Please try again later.';
//   //   } else if (failure is CacheFailure) {
//   //     return 'Failed to load data. Please check your connection.';
//   //   } else {
//   //     return 'An unexpected error occurred.';
//   //   }
//   // }

//   Future<void> _refreshData() async {
//     if (activeRoomId.isNotEmpty) {
//       await _fetchDevices(activeRoomId);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: AppColor.backgroundColorgradient,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: RefreshIndicator(
//             onRefresh: _refreshData,
//             color: AppColor.whiteColor,
//             backgroundColor: Colors.transparent,
//             child: SafeArea(
//               child: Padding(
//                 padding: AppPadding.pagePadding(context),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: screenSize.height * 0.05),
//                     Text(
//                       'All Devices',
//                       style: TextStyle(
//                         color: AppColor.whiteColor,
//                         fontSize: AppFontSizes.pageHeading,
//                         fontFamily: 'Ubuntu',
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(height: screenSize.height * 0.02),
//                     FloorRoomSelector(
//                       onFloorSelected: handleFloorSelected,
//                       onRoomSelected: handleRoomSelected,
//                     ),
//                     SizedBox(height: screenSize.height * 0.02),
//                     Expanded(
//                       child: isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : errorMessage != null
//                               ? Center(
//                                   child: Text(
//                                     errorMessage!,
//                                     style: TextStyle(
//                                       color: AppColor.whiteColor.withOpacity(0.8),
//                                       fontSize: AppFontSizes.bodyText,
//                                       fontFamily: 'Ubuntu',
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 )
//                               : devices.isEmpty
//                                   ? Center(
//                                       child: Text(
//                                         'Nothing to show here.\nAdd a new device to display here.',
//                                         style: TextStyle(
//                                           color: AppColor.whiteColor.withOpacity(0.8),
//                                           fontSize: AppFontSizes.bodyText,
//                                           fontFamily: 'Ubuntu',
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     )
//                                   : ListView.builder(
//                                       itemCount: devices.length,
//                                       itemBuilder: (context, index) {
//                                         final device = devices[index];
//                                         return LightComponentWidget(
//                                           device: device,
//                                           onToggle: () {
//                                             // Handle device toggle
//                                           },
//                                           isActivated: device.state == 'on',
//                                         );
//                                       },
//                                     ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }