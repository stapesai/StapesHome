import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/features/floors/domain/usecases/update_floor_usecase.dart';
import 'package:stapes_home/features/floors/presentation/bloc/edit_floor_bloc.dart';
import 'package:stapes_home/features/floors/presentation/bloc/edit_floor_event.dart';
import 'package:stapes_home/features/floors/presentation/bloc/edit_floor_state.dart';
import 'package:stapes_home/service_locator.dart';

class EditFloorWidget extends StatefulWidget {
  final FloorModel floor;

  const EditFloorWidget({super.key, required this.floor});

  @override
  createState() => _EditFloorWidgetState();
}

class _EditFloorWidgetState extends State<EditFloorWidget> {
  late TextEditingController aliasController;
  late TextEditingController levelController;

  @override
  void initState() {
    super.initState();
    aliasController = TextEditingController(text: widget.floor.alias);
    levelController = TextEditingController(text: widget.floor.level.toString());
  }

  @override
  void dispose() {
    aliasController.dispose();
    levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditFloorBloc(
        updateFloorUseCase: serviceLocator<UpdateFloorUseCase>(),
      ),
      child: AlertDialog(
        title: Text('Edit Floor'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: aliasController,
                decoration: InputDecoration(labelText: 'Alias'),
              ),
              TextField(
                controller: levelController,
                decoration: InputDecoration(labelText: 'Level'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          BlocConsumer<EditFloorBloc, EditFloorState>(
            listener: (context, state) {
              if (state is EditFloorSuccess) {
                Navigator.pop(context);
              } else if (state is EditFloorError) {
                // Show error
              }
            },
            builder: (context, state) {
              if (state is EditFloorLoading) {
                return CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () {
                  context.read<EditFloorBloc>().add(EditFloorSubmitted(
                        floor: widget.floor.copyWith(
                          alias: aliasController.text,
                          level: int.tryParse(levelController.text) ?? widget.floor.level,
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
