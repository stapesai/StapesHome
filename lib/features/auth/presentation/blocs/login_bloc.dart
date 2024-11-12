import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login_state.dart';
import 'package:stapes_home/utils/hive.dart';
import 'package:stapes_home/utils/sessions_model.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RequestLoginUseCase requestLoginUseCase;
  final CompleteLoginUseCase completeLoginUseCase;
  final HiveService hiveService;

  LoginBloc({
    required this.requestLoginUseCase,
    required this.completeLoginUseCase,
    required this.hiveService,
  }) : super(LoginInitial()) {
    on<RequestLoginEvent>(_onRequestLogin);
    on<CompleteLoginEvent>(_onCompleteLogin);
  }

  Future<void> _onRequestLogin(
      RequestLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final result = await requestLoginUseCase(
      RequestLoginParams(
        email: event.email,
        password: event.password,
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

  Future<void> _onCompleteLogin(
      CompleteLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final result = await completeLoginUseCase(
      CompleteLoginParams(transactionId: event.transactionId),
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