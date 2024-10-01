// File: lib/presentation/pages/auth/otp_verification_page.dart
// Description: This file contains the OtpVerificationPage widget, which handles OTP verification for both signup and login processes.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/font_sizes.dart';
import '../../../core/constants/padding.dart';
import '../../widgets/custom_button.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String transactionId;
  final DateTime expiryTime;
  final String email;

  const OtpVerificationPage({
    super.key,
    required this.transactionId,
    required this.expiryTime,
    required this.email,
  });

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late String _otp;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.expiryTime.difference(DateTime.now()).inSeconds;
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        _startTimer();
      }
    });
  }

  String _formatRemainingTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is OtpVerified) {
          // Navigate to the next page (password creation for signup or home for login)
          Navigator.of(context).pushReplacementNamed('/create_password');
        }
      },
      builder: (context, state) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: AppColor.backgroundColorgradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: AppPadding.pagePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.05),
                    Text(
                      'OTP Verification',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: AppFontSizes.pageHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'Enter the verification code sent to your email address.',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: AppFontSizes.pageSubHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    Center(
                      child: Pinput(
                        length: 6,
                        onCompleted: (pin) => _otp = pin,
                        onChanged: (value) => _otp = value,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.textFieldbgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColor.whiteColor50),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.textFieldbgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColor.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Center(
                      child: Text(
                        'Your verification code will expire in ${_formatRemainingTime()}',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: CustomButton(
                        text: "Verify",
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  VerifyOtpEvent(
                                    transactionId: widget.transactionId,
                                    otp: _otp,
                                  ),
                                );
                              },
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  ResendOtpEvent(email: widget.email),
                                );
                              },
                        child: Text(
                          "Resend Code",
                          style: TextStyle(
                            color: AppColor.textHyperlinkColor,
                            fontSize: 16,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
