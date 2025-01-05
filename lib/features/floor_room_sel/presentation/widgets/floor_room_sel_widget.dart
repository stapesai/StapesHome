// File: lib/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/common/presentation/widgets/hold_bottom_sheet_widget.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor/floor_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor/floor_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor/floor_state.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/room/room_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/room/room_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/room/room_state.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/skeletons/floor_room_name_skel.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_name_button.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/plus_button.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/floors/presentation/widgets/create_floor_widget.dart';
import 'package:stapes_home/features/floors/presentation/widgets/delete_floor_widget.dart';
import 'package:stapes_home/features/floors/presentation/widgets/edit_floor_widget.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/create_room_widget.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/delete_room_widget.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/edit_room_widget.dart';
import 'package:stapes_home/service_locator.dart';

class FloorRoomSelector extends StatelessWidget {
  final Function(String) onFloorSelected;
  final Function(String) onRoomSelected;

  const FloorRoomSelector({
    super.key,
    required this.onFloorSelected,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RoomBloc(
            getRoomsUseCase: serviceLocator<GetRoomsUseCase>(),
            onRoomSelected: onRoomSelected,
          ),
        ),
        BlocProvider(
          create: (context) => FloorBloc(
            getFloorsUseCase: serviceLocator<GetFloorsUseCase>(),
            onFloorSelected: (floorId) {
              onFloorSelected(floorId);
              context.read<RoomBloc>().add(LoadRooms(floorId));
            },
          )..add(LoadFloors()),
        ),
      ],
      child: const FloorRoomSelectorContent(),
    );
  }
}

class FloorRoomSelectorContent extends StatelessWidget {
  const FloorRoomSelectorContent({super.key});

  Widget _buildFloorSectionHeader(BuildContext context) {
    return Row(
      children: [
         Text(
          'Floors',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.whiteColor,
            fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(width: 30),
        PlusButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const CreateFloorWidget(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFloorList(BuildContext context, FloorState state) {
    if (state.isLoading) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 15),
              child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
            ),
          ),
        ),
      );
    }

    if (state.error != null) {
      // Show snackbar with error message
      // CustomSnackbar(context, state.error!, type: SnackbarType.error);

      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: AppColor.errorColor),
        ),
        // child: Text(
        //   'Failed to load floors',
        //   style: const TextStyle(color: AppColor.errorColor),
        // ),
      );
    }

    if (state.floors.isEmpty) {
      return Center(
        child: Text(
          'No floors available',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 16.sp,
            fontFamily: 'Ubuntu',
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: state.floors.map((floor) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FloorRoomNameButton(
              label: floor.name,
              isActive: state.activeFloorId == floor.id,
              onTap: () {
                context.read<FloorBloc>().add(SelectFloor(floor.id!));
              },
              onLongPress: () => _showFloorOptions(context, floor),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFloorOptions(BuildContext context, FloorModel floor) {
    List<BottomSheetOption> options = [
      BottomSheetOption(
        icon: Icons.edit,
        label: 'Edit Floor',
        onTap: () => {
          showDialog(
            context: context,
            builder: (_) => EditFloorWidget(floor: floor),
          ),
        },
      ),
      BottomSheetOption(
          icon: Icons.delete,
          label: 'Delete Floor',
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => DeleteFloorWidget(floor: floor),
            );
          }),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HoldBottomSheetWidget(options: options),
    );
  }

  Widget _buildRoomSectionHeader(BuildContext context) {
    return Row(
      children: [
         Text(
          'Rooms',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.whiteColor,
            fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(width: 30),
        PlusButton(
          onPressed: () {
            final floorState = context.read<FloorBloc>().state;
            if (floorState.activeFloorId != null) {
              showDialog(
                context: context,
                builder: (_) => CreateRoomWidget(floorId: floorState.activeFloorId!),
              );
            } else {
              CustomSnackbar(context, 'Please select a floor first', type: SnackbarType.error);
            }
          },
        ),
      ],
    );
  }

  Widget _buildRoomList(BuildContext context, RoomState state) {
    if (state.isLoading) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 15),
              child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
            ),
          ),
        ),
      );
    }

    if (state.error != null) {
      // Show snackbar with error message
      // CustomSnackbar(context, state.error!, type: SnackbarType.error);

      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: AppColor.errorColor),
        ),
        // child: Text(
        //   'Failed to load rooms',
        //   style: const TextStyle(color: AppColor.errorColor),
        // ),
      );
    }

    if (state.rooms.isEmpty) {
      return Center(
        child: Text(
          'No rooms available',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 16.sp,
            fontFamily: 'Ubuntu',
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: state.rooms.map((room) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FloorRoomNameButton(
              label: room.name,
              isActive: state.activeRoomId == room.id,
              onTap: () {
                context.read<RoomBloc>().add(SelectRoom(room.id!));
              },
              onLongPress: () => _showRoomOptions(context, room),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showRoomOptions(BuildContext context, RoomModel room) {
    List<BottomSheetOption> options = [
      BottomSheetOption(
        icon: Icons.edit,
        label: 'Edit Room',
        onTap: () => {
          showDialog(
            context: context,
            builder: (_) => EditRoomWidget(room: room),
          ),
        },
      ),
      BottomSheetOption(
          icon: Icons.delete,
          label: 'Delete Room',
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => DeleteRoomWidget(room: room),
            );
          }),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HoldBottomSheetWidget(options: options),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<FloorBloc, FloorState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFloorSectionHeader(context),
                const SizedBox(height: 8),
                _buildFloorList(context, state),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRoomSectionHeader(context),
                const SizedBox(height: 8),
                _buildRoomList(context, state),
              ],
            );
          },
        ),
      ],
    );
  }

  // Implement _buildSectionHeader, _buildFloorList, and _buildRoomList methods
  // similar to the original widget but using the new bloc states
}

