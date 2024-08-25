import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jarvis/constants/api_routes.dart';
import 'package:jarvis/constants/font_sizes.dart';
import 'package:jarvis/widgets/button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/screens/authentication/common/password.dart';
import 'package:jarvis/screens/authentication/common/otp_verify.dart';
import 'package:jarvis/screens/authentication/signup/details_form.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  Future<void> handlerequestSignup(BuildContext context, String email) async {
    setState(() {
      _isLoading = true;
    });

    var check_email_response = await http.post(
      AuthRoutes.checkEmail(email),
      headers: {'accept': 'application/json'},
    );
    var check_email_responseBody = json.decode(check_email_response.body);

    if (check_email_response.statusCode == 200) {
      var response = await http.post(
        AuthRoutes.requestSignup,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );
      var responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        String transactionId = responseBody['transaction_id'];
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                transactionId: transactionId,
                expiry_time: DateTime.parse(responseBody["otp_expires_at"]),
                onSuccess: () async {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordScreen(
                          title: 'Create Password',
                          subtitle: 'Lets create a password to secure your account.',
                          nextScreen: SignupForm(
                            password: '',
                            transaction_id: '',
                            email: '',
                          ),
                          email: email,
                          transaction_id: transactionId,
                        ),
                      ),
                    );
                  } else {
                    print('context not mounted');
                  }
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
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error : ${check_email_response.statusCode} - ${check_email_responseBody["detail"]} '),
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
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.whiteColor,
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenSize.height * 0.08),
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
                              onPressed: () => handlerequestSignup(context, emailController.text),
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
