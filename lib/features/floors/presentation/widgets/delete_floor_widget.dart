import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'package:stapes_home/features/floors/presentation/bloc/delete_floor_bloc.dart';
import 'package:stapes_home/features/floors/presentation/bloc/delete_floor_event.dart';
import 'package:stapes_home/features/floors/presentation/bloc/delete_floor_state.dart';
import 'package:stapes_home/service_locator.dart';

class DeleteFloorWidget extends StatelessWidget {
  final FloorModel floor;

  const DeleteFloorWidget({
    super.key,
    required this.floor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteFloorBloc(
        deleteFloorUseCase: serviceLocator<DeleteFloorUseCase>(),
      ),
      child: AlertDialog(
        title: const Text('Delete Floor'),
        content: Text('Are you sure you want to delete ${floor.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          BlocConsumer<DeleteFloorBloc, DeleteFloorState>(
            listener: (context, state) {
              if (state is DeleteFloorSuccess) {
                Navigator.pop(context, true);
              } else if (state is DeleteFloorError) {
                CustomSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is DeleteFloorLoading) {
                return const CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () {
                  context.read<DeleteFloorBloc>().add(
                        DeleteFloorSubmitted(floorId: floor.id!),
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
