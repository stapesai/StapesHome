import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jarvis/screens/authentication/login.dart';
import 'package:jarvis/widgets/button.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/screens/authentication/password.dart';
import 'package:jarvis/screens/authentication/otp_verify.dart';

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
    var url = Uri.https('auth.jarvishome.in', '/auth/reset-password/request-reset');
    var response = await http.post(
      url,
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
              time: DateTime.parse(responseBody["otp_expires_at"]),
              onSuccess: () async {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordScreen(
                        title: 'Reset Password',
                        subtitle:
                            'Enter your email to receive verification code.',
                        nextScreen: LoginScreen(),
                        email: '',
                        transaction_id: '',
                      ),
                    ),
                  );
                } else {
                  print('Error :  ${responseBody} ');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
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
                      content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
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
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColor.whiteColor,
              ))
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
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
                                  padding: const EdgeInsets.symmetric(horizontal: 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'Forgot Password',
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
                                              handleForgotPassword(context);
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
