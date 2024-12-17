// File: lib/features/rooms/presentation/widgets/edit_room_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/features/rooms/domain/usecases/update_room_usecase.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/edit_room_bloc.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/edit_room_event.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/edit_room_state.dart';
import 'package:stapes_home/service_locator.dart';

class EditRoomWidget extends StatefulWidget {
  final RoomModel room;

  const EditRoomWidget({super.key, required this.room});

  @override
  createState() => _EditRoomWidgetState();
}

class _EditRoomWidgetState extends State<EditRoomWidget> {
  late TextEditingController nameController;
  late TextEditingController typeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.room.name);
    typeController = TextEditingController(text: widget.room.type);
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditRoomBloc(
        updateRoomUseCase: serviceLocator<UpdateRoomUseCase>(),
      ),
      child: AlertDialog(
        title: Text('Edit Room'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          BlocConsumer<EditRoomBloc, EditRoomState>(
            listener: (context, state) {
              if (state is EditRoomSuccess) {
                Navigator.pop(context);
              } else if (state is EditRoomError) {
                // Show error
              }
            },
            builder: (context, state) {
              if (state is EditRoomLoading) {
                return CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () {
                  context.read<EditRoomBloc>().add(EditRoomSubmitted(
                        room: widget.room.copyWith(
                          name: nameController.text,
                          type: typeController.text,
                        ),
                      ));
                },
                child: Text('Save'),
              );
            },
          ),
        ],
      ),
    );
  }
}
