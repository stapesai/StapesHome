import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/floors/domain/usecases/create_floor_usecase.dart';
import 'package:stapes_home/features/floors/presentation/bloc/create_floor_bloc.dart';
import 'package:stapes_home/features/floors/presentation/bloc/create_floor_event.dart';
import 'package:stapes_home/features/floors/presentation/bloc/create_floor_state.dart';
import 'package:stapes_home/service_locator.dart';

class CreateFloorWidget extends StatefulWidget {
  const CreateFloorWidget({super.key});

  @override
  createState() => _CreateFloorWidgetState();
}

class _CreateFloorWidgetState extends State<CreateFloorWidget> {
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  @override
  void dispose() {
    aliasController.dispose();
    levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateFloorBloc(
        createFloorUseCase: serviceLocator<CreateFloorUseCase>(),
      ),
      child: AlertDialog(
        title: Text('Create Floor'),
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
          BlocConsumer<CreateFloorBloc, CreateFloorState>(
            listener: (context, state) {
              if (state is CreateFloorSuccess) {
                Navigator.pop(context);
              } else if (state is CreateFloorError) {
                // Show error
              }
            },
            builder: (context, state) {
              if (state is CreateFloorLoading) {
                return CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () {
                  context.read<CreateFloorBloc>().add(CreateFloorSubmitted(
                        alias: aliasController.text,
                        level: levelController.text,
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