// class FloorRoomSelector extends StatefulWidget {
//   final Function(String) onFloorSelected;
//   final Function(String) onRoomSelected;

//   const FloorRoomSelector({
//     super.key,
//     required this.onFloorSelected,
//     required this.onRoomSelected,
//   });

//   @override
//   State<FloorRoomSelector> createState() => _FloorRoomSelectorState();
// }

// class _FloorRoomSelectorState extends State<FloorRoomSelector> {
//   Widget _buildSectionHeader(BuildContext context, ItemType itemType, FloorRoomSelState state) {
//     String title = itemType == ItemType.floor ? 'Floors' : 'Rooms';
//     return Row(
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: AppColor.whiteColor,
//             fontFamily: 'Ubuntu',
//           ),
//         ),
//         const SizedBox(width: 30),
//         PlusButton(
//           onPressed: () {
//             if (itemType == ItemType.floor) {
//               // Show create floor dialog
//               showDialog(
//                 context: context,
//                 builder: (_) => const CreateFloorWidget(),
//               );
//             } else if (itemType == ItemType.room) {
//               if (state is FloorsLoaded) {
//                 // Show create room dialog
//                 showDialog(
//                   context: context,
//                   builder: (_) => CreateRoomWidget(floorId: state.activeFloorId),
//                 );
//               } else {
//                 CustomSnackbar(context, 'Please select a floor first', type: SnackbarType.error);
//               }
//             }
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildFloorList(BuildContext context, FloorRoomSelState state, double maxWidth) {
//     if (state is FloorsLoading) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: List.generate(
//             4,
//             (index) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
//             ),
//           ),
//         ),
//       );
//     }

//     if (state is FloorsLoaded) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: state.floors.map((floor) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 15),
//               child: FloorRoomNameButton(
//                 label: floor.alias,
//                 isActive: state.activeFloorId == floor.id,
//                 onTap: () {
//                   context.read<FloorRoomSelBloc>().add(SelectFloor(floorId: floor.id!));
//                 },
//                 onLongPress: () => _showFloorOptions(context, floor),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     }

//     if (state is FloorsLoadedEmpty) {
//       return const Center(
//         child: Text(
//           'No floors available',
//           style: TextStyle(
//             color: AppColor.whiteColor,
//             fontSize: 16,
//             fontFamily: 'Ubuntu',
//           ),
//         ),
//       );
//     }

//     return const SizedBox.shrink();
//   }

//   void _showFloorOptions(BuildContext context, FloorModel floor) {
//     List<BottomSheetOption> options = [
//       BottomSheetOption(
//         icon: Icons.edit,
//         label: 'Edit Floor',
//         onTap: () => {
//           showDialog(
//             context: context,
//             builder: (_) => EditFloorWidget(floor: floor),
//           ),
//         },
//       ),
//       BottomSheetOption(
//           icon: Icons.delete,
//           label: 'Delete Floor',
//           onTap: () {
//             showDialog(
//               context: context,
//               builder: (_) => DeleteFloorWidget(floor: floor),
//             );
//           }),
//     ];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => HoldBottomSheetWidget(options: options),
//     );
//   }

//   Widget _buildRoomList(BuildContext context, FloorRoomSelState state, double maxWidth) {
//     if (state is RoomsLoading) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: List.generate(
//             4,
//             (index) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
//             ),
//           ),
//         ),
//       );
//     }

//     if (state is RoomsLoaded) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: state.rooms.map((room) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 15),
//               child: FloorRoomNameButton(
//                 label: room.name,
//                 isActive: state.activeRoomId == room.id,
//                 onTap: () {
//                   context.read<FloorRoomSelBloc>().add(SelectRoom(roomId: room.id!));
//                 },
//                 onLongPress: () => _showRoomOptions(context, room),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     }

//     if (state is RoomsLoadedEmpty) {
//       return const Center(
//         child: Text(
//           'No rooms available',
//           style: TextStyle(
//             color: AppColor.whiteColor,
//             fontSize: 16,
//             fontFamily: 'Ubuntu',
//           ),
//         ),
//       );
//     }

//     return const SizedBox.shrink();
//   }

//   void _showRoomOptions(BuildContext context, RoomModel room) {
//     List<BottomSheetOption> options = [
//       BottomSheetOption(
//         icon: Icons.edit,
//         label: 'Edit Room',
//         onTap: () => {
//           showDialog(
//             context: context,
//             builder: (_) => EditRoomWidget(room: room),
//           ),
//         },
//       ),
//       BottomSheetOption(
//           icon: Icons.delete,
//           label: 'Delete Room',
//           onTap: () {
//             showDialog(
//               context: context,
//               builder: (_) => DeleteRoomWidget(room: room),
//             );
//           }),
//     ];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => HoldBottomSheetWidget(options: options),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => FloorRoomSelBloc(
//         getFloorsUseCase: serviceLocator<GetFloorsUseCase>(),
//         getRoomsUseCase: serviceLocator<GetRoomsUseCase>(),
//         onFloorSelected: (floorId) => widget.onFloorSelected(floorId),
//         onRoomSelected: (roomId) => widget.onRoomSelected(roomId),
//       )..add(LoadFloors()),
//       child: BlocBuilder<FloorRoomSelBloc, FloorRoomSelState>(
//         builder: (context, state) {
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionHeader(context, ItemType.floor, state),
//                   const SizedBox(height: 8),
//                   _buildFloorList(context, state, constraints.maxWidth),
//                   const SizedBox(height: 24),
//                   _buildSectionHeader(context, ItemType.room, state),
//                   const SizedBox(height: 8),
//                   _buildRoomList(context, state, constraints.maxWidth),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
