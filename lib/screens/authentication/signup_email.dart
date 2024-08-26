import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jarvis/widgets/button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/screens/authentication/password.dart';
import 'package:jarvis/screens/authentication/otp_verify.dart';
import 'package:jarvis/screens/authentication/signup_form.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  Future<void> handleSignup(BuildContext context, String email) async {
    setState(() {
      _isLoading = true;
    });
    var check_email_url = Uri.https('auth.jarvishome.in', '/check/email', {
      'email': email,
    });
    var check_email_response = await http.post(
      check_email_url,
      headers: {'accept': 'application/json'},
    );
    var check_email_responseBody = json.decode(check_email_response.body);

    if (check_email_response.statusCode == 200) {
      var signup_url =
          Uri.https('auth.jarvishome.in', '/auth/signup/request-signup');
      var response = await http.post(
        signup_url,
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonEncode({
          'email': emailController.text,
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
                time: DateTime.parse(responseBody["otp_expires_at"]),
                onSuccess: () async {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordScreen(
                          title: 'Create Password',
                          subtitle:
                              'Lets create a password to secure your account.',
                          nextScreen: SignupForm(),
                        ),
                      ),
                    );
                  } else {
                    print('Error :  ${responseBody} ');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error : ${response.statusCode} - ${responseBody["detail"]} '),
                        ),
                      );
                    }
                  }
                },
                onError: () {
                  print('Error :  ${responseBody["detail"]} ');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Error : ${response.statusCode} - ${responseBody["detail"]} '),
                      ),
                    );
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
              content: Text(
                  'Error : ${response.statusCode} - ${responseBody["detail"]} '),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error : ${check_email_response.statusCode} - ${check_email_responseBody["detail"]} '),
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
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColor.whiteColor,
                  ))
                : Container(
                    child: Stack(
                    children: [
                      Positioned(
                          left: 10,
                          top: 90,
                          right: 0,
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 44,
                                                fontFamily: 'Ubuntu',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(
                                            width: 380,
                                            child: Text(
                                              'Enter your email to receive verification code.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Ubuntu',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 40),
                                          NTextField(
                                            hintText: 'Enter your email',
                                            controller: emailController,
                                            icon: Icons.email_rounded,
                                          ),
                                          SizedBox(height: 330),
                                          CustomButton(
                                              text: "Send Code",
                                              onPressed: () {
                                                handleSignup(context,
                                                    emailController.text);
                                              }),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ))
                    ],
                  ))));
  }
}
