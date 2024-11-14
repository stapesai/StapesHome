import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login/login_otp_verification_bloc.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login/login_otp_verification_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login/login_otp_verification_state.dart';
import 'package:stapes_home/features/auth/presentation/widgets/otp_input_widget.dart';
import 'package:stapes_home/service_locator.dart';
import "package:stapes_home/core/common/widgets/button.dart";

class LoginOtpVerificationScreen extends StatefulWidget {
  final String email;
  final String transactionId;
  final DateTime expiryTime;

  const LoginOtpVerificationScreen({
    super.key,
    required this.email,
    required this.transactionId,
    required this.expiryTime,
  });

  @override
  createState() => _LoginOtpVerificationScreenState();
}

class _LoginOtpVerificationScreenState extends State<LoginOtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late int _remainingSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.expiryTime.difference(DateTime.now()).inSeconds;
    _startTimer();
  }

  Future<void> _onVerifyButtonPressed(BuildContext context) async {
    // OTP is joined from all text controllers and LoginOtpSubmitted event is dispatched
    String otp = _controllers.map((controller) => controller.text).join();
    context.read<LoginOtpVerificationBloc>().add(LoginOtpSubmitted(
          email: widget.email,
          transactionId: widget.transactionId,
          otp: otp,
        ));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && mounted) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        setState(() {
          // TODO: Enable resend button when timer expires
        });
      }
    });
  }

  String _remainingTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;

    String minuteString = minutes > 0 ? '$minutes min' : '';
    String secondString = seconds > 0 ? '$seconds sec' : '';
    return '$minuteString $secondString';
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: AppColor.backgroundColorgradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: BlocProvider(
            create: (context) => LoginOtpVerificationBloc(
              verifyOtpUseCase: serviceLocator<OtpVerificationUsecase>(),
              completeLoginUseCase: serviceLocator<CompleteLoginUseCase>(),
            ),
            child: BlocListener<LoginOtpVerificationBloc, LoginOtpVerificationState>(
              listener: (context, state) {
                // OTP Verification success
                if (state is LoginOtpVerificationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('OTP Verified Successfully'),
                    backgroundColor: AppColor.successColor,
                  ));
                  GoRouter.of(context).go(AppRouteConstants.devPageUserDetailsShow.routePath);
                }
                // OTP Verification error
                else if (state is LoginOtpVerificationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColor.errorColor,
                    ),
                  );
                }
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: Padding(
                      padding: AppPadding.pagePadding(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenSize.height * 0.05),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'OTP Verification',
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: AppFontSizes.pageHeading,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          SizedBox(
                            child: Text(
                              'Enter the verification code sent to your email address.',
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: AppFontSizes.pageSubHeading,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.04),
                          SizedBox(
                            child: Center(
                              child: BlocBuilder<LoginOtpVerificationBloc, LoginOtpVerificationState>(
                                builder: (context, state) {
                                  return OtpInputWidget(
                                    controllers: _controllers,
                                    focusNodes: _focusNodes,
                                    onOtpComplete: (otp) => _onVerifyButtonPressed(context),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          Center(
                            child: Text(
                              'Your verification code will expire in ${_remainingTime()} ',
                              style: const TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: EdgeInsets.only(
                              bottom: keyboardHeight > 0
                                  ? keyboardHeight + screenSize.height * 0.02
                                  : screenSize.height * 0.1,
                            ),
                            child: Center(
                              child: BlocBuilder<LoginOtpVerificationBloc, LoginOtpVerificationState>(
                                builder: (context, state) {
                                  return CustomButton(
                                      text: "Next",
                                      isLoading: state is LoginOtpVerificationLoading,
                                      onPressed: () => _onVerifyButtonPressed(context));
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          )),
    );
  }
}
