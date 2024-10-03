import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stapes_home/utils/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/screens/routes/main.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/widgets/input/password.dart';
import 'package:stapes_home/widgets/input/textfield.dart';
import "package:stapes_home/widgets/button.dart";
import 'package:stapes_home/utils/sessions_model.dart';
import 'package:stapes_home/screens/authentication/forgot_password.dart';
import 'package:stapes_home/screens/authentication/common/otp_verify.dart';
import 'package:stapes_home/screens/authentication/signup/email_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final HiveService hiveService = HiveService();
  bool _isLoading = false;

  Future<void> handleLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    var response = await http.post(
      AuthRoutes.requestLogin,
      headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );
    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      String transactionId = responseBody['transaction_id'];
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppColor.whiteColor,
                  ))
                : OtpVerificationScreen(
                    transactionId: transactionId,
                    expiryTime: DateTime.parse(responseBody["otp_expires_at"]),
                    onSuccess: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      var completeLoginResponse = await http.post(
                        AuthRoutes.completeLogin,
                        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
                        body: jsonEncode({
                          'transaction_id': transactionId,
                        }),
                      );

                      if (completeLoginResponse.statusCode == 200) {
                        var sessionResponseBody = json.decode(completeLoginResponse.body);
                        var sessionData = SessionsModel(
                          sessionId: sessionResponseBody['session']['session_id'],
                          userId: sessionResponseBody['session']['user_id'],
                        );

                        await hiveService.addBoxes([sessionData], "SessionBox");
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  _isLoading ? Center(child: CircularProgressIndicator()) : const MainScreen(),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error : ${completeLoginResponse.statusCode} - ${responseBody["detail"]} '),
                            ),
                          );
                        }
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColor.backgroundColorgradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColor.whiteColor))
            : SafeArea(
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
        CustomButton(
          text: 'Log In',
          onPressed: () => handleLogin(context),
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
