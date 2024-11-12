// Path: lib/presentation/auth/pages/forgot_password.dart
// Description: This file contains the forgot password pagee UI.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/presentation/auth/states/forgot_password_email_input_state.dart';
import 'package:stapes_home/presentation/auth/cubit/forgot_password_email_input_cubit.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:stapes_home/widgets/input/textfield.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  // Future<void> handleForgotPassword(BuildContext context) async {
  //   setState(() {
  //     _isLoading = true; // Start loading indicator
  //   });
  //   var response = await http.post(
  //     AuthRoutes.requestResetPassword,
  //     headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
  //     body: jsonEncode({
  //       'email': emailController.text,
  //     }),
  //   );
  //   var responseBody = json.decode(response.body);

  //   if (response.statusCode == 200) {
  //     String transactionId = responseBody['transaction_id'];
  //     if (context.mounted) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => OtpVerificationScreen(
  //             transactionId: transactionId,
  //             expiryTime: DateTime.parse(responseBody["otp_expires_at"]),
  //             onSuccess: () async {
  //               if (context.mounted) {
  //                 Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => PasswordScreen(
  //                       title: 'Reset Password',
  //                       subtitle: 'Enter your email to receive verification code.',
  //                       nextScreen: LoginScreen(),
  //                       email: '',
  //                       transaction_id: '',
  //                     ),
  //                   ),
  //                 );
  //               } else {
  //                 print('Error :  $responseBody ');
  //                 if (context.mounted) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
  //                     ),
  //                   );
  //                 }
  //               }
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //   } else {
  //     if (context.mounted) {
  //       print('Error :  ${responseBody["detail"]} ');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
  //         ),
  //       );
  //     }
  //   }
  //   setState(() {
  //     _isLoading = false; // Stop loading indicator
  //   });
  // }

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
          create: (context) => ForgotPasswordCubit(
            requestPasswordResetUseCase: serviceLocator<RequestPasswordResetUseCase>(),
            completePasswordResetUseCase: serviceLocator<CompletePasswordResetUseCase>(),
          ),
          child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.errorColor,
                  ),
                );
              } else if (state is ForgotPasswordOtpRequired) {
                GoRouter.of(context).push(
                  AppRouteConstants.getOtpVerificationPagePath(
                    state.transactionId,
                    state.expiryTime,
                  ),
                  extra: () {
                    context.read<ForgotPasswordCubit>().completePasswordReset(
                          context: context,
                          email: emailController.text,
                          transactionId: state.transactionId,
                        );
                  },
                );
              } else if (state is ForgotPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.successColor,
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
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            // fontSize: screenSize.width * 0.1,
                            fontSize: AppFontSizes.pageHeading,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      SizedBox(
                        child: Text(
                          'Enter your email to receive verification code.',
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
                        child: NTextField(
                          hintText: 'Enter your email',
                          controller: emailController,
                          icon: Icons.email_rounded,
                        ),
                      ),
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: EdgeInsets.only(
                          bottom:
                              keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.02 : screenSize.height * 0.1,
                        ),
                        child: Center(
                          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: "Send Code",
                                isLoading: state is ForgotPasswordLoading,
                                onPressed: () {
                                  context.read<ForgotPasswordCubit>().requestPasswordReset(email: emailController.text);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
