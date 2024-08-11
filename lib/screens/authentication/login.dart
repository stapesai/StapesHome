import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/cache/hive.dart'; // Import your Hive service
import 'package:jarvis/cache/sessions_model.dart'; // Import your session model
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/main.dart';
import 'package:jarvis/widgets/text_field.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'error_screens/otp_verify_error.dart';
import 'otp_verify.dart'; // Import the OTP Verification screen
import 'email_signup.dart'; // Import the EmailSignUp screen
import 'reset_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final HiveService hiveService = HiveService();
  bool _isLoading = false;

  Future<void> handleLogin(BuildContext context) async {
    setState(() {
      _isLoading = true; // Start loading indicator
    });
    var url = Uri.https('auth.jarvishome.in', '/auth/login/request-login');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
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
                var completeLoginUrl = Uri.https(
                    'auth.jarvishome.in', '/auth/login/complete-login');
                var completeLoginResponse = await http.post(
                  completeLoginUrl,
                  headers: {
                    'Content-Type': 'application/json',
                    'accept': 'application/json'
                  },
                  body: jsonEncode({
                    'transaction_id': transactionId,
                  }),
                );

                if (completeLoginResponse.statusCode == 200) {
                  var sessionResponseBody = json.decode(completeLoginResponse.body);
                  // print("SessionId:"+sessionResponseBody['session']['session_id']);
                  // print("Userid:"+sessionResponseBody['session']['user_id']);
                  // print( "CREATE AT: ${DateTime.parse(sessionResponseBody['session']['created_at'])}" );
                  // print("LaST TIME: ${DateTime.parse(sessionResponseBody['session']['last_active_at'])}");
                  var sessionData = SessionsModel(
                    sessionId: sessionResponseBody['session']['session_id'],
                    userId: sessionResponseBody['session']['user_id'],
                    createdAt: DateTime.parse(sessionResponseBody['session']['created_at']),
                    lastActiveAt:
                        DateTime.parse(sessionResponseBody['session']['last_active_at']),
                  );
                  
                    await hiveService.addBoxes([sessionData], "SessionBox");
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Error : ${completeLoginResponse.statusCode} - ${responseBody["detail"]} '),
                      ),
                    );
                  }
                }
              },
              onError: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OtpVerificationErrorScreen(),
                  ),
                );
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
    setState(() {
      _isLoading = false; // Stop loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161622), // Set your primary color here
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Shows loading indicator
      ):SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [

              Center(
                child: Column(
                  children: [
                    const Image(image: AssetImage('assets/icons/logo.png') ,height:100,width: 100,),

                      const SizedBox(height: 40.0),
                      const Text(
                        'Welcome to J.A.R.V.I.S',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontFamily: 'Malgun Gothic',
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(height: 40.0),
                      CustomTextField(
                        hintText: 'Email address',
                        icon: Icons.email,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        hintText: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 20.0),
                      CustomButton(
                        text: 'Continue',
                        onPressed: () => handleLogin(context),
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmailSignUp()),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'Sign up',
                              style: TextStyle(color: AppColor.blueColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassword(
                                      email: emailController.text,
                                    )),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: AppColor.blueColor),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'or',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10.0),
                          Container(
                            height: 1,
                            width: 100,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          print("continue with google");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding: const EdgeInsets.all(10.0),
                          width: 364,
                          height: 71,
                          decoration: BoxDecoration(
                            color: AppColor.containerColor,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                color: AppColor.primaryColor, width: 2.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/google.png',
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                'Continue with google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontFamily: 'Malgun Gothic',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("continue with apple");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding: const EdgeInsets.all(10.0),
                          width: 364,
                          height: 71,
                          decoration: BoxDecoration(
                            color: AppColor.containerColor,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                color: AppColor.primaryColor, width: 2.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/apple.png',
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                'Continue with apple',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontFamily: 'Malgun Gothic',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("continue with Microsoft");
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding: const EdgeInsets.all(10.0),
                          width: 364,
                          height: 71,
                          decoration: BoxDecoration(
                            color: AppColor.containerColor,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                color: AppColor.primaryColor, width: 2.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/microsoft.png',
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                'Continue with Microsoft',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontFamily: 'Malgun Gothic',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}