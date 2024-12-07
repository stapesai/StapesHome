import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_state.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/floors/presentation/widgets/create_floor_widget.dart';
import 'package:stapes_home/features/rooms/domain/usecases/delete_room_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/create_room_widget.dart';
import 'package:stapes_home/features/floors/presentation/widgets/edit_floor_widget.dart';
import 'package:stapes_home/features/rooms/presentation/widgets/edit_room_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/hold_bottom_sheet_widget.dart';
import 'package:stapes_home/service_locator.dart';

class FloorRoomSelector extends StatelessWidget {
  final Function(String) onFloorSelected;
  final Function(String) onRoomSelected;

  const FloorRoomSelector({
    super.key,
    required this.onFloorSelected,
    required this.onRoomSelected,
  });

  Future<void> _showDeleteConfirmation(BuildContext context, String itemType, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $itemType'),
        content: Text('Are you sure you want to delete this $itemType?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FloorRoomSelBloc(
        deleteFloorUseCase: serviceLocator<DeleteFloorUseCase>(),
        deleteRoomUseCase: serviceLocator<DeleteRoomUseCase>(),
        getFloorsUseCase: serviceLocator<GetFloorsUseCase>(),
        getRoomsUseCase: serviceLocator<GetRoomsUseCase>(),
      )..add(LoadFloors()),
      child: BlocBuilder<FloorRoomSelBloc, FloorRoomSelState>(
        builder: (context, state) {
          if (state is FloorRoomSelLoading) {
            return const CircularProgressIndicator();
          } else if (state is FloorRoomSelLoaded) {
            return Column(
              children: [
                // Floors List
                Expanded(
                  child: ListView.builder(
                    itemCount: state.floors.length,
                    itemBuilder: (context, index) {
                      final floor = state.floors[index];
                      return GestureDetector(
                        onTap: () {
                          context.read<FloorRoomSelBloc>().add(SelectFloor(floorId: floor.id!));
                          onFloorSelected(floor.id!);
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => HoldBottomSheetWidget(
                              options: [
                                BottomSheetOption(
                                  label: 'Edit Floor',
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => EditFloorWidget(floor: floor),
                                    );
                                  },
                                ),
                                BottomSheetOption(
                                  label: 'Delete Floor',
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showDeleteConfirmation(
                                      context,
                                      'floor',
                                      () {
                                        context.read<FloorRoomSelBloc>().add(
                                              DeleteFloor(floorId: floor.id!),
                                            );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(floor.alias),
                        ),
                      );
                    },
                  ),
                ),
                // Add Floor Button
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const CreateFloorWidget(),
                    );
                  },
                ),
                // Rooms List
                Expanded(
                  child: ListView.builder(
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      final room = state.rooms[index];
                      return GestureDetector(
                        onTap: () {
                          context.read<FloorRoomSelBloc>().add(SelectRoom(roomId: room.id!));
                          onRoomSelected(room.id!);
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => HoldBottomSheetWidget(
                              options: [
                                BottomSheetOption(
                                  label: 'Edit Room',
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) => EditRoomWidget(room: room),
                                    );
                                  },
                                ),
                                BottomSheetOption(
                                  label: 'Delete Room',
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showDeleteConfirmation(
                                      context,
                                      'room',
                                      () {
                                        context.read<FloorRoomSelBloc>().add(
                                              DeleteRoom(roomId: room.id!),
                                            );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(room.name),
                        ),
                      );
                    },
                  ),
                ),
                // Add Room Button
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => CreateRoomWidget(floorId: state.activeFloorId),
                    );
                  },
                ),
              ],
            );
          } else if (state is FloorRoomSelError) {
            return Text('Error: ${state.message}');
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
