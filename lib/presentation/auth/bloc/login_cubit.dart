// Path: lib/presentation/auth/bloc/login_cubit.dart
// Description: This file contains the cubit for the login bloc.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/data/models/auth/login_req_parms.dart';
import 'package:stapes_home/domain/usecases/login_usecase.dart';
import 'package:stapes_home/presentation/auth/bloc/login_state.dart';
import 'package:stapes_home/utils/hive.dart';
import 'package:stapes_home/utils/sessions_model.dart';

class LoginCubit extends Cubit<LoginState> {
  final RequestLoginUseCase requestLoginUseCase;
  final CompleteLoginUseCase completeLoginUseCase;
  final HiveService hiveService;

  LoginCubit({
    required this.requestLoginUseCase,
    required this.completeLoginUseCase,
    required this.hiveService,
  }) : super(LoginInitial());

  Future<void> requestLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await requestLoginUseCase(
      RequestLoginParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => emit(LoginError(failure.toString())),
      (response) => emit(
        LoginOtpRequired(
          transactionId: response.transactionId,
          expiryTime: response.otpExpiresAt,
        ),
      ),
    );
  }

  Future<void> completeLogin({
    required String transactionId,
  }) async {
    emit(LoginLoading());

    final result = await completeLoginUseCase(
      CompleteLoginParams(transactionId: transactionId),
    );

    result.fold(
      (failure) => emit(LoginError(failure.toString())),
      (response) async {
        var sessionData = SessionsModel(
          sessionId: response.sessionId,
          userId: response.userId,
        );

        await hiveService.addBoxes([sessionData], "SessionBox");

        emit(LoginSuccess('Login Successful'));
      },
    );
  }
}
