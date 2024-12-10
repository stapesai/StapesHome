// File: lib/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/common/presentation/widgets/hold_bottom_sheet_widget.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_state.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/skeletons/floor_room_name_skel.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_name_button.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/plus_button.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/floors/presentation/widgets/create_floor_widget.dart';
import 'package:stapes_home/features/floors/presentation/widgets/delete_floor_widget.dart';
import 'package:stapes_home/features/floors/presentation/widgets/edit_floor_widget.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/create_room_widget.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/edit_room_widget.dart';
import 'package:stapes_home/service_locator.dart';

enum ItemType { floor, room }

class FloorRoomSelector extends StatefulWidget {
  final Function(String) onFloorSelected;
  final Function(String) onRoomSelected;

  const FloorRoomSelector({
    super.key,
    required this.onFloorSelected,
    required this.onRoomSelected,
  });

  @override
  State<FloorRoomSelector> createState() => _FloorRoomSelectorState();
}

class _FloorRoomSelectorState extends State<FloorRoomSelector> {
  Widget _buildSectionHeader(BuildContext context, ItemType itemType) {
    String title = itemType == ItemType.floor ? 'Floors' : 'Rooms';
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColor.whiteColor,
            fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(width: 30),
        PlusButton(
          onPressed: () {
            if (itemType == ItemType.floor) {
              // Show create floor dialog
              showDialog(
                context: context,
                builder: (_) => const CreateFloorWidget(),
              );
            } else if (itemType == ItemType.room) {
              // Show create room dialog
              showDialog(
                context: context,
                builder: (_) => const CreateRoomWidget(floorId: '36c3116b-a9c6-4cfa-96c3-a2fed3135d25'),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildFloorList(BuildContext context, FloorRoomSelLoaded state, double maxWidth) {
    if (state.isLoadingFloors) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
            ),
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
              label: floor.alias,
              isActive: state.activeFloorId == floor.id,
              onTap: () => context.read<FloorRoomSelBloc>().add(SelectFloor(floorId: floor.id!)),
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
          EditFloorWidget(floor: floor),
          Navigator.of(context).pop(),
        },
      ),
      BottomSheetOption(
          icon: Icons.delete,
          label: 'Delete Floor',
          onTap: () {
            DeleteFloorWidget(floor: floor);
            Navigator.of(context).pop();
          }),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HoldBottomSheetWidget(options: options),
    );
  }

  Widget _buildRoomList(BuildContext context, FloorRoomSelLoaded state, double maxWidth) {
    if (state.isLoadingRooms) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
            ),
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
              onTap: () => context.read<FloorRoomSelBloc>().add(SelectRoom(roomId: room.id!)),
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
          EditRoomWidget(room: room),
          Navigator.of(context).pop(),
        },
      ),
      BottomSheetOption(
          icon: Icons.delete,
          label: 'Delete Room',
          onTap: () {
            // TODO: redirect to delete room widget
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
    return BlocProvider(
      create: (context) => FloorRoomSelBloc(
        getFloorsUseCase: serviceLocator<GetFloorsUseCase>(),
        getRoomsUseCase: serviceLocator<GetRoomsUseCase>(),
      )..add(LoadFloors()),
      child: BlocConsumer<FloorRoomSelBloc, FloorRoomSelState>(
        listener: (context, state) {
          if (state is FloorRoomSelLoaded) {
            widget.onFloorSelected(state.activeFloorId);
            widget.onRoomSelected(state.activeRoomId);
          }
        },
        builder: (context, state) {
          if (state is FloorRoomSelLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, ItemType.floor),
                    const SizedBox(height: 8),
                    _buildFloorList(context, state, constraints.maxWidth),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, ItemType.room),
                    const SizedBox(height: 8),
                    _buildRoomList(context, state, constraints.maxWidth),
                  ],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
