// File: lib/presentation/pages/auth/reset_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/font_sizes.dart';
import '../../../../core/constants/padding.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../bloc/auth/auth_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  final String transactionId;
  final String email;

  const ResetPasswordPage({
    Key? key,
    required this.transactionId,
    required this.email,
  }) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is PasswordResetComplete) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password reset successfully')),
          );
          Navigator.of(context).pushReplacementNamed('/login');
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
                      'Reset Password',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: AppFontSizes.pageHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'Enter your new password.',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: AppFontSizes.pageSubHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    CustomTextField(
                      hintText: 'New Password',
                      controller: passwordController,
                      isPassword: true,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      hintText: 'Confirm New Password',
                      controller: confirmPasswordController,
                      isPassword: true,
                    ),
                    Spacer(),
                    CustomButton(
                      text: 'Reset Password',
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (passwordController.text == confirmPasswordController.text) {
                                BlocProvider.of<AuthBloc>(context).add(
                                  CompletePasswordResetEvent(
                                    transactionId: widget.transactionId,
                                    newPassword: passwordController.text,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Passwords do not match')),
                                );
                              }
                            },
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
