import 'dart:convert';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/widgets/input/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/screens/authentication/login.dart';
import 'package:StapesHome/widgets/button.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/screens/authentication/common/password.dart';
import 'package:StapesHome/screens/authentication/common/otp_verify.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  Future<void> handleForgotPassword(BuildContext context) async {
    setState(() {
      _isLoading = true; // Start loading indicator
    });
    var response = await http.post(
      AuthRoutes.requestResetPassword,
      headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
      }),
    );
    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      String transactionId = responseBody['transaction_id'];
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              transactionId: transactionId,
              expiryTime: DateTime.parse(responseBody["otp_expires_at"]),
              onSuccess: () async {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordScreen(
                        title: 'Reset Password',
                        subtitle: 'Enter your email to receive verification code.',
                        nextScreen: LoginScreen(),
                        email: '',
                        transaction_id: '',
                      ),
                    ),
                  );
                } else {
                  print('Error :  $responseBody ');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        print('Error :  ${responseBody["detail"]} ');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false; // Stop loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.whiteColor,
                  ),
                )
              : SafeArea(
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
                            bottom: keyboardHeight > 0
                                ? keyboardHeight + screenSize.height * 0.02
                                : screenSize.height * 0.1,
                          ),
                          child: Center(
                            child: CustomButton(
                              text: "Send Code",
                              onPressed: () => handleForgotPassword(context),
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
  }
}
