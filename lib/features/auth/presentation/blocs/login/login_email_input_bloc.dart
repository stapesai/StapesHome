import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/service_locator.dart';
import 'login_email_input_event.dart';
import 'login_email_input_state.dart';

class LoginEmailInputBloc extends Bloc<LoginEmailInputEvent, LoginEmailInputState> {
  final RequestLoginUseCase requestLoginUseCase;
  final CompleteLoginUseCase completeLoginUseCase;

  // Emits initial state and listens for incoming events
  LoginEmailInputBloc({
    required this.requestLoginUseCase,
    required this.completeLoginUseCase,
  }) : super(LoginEmailInputInitial()) {
    on<RequestLoginEvent>(_onRequestLogin);
    on<CompleteLoginEvent>(_onCompleteLogin);
  }

  Future<void> _onRequestLogin(RequestLoginEvent event, Emitter<LoginEmailInputState> emit) async {
    // Sets state to loading - CustomButton listens to this state and shows loading spinner
    emit(LoginEmailInputLoading());

    final result = await requestLoginUseCase(
      RequestLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(LoginEmailInputError(failure.toString())),
      (response) => emit(
        LoginEmailInputOtpRequired(
          transactionId: response.transactionId,
          expiryTime: response.otpExpiresAt,
        ),
      ),
    );
  }

  Future<void> _onCompleteLogin(CompleteLoginEvent event, Emitter<LoginEmailInputState> emit) async {
    emit(LoginEmailInputLoading());

    final result = await completeLoginUseCase(
      CompleteLoginParams(transactionId: event.transactionId),
    );

    result.fold(
      (failure) => emit(LoginEmailInputError(failure.toString())),
      (response) async {
        // Cache user details and user session to local data source
        serviceLocator<AuthLocalDataSource>().cacheUserSession(response.session);
        serviceLocator<AuthLocalDataSource>().cacheUser(response.user);

        emit(LoginEmailInputSuccess('Login Successful'));
      },
    );
  }
}
