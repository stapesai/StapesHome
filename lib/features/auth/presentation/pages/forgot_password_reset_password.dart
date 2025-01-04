import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/common/widgets/input/password.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_reset_password_bloc.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_reset_password_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_reset_password_state.dart';
import 'package:stapes_home/service_locator.dart';

class ForgotPasswordResetPasswordScreen extends StatefulWidget {
  final String email;
  final String transactionId;

  const ForgotPasswordResetPasswordScreen({
    super.key,
    required this.email,
    required this.transactionId,
  });

  @override
  createState() => _ForgotPasswordResetPasswordScreenState();
}

class _ForgotPasswordResetPasswordScreenState extends State<ForgotPasswordResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Force portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation when disposing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (context) => ForgotPasswordResetPasswordBloc(
          completePasswordResetUseCase: serviceLocator<CompletePasswordResetUseCase>(),
        ),
        child: BlocListener<ForgotPasswordResetPasswordBloc, ForgotPasswordResetPasswordState>(
          listener: (BuildContext context, ForgotPasswordResetPasswordState state) {
            if (state is ForgotPasswordResetPasswordError) {
              CustomSnackbar(context, state.message, type: SnackbarType.error);
            } else if (state is ForgotPasswordResetPasswordSuccess) {
              CustomSnackbar(context, 'Password reset successfully', type: SnackbarType.success);
              // Go back to login page
              GoRouter.of(context).go(AppRouteConstants.login.routePath);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Create New Password',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: AppFontSizes.pageHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w700,
                      ),
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
                  CustomPasswordTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    icon: Icons.remove_red_eye_outlined,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomPasswordTextField(
                    hintText: 'Confirm Password',
                    controller: confirmPasswordController,
                    icon: Icons.remove_red_eye_outlined,
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      bottom: keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.02 : screenSize.height * 0.1,
                    ),
                    child: Center(
                      child: BlocBuilder<ForgotPasswordResetPasswordBloc, ForgotPasswordResetPasswordState>(
                          builder: (context, state) {
                        return CustomButton(
                            text: "Continue",
                            isLoading: state is ForgotPasswordResetPasswordLoading,
                            onPressed: () {
                              context.read<ForgotPasswordResetPasswordBloc>().add(ForgotPasswordNewPasswordSubmitted(
                                    email: widget.email,
                                    transactionId: widget.transactionId,
                                    password: passwordController.text,
                                    confirmPassword: confirmPasswordController.text,
                                  ));
                            });
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
