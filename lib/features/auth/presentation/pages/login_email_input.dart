import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login/login_email_input_bloc.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login/login_email_input_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/login/login_email_input_state.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/common/widgets/input/password.dart';
import 'package:stapes_home/core/common/widgets/input/text_field.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/features/auth/presentation/pages/signup_email_input.dart';

class LoginEmailInputScreen extends StatefulWidget {
  const LoginEmailInputScreen({super.key});

  @override
  createState() => _LoginEmailInputScreenState();
}

class _LoginEmailInputScreenState extends State<LoginEmailInputScreen> {
  late final Widget _logoWidget;
  late final Widget _socialLoginWidget;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: how to precache images?
    // precacheImage(AssetImage('assets/icons/sso/apple.png'), context);
    // precacheImage(AssetImage('assets/icons/sso/google.png'), context);
    // precacheImage(AssetImage('assets/icons/sso/microsoft.png'), context);
    super.initState();
    _logoWidget = _buildLogo();
    _socialLoginWidget = _buildSocialLogin();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginEmailInputBloc(
        requestLoginUseCase: serviceLocator<RequestLoginUseCase>(),
      ),
      child: BlocListener<LoginEmailInputBloc, LoginEmailInputState>(
        listener: (context, state) {
          // Show error message if login fails
          if (state is LoginEmailInputError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: AppColor.errorColor, content: Text(state.message)),
            );
          }
          // Navigate to OTP verification screen if OTP is required
          else if (state is LoginEmailInputOtpRequired) {
            GoRouter.of(context).push(
              AppRouteConstants.getLoginOtpVerificationPagePath(
                email: state.email,
                expiryTime: state.expiryTime,
                transactionId: state.transactionId,
              ),
            );
          }
        },
        child: KeyboardDismissOnTap(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              // child: GestureDetector(
              // onTap: () => FocusScope.of(context).unfocus(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(height: constraints.maxHeight * 0.1),
                            RepaintBoundary(child: _logoWidget),
                            SizedBox(height: constraints.maxHeight * 0.05),
                            _buildLoginForm(),
                            const Spacer(),
                            RepaintBoundary(child: _socialLoginWidget),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // ),
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
        const Text(
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
        CustomTextField(
          hintText: 'Email',
          controller: emailController,
          icon: Icons.email_rounded,
        ),
        const SizedBox(height: 20),
        CustomPasswordTextField(
          hintText: 'Password',
          controller: passwordController,
          icon: Icons.remove_red_eye_rounded,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              GoRouter.of(context).push(AppRouteConstants.forgotPassword.routePath);
            },
            child: const Text(
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
        const SizedBox(height: 20),
        BlocBuilder<LoginEmailInputBloc, LoginEmailInputState>(
          builder: (context, state) {
            return CustomButton(
              text: 'Log In',
              isLoading: state is LoginEmailInputLoading,
              onPressed: () {
                // Add LoginEmailInputBloc event to request login
                context.read<LoginEmailInputBloc>().add(
                      RequestLoginEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
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
                  MaterialPageRoute(builder: (context) => const SignUpEmailInputScreen()),
                );
              },
              child: const Text(
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
            children: const [
              Expanded(child: Divider(color: AppColor.whiteColor50, thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
          color: const Color(0xFF34373F),
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
