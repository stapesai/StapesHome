// File: lib/features/rooms/presentation/widgets/delete_room_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/features/rooms/domain/usecases/delete_room_usecase.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/delete_room_bloc.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/delete_room_event.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/delete_room_state.dart';
import 'package:stapes_home/service_locator.dart';

class DeleteRoomWidget extends StatelessWidget {
  final RoomModel room;

  const DeleteRoomWidget({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteRoomBloc(
        deleteRoomUseCase: serviceLocator<DeleteRoomUseCase>(),
      ),
      child: AlertDialog(
        title: const Text('Delete Room'),
        content: Text('Are you sure you want to delete ${room.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          BlocConsumer<DeleteRoomBloc, DeleteRoomState>(
            listener: (context, state) {
              if (state is DeleteRoomSuccess) {
                Navigator.pop(context, true);
              } else if (state is DeleteRoomError) {
                CustomSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is DeleteRoomLoading) {
                return const CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () {
                  context.read<DeleteRoomBloc>().add(
                        DeleteRoomSubmitted(roomId: room.id!),
                      );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              );
            },
          ),
        ],
      ),
    );
  }
}