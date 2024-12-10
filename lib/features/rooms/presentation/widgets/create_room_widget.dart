// File: lib/features/rooms/presentation/widgets/create_room_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/rooms/domain/usecases/create_room_usecase.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/create_room_bloc.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/create_room_event.dart';
import 'package:stapes_home/features/rooms/presentation/bloc/create_room_state.dart';
import 'package:stapes_home/service_locator.dart';

class CreateRoomWidget extends StatefulWidget {
  final String floorId;

  const CreateRoomWidget({super.key, required this.floorId});

  @override
  createState() => _CreateRoomWidgetState();
}

class _CreateRoomWidgetState extends State<CreateRoomWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRoomBloc(
        createRoomUseCase: serviceLocator<CreateRoomUseCase>(),
      ),
      child: AlertDialog(
        title: Text('Create Room'),
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
          BlocConsumer<CreateRoomBloc, CreateRoomState>(
            listener: (context, state) {
              if (state is CreateRoomSuccess) {
                Navigator.pop(context);
              } else if (state is CreateRoomError) {
                // Show error
              }
            },
            builder: (context, state) {
              if (state is CreateRoomLoading) {
                return CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () {
                  context.read<CreateRoomBloc>().add(CreateRoomSubmitted(
                        floorId: widget.floorId,
                        name: nameController.text,
                        type: typeController.text,
                      ));
                },
                child: Text('Create'),
              );
            },
          ),
        ],
      ),
    );
  }
}
