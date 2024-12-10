// File: lib/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_state.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/skeletons/floor_room_name_skel.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/delete_room_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';
import 'package:stapes_home/service_locator.dart';

enum ItemType { floor, room }

class FloorRoomSelector extends StatelessWidget {
  final BuildContext context;
  final Function(String) onFloorSelected;
  final Function(String) onRoomSelected;
  final String sessionId;
  final String userId;

  const FloorRoomSelector({
    super.key,
    required this.context,
    required this.onFloorSelected,
    required this.onRoomSelected,
    required this.sessionId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FloorRoomSelBloc(
        deleteFloorUseCase: serviceLocator<DeleteFloorUseCase>(),
        deleteRoomUseCase: serviceLocator<DeleteRoomUseCase>(),
        getFloorsUseCase: serviceLocator<GetFloorsUseCase>(),
        getRoomsUseCase: serviceLocator<GetRoomsUseCase>(),
      )..add(LoadFloors()),
      child: _FloorRoomSelectorView(
        onFloorSelected: onFloorSelected,
        onRoomSelected: onRoomSelected,
      ),
    );
  }
}

class _FloorRoomSelectorView extends StatelessWidget {
  final Function(String) onFloorSelected;
  final Function(String) onRoomSelected;

  const _FloorRoomSelectorView({
    required this.onFloorSelected,
    required this.onRoomSelected,
  });

  void _showDeleteConfirmationDialog(BuildContext context, ItemType itemType, String id, String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $itemType'),
          content: Text('Are you sure you want to delete $itemName?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                if (itemType == ItemType.floor) {
                  context.read<FloorRoomSelBloc>().add(DeleteFloor(floorId: id));
                } else if (itemType == ItemType.room) {
                  context.read<FloorRoomSelBloc>().add(DeleteRoom(roomId: id));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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
            if (title == 'Floors') {
              // context.read<FloorRoomSelBloc>().add(const CreateFloor(name: 'New Floor'));
            } else {
              // context.read<FloorRoomSelBloc>().add(const CreateRoom(name: 'New Room'));
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FloorRoomSelBloc, FloorRoomSelState>(
      listener: (context, state) {
        if (state is FloorRoomSelLoaded) {
          onFloorSelected(state.activeFloorId);
          onRoomSelected(state.activeRoomId);
        }
      },
      builder: (context, state) {
        if (state is FloorRoomSelLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, 'Floors'),
                  const SizedBox(height: 8),
                  _buildFloorList(context, state, constraints.maxWidth),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'Rooms'),
                  const SizedBox(height: 8),
                  _buildRoomList(context, state, constraints.maxWidth),
                ],
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showFloorOptions(BuildContext context, Floor floor) {
    List<HoldBottomSheet> options = [
      HoldBottomSheet(
        icon: Icons.edit,
        text: 'Edit Floor',
        onTap: () => context.read<FloorRoomSelBloc>().add(UpdateFloor(
              floorId: floor.id,
              name: floor.alias,
            )),
      ),
      HoldBottomSheet(
        icon: Icons.delete,
        text: 'Delete Floor',
        onTap: () => _showDeleteConfirmationDialog(context, 'Floor', floor.id, floor.alias),
      ),
    ];

    showCustomBottomSheet(context, options);
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
              onTap: () => context.read<FloorRoomSelBloc>().add(SelectFloor(floorId: floor.id)),
              onLongPress: () => _showFloorOptions(context, floor),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showRoomOptions(BuildContext context, Room room) {
    List<HoldBottomSheet> options = [
      HoldBottomSheet(
        icon: Icons.edit,
        text: 'Edit Room',
        onTap: () => context.read<FloorRoomSelBloc>().add(UpdateRoom(
              roomId: room.id,
              name: room.name,
            )),
      ),
      HoldBottomSheet(
        icon: Icons.delete,
        text: 'Delete Room',
        onTap: () => _showDeleteConfirmationDialog(context, 'Room', room.id, room.name),
      ),
    ];

    showCustomBottomSheet(context, options);
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
              onTap: () => context.read<FloorRoomSelBloc>().add(SelectRoom(roomId: room.id)),
              onLongPress: () => _showRoomOptions(context, room),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(12),
        child: Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF3E3E62),
          ),
          child: const Icon(Icons.add, color: AppColor.whiteColor, size: 14),
        ),
      ),
    );
  }
}

class FloorRoomNameButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FloorRoomNameButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColor.whiteColor : AppColor.whiteColor50,
              fontSize: 16,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isActive)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.whiteColor,
              ),
            ),
        ],
      ),
    );
  }
}
