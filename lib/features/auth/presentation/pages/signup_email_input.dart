import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/common/widgets/input/text_field.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';
import 'package:stapes_home/features/auth/presentation/blocs/signup/sign_up_email_input_bloc.dart';
import 'package:stapes_home/features/auth/presentation/blocs/signup/sign_up_email_input_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/signup/sign_up_email_input_state.dart';
import 'package:stapes_home/service_locator.dart';

class SignUpEmailInputScreen extends StatefulWidget {
  const SignUpEmailInputScreen({super.key});

  @override
  createState() => _SignUpEmailInputScreenState();
}

class _SignUpEmailInputScreenState extends State<SignUpEmailInputScreen> {
  final TextEditingController emailController = TextEditingController();
  void _onSignUpButtonPressed(BuildContext context) {
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      context.read<SignUpEmailInputBloc>().add(RequestSignUpEvent(email: email));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email')),
      );
    }
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: BlocProvider(
            create: (context) => SignUpEmailInputBloc(
              requestSignUpUseCase: serviceLocator<RequestSignUpUseCase>(),
            ),
            child: BlocListener<SignUpEmailInputBloc, SignUpEmailInputState>(
              listener: (context, state) {
                if (state is SignUpEmailInputOtpRequired) {
                  GoRouter.of(context).push(
                    AppRouteConstants.getSignUpOtpVerificationPagePath(
                      email: emailController.text,
                      transactionId: state.transactionId,
                      expiryTime: state.expiryTime,
                    ),
                  );
                } else if (state is SignUpEmailInputError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
                  );
                }
              },
              child: SafeArea(
                child: Padding(
                  padding: AppPadding.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Sign Up',
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
                          child: BlocBuilder<SignUpEmailInputBloc, SignUpEmailInputState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: "Send Code",
                                isLoading: state is SignUpEmailInputLoading,
                                onPressed: () => _onSignUpButtonPressed(context),
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
