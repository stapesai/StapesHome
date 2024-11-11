// Path: lib/core/common/bloc/button/button_cubit.dart
// Description: This file contains the state cubit for the button bloc.

// import 'package:dartz/dartz.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stapes_home/core/common/bloc/button/button_state.dart';
// import 'package:stapes_home/core/config/config.dart';
// import 'package:stapes_home/core/usecase/usecase.dart';

// class ButtonCubit extends Cubit<ButtonState> {
//   ButtonCubit() : super(ButtonInitialState());

//   void excute({dynamic params, required UseCase usecase}) async {
//     // When the button is clicked, the state is changed to ButtonLoadingState.
//     emit(ButtonLoadingState());
//     if (Config.environment == Environment.development) {
//       Future.delayed(const Duration(seconds: 2));
//     }

//     // The usecase is called with the params.
//     try {
//       Either result = await usecase.call(params);

//       // If the usecase is successful, the state is changed to ButtonSuccessState.
//       result.fold((error) {
//         emit(ButtonFailureState(errorMessage: error));
//       }, (data) {
//         emit(ButtonSuccessState());
//       });
//     } catch (e) {
//       // If the usecase fails, the state is changed to ButtonFailureState with the error message.
//       emit(ButtonFailureState(errorMessage: e.toString()));
//     }
//   }
// }
