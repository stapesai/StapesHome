import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/no_params.dart';
import 'package:stapes_home/features/auth/domain/usecases/device_info_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'login_email_input_event.dart';
import 'login_email_input_state.dart';

class LoginEmailInputBloc extends Bloc<LoginEmailInputEvent, LoginEmailInputState> {
  final RequestLoginUseCase requestLoginUseCase;
  final GetDeviceInfoUseCase getDeviceInfoUseCase;

  // Emits initial state and listens for incoming events
  LoginEmailInputBloc({
    required this.requestLoginUseCase,
    required this.getDeviceInfoUseCase,
  }) : super(LoginEmailInputInitial()) {
    on<RequestLoginEvent>(_onRequestLogin);
  }

  Future<void> _onRequestLogin(RequestLoginEvent event, Emitter<LoginEmailInputState> emit) async {
    // Sets state to loading - CustomButton listens to this state and shows loading spinner
    emit(LoginEmailInputLoading());

    // Fetches device info
    final deviceInfoResult = await getDeviceInfoUseCase(NoParams());

    // If device info fetch fails, emits error state
    deviceInfoResult.fold(
      (failure) => emit(LoginEmailInputError(failure.message)),
      (deviceInfo) async {
        final result = await requestLoginUseCase(
          RequestLoginParams(
            email: event.email,
            password: event.password,
            deviceInfo: deviceInfo,
          ),
        );

        result.fold(
          (failure) => emit(LoginEmailInputError(failure.message)),
          (response) => emit(
            LoginEmailInputOtpRequired(
              email: event.email,
              transactionId: response.transactionId,
              expiryTime: response.otpExpiresAt,
            ),
          ),
        );
      },
    );
  }
}
