// lib/features/dev/presentation/pages/dev_floor_room_sel.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_bloc.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_state.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/delete_room_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';

class DevFloorRoomSelPage extends StatelessWidget {
  const DevFloorRoomSelPage({Key? key}) : super(key: key);

  static final ValueNotifier<String> _debugInfo =
      ValueNotifier<String>('Debug Output:\n');

  void _updateDebugInfo(String message) {
    final timestamp = DateTime.now().toString().split(' ')[1].split('.')[0];
    _debugInfo.value = '${_debugInfo.value}[$timestamp] $message\n';
  }

  void _clearDebugInfo() {
    _debugInfo.value = 'Debug Output:\n';
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Floor Room Selector Test'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Debug Info Section
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: _debugInfo,
                      builder: (context, value, child) {
                        return Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Courier',
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Floor Room Selector
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: FloorRoomSelector(
                        onFloorSelected: (floorId) {
                          _updateDebugInfo('Floor selected: $floorId');
                        },
                        onRoomSelected: (roomId) {
                          _updateDebugInfo('Room selected: $roomId');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Floating Action Buttons
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'clear',
              onPressed: _clearDebugInfo,
              child: const Icon(Icons.clear_all),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'refresh',
              onPressed: () {
                _updateDebugInfo('Refreshing...');
                // Refresh logic
                context.read<FloorRoomSelBloc>().add(RefreshData());
              },
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}