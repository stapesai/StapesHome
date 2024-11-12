// // Path: lib/presentation/auth/cubit/forgot_password_cubit.dart
// // Description: This file contains the cubit for the forgot password feature.

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:stapes_home/core/router/app_router.dart';
// import 'package:stapes_home/core/constants/app_route_constants.dart';
// import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
// import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
// import 'package:stapes_home/presentation/auth/states/forgot_password_email_input_state.dart';

// class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
//   final RequestPasswordResetUseCase requestPasswordResetUseCase;
//   final CompletePasswordResetUseCase completePasswordResetUseCase;

//   ForgotPasswordCubit({
//     required this.requestPasswordResetUseCase,
//     required this.completePasswordResetUseCase,
//   }) : super(ForgotPasswordInitial());

//   Future<void> requestPasswordReset({
//     required String email,
//   }) async {
//     emit(ForgotPasswordLoading());

//     final result = await requestPasswordResetUseCase(
//       RequestPasswordResetParams(email: email),
//     );

//     result.fold(
//       (failure) => emit(ForgotPasswordError(failure.toString())),
//       (response) => emit(
//         ForgotPasswordOtpRequired(transactionId: response.transactionId, expiryTime: response.otpExpiresAt),
//       ),
//     );
//   }

//   Future<void> completePasswordReset({
//     required BuildContext context,
//     required String email,
//     required String transactionId,
//   }) async {
//     emit(ForgotPasswordLoading());

//     // GoRouter.of(context).go(
//     //   AppRouteConstants.getCreatePasswordPagePath(
//     //     title: 'Reset Password',

//     var password = 'password';
//     final result = await completePasswordResetUseCase(
//       CompletePasswordResetParams(email: email, password: password, transactionId: transactionId),
//     );

//     result.fold(
//       (failure) => emit(ForgotPasswordError(failure.toString())),
//       (response) => emit(ForgotPasswordSuccess(response.message)),
//     );
//   }
// }
