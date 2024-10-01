// File: lib/presentation/pages/auth/login_page.dart
// Description: This file contains the LoginPage widget, which handles user login.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/font_sizes.dart';
import '../../../core/constants/padding.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/password_text_field.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'forgot_password_page.dart';
import 'email_signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      builder: (context, state) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: AppColor.backgroundColorgradient,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppPadding.pagePadding(context),
                  child: Column(
                    children: [
                      SizedBox(height: screenSize.height * 0.1),
                      _buildLogo(),
                      SizedBox(height: screenSize.height * 0.05),
                      _buildLoginForm(context, state),
                      SizedBox(height: screenSize.height * 0.05),
                      _buildSocialLogin(),
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

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    return Column(
      children: [
        CustomTextField(
          hintText: 'Email',
          controller: emailController,
          icon: Icons.email_rounded,
        ),
        SizedBox(height: 20),
        PasswordTextField(
          hintText: 'Password',
          controller: passwordController,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            ),
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
        CustomButton(
          text: 'Log In',
          onPressed: state is AuthLoading
              ? null
              : () {
                  BlocProvider.of<AuthBloc>(context).add(
                    LoginEvent(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailSignUpPage()),
              ),
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
          shadows: [
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
