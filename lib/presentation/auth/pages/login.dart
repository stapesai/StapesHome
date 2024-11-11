// Path: lib/presentation/auth/pages/login.dart
// Description: This file contains the login screen UI.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/domain/usecases/login.dart';
import 'package:stapes_home/presentation/auth/bloc/login_cubit.dart';
import 'package:stapes_home/presentation/auth/bloc/login_state.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:stapes_home/utils/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/widgets/input/password.dart';
import 'package:stapes_home/widgets/input/textfield.dart';
import "package:stapes_home/widgets/button.dart";
import 'package:stapes_home/screens/authentication/forgot_password.dart';
import 'package:stapes_home/screens/authentication/signup/email_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColor.backgroundColorgradient,
      ),
      child: BlocProvider(
        create: (context) => LoginCubit(
          requestLoginUseCase: serviceLocator<RequestLoginUseCase>(),
          completeLoginUseCase: serviceLocator<CompleteLoginUseCase>(),
          hiveService: serviceLocator<HiveService>(),
        ),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
              );
            } else if (state is LoginOtpRequired) {
              GoRouter.of(context).go(
                '/otp-verification/${state.transactionId}/${state.expiryTime}',
                extra: () {
                  context.read<LoginCubit>().completeLogin(
                        transactionId: state.transactionId,
                        context: context,
                      );
                },
              );
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              GoRouter.of(context).go(AppRouteConstants.devPage.routePath);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: AppPadding.pagePadding(context),
                            child: Column(
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.1),
                                _buildLogo(),
                                SizedBox(height: constraints.maxHeight * 0.05),
                                _buildLoginForm(),
                                Spacer(),
                                _buildSocialLogin(),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 80,
          child: SvgPicture.asset(
            'assets/icons/logo.svg',
            fit: BoxFit.contain,
          ),
        ),
        Text(
          'stapes.ai',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 46,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        NTextField(
          hintText: 'Email',
          controller: emailController,
          icon: Icons.email_rounded,
        ),
        SizedBox(height: 20),
        PasswordTextField(
          hintText: 'Password',
          controller: passwordController,
          icon: Icons.remove_red_eye_rounded,
        ),
        // SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPassword()),
              );
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColor.textHyperlinkColor,
                fontSize: 15,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return CustomButton(
              text: 'Log In',
              isLoading: state is LoginLoading,
              onPressed: () {
                context.read<LoginCubit>().requestLogin(
                      email: emailController.text,
                      password: passwordController.text,
                    );
              },
            );
          },
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: 16,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailSignUp()),
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: AppColor.textHyperlinkColor,
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(child: Divider(color: AppColor.whiteColor50, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'or continue with',
                  style: TextStyle(
                    color: AppColor.whiteColor50,
                    fontSize: 16,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColor.whiteColor50, thickness: 1)),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton('assets/icons/sso/google.png', () {}),
            SizedBox(width: 20),
            _buildSocialButton('assets/icons/sso/microsoft.png', () {}),
            SizedBox(width: 20),
            _buildSocialButton('assets/icons/sso/apple.png', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: ShapeDecoration(
          color: Color(0xFF34373F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          shadows: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 5.40,
              offset: Offset(1, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Center(
          child: Image(
            image: AssetImage(asset),
            height: 30,
          ),
        ),
      ),
    );
  }
}
