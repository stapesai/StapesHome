import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_email_input_bloc.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_email_input_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_email_input_state.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:stapes_home/core/common/widgets/input/textfield.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class ForgotPasswordEmailInputScreen extends StatefulWidget {
  const ForgotPasswordEmailInputScreen({super.key});

  @override
  createState() => _ForgotPasswordEmailInputScreenState();
}

class _ForgotPasswordEmailInputScreenState extends State<ForgotPasswordEmailInputScreen> {
  final TextEditingController emailController = TextEditingController();

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
          create: (context) => ForgotPasswordEmailInputBloc(
            requestPasswordResetUseCase: serviceLocator<RequestPasswordResetUseCase>(),
          ),
          child: BlocListener<ForgotPasswordEmailInputBloc, ForgotPasswordEmailInputState>(
            listener: (context, state) {
              if (state is ForgotPasswordErrorInSendingOtp) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.errorColor,
                  ),
                );
              } else if (state is ForgotPasswordEmailInputOtpSent) {
                GoRouter.of(context).push(
                  AppRouteConstants.getForgotPasswordOtpVerificationPagePath(
                    emailController.text,
                    state.transactionId,
                    state.expiryTime,
                  ),
                  extra: {
                    'email': emailController.text,
                  },
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
                        child: CustomTextField(
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
                          child: BlocBuilder<ForgotPasswordEmailInputBloc, ForgotPasswordEmailInputState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: 'Send OTP',
                                isLoading: state is ForgotPasswordEmailInputLoading,
                                onPressed: () {
                                  context.read<ForgotPasswordEmailInputBloc>().add(
                                        ForgotPasswordEmailSubmitted(
                                          email: emailController.text,
                                        ),
                                      );
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
