// File: lib/presentation/pages/auth/signup/email_signup_page.dart
// Description: This file contains the EmailSignUpPage widget, which handles the first step of user signup.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/font_sizes.dart';
import '../../../../core/constants/padding.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'otp_verification_page.dart';

class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({super.key});

  @override
  _EmailSignUpPageState createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is SignupOtpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                transactionId: state.transactionId,
                expiryTime: state.expiryTime,
                email: emailController.text,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
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
              body: SafeArea(
                child: Padding(
                  padding: AppPadding.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Text(
                        'Enter your email to receive verification code.',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageSubHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.04),
                      CustomTextField(
                        hintText: 'Enter your email',
                        controller: emailController,
                        icon: Icons.email_rounded,
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
                          child: CustomButton(
                            text: "Send Code",
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    BlocProvider.of<AuthBloc>(context).add(
                                      RequestSignupEvent(email: emailController.text),
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
        );
      },
    );
  }
}
