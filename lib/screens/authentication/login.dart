import 'dart:convert';
import 'package:flutter/material.dart';
import "package:jarvis/widgets/button.dart";
import 'package:http/http.dart' as http;
import 'package:jarvis/cache/hive.dart'; // Import your Hive service
import 'package:jarvis/cache/sessions_model.dart'; // Import your session model
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/main.dart';
import 'package:jarvis/widgets/text_field.dart';
// import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'error_screens/otp_verify_error.dart';
import 'otp_verify.dart'; // Import the OTP Verification screen
// import 'email_signup.dart'; // Import the EmailSignUp screen
// import 'reset_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  createState() => _LoginScreenState();
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0,
        size.height * 0.1); // Start the curve at 30% of the container's height

    // First curve
    var firstControlPoint = Offset(size.width * 0.15, size.height * 0.01);
    var firstEndPoint = Offset(size.width * 0.4, size.height * 0.1);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    // Second curve
    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.2);
    var secondEndPoint = Offset(size.width, size.height * 0.1);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
                  var sessionResponseBody =
                      json.decode(completeLoginResponse.body);
                  // print("SessionId:"+sessionResponseBody['session']['session_id']);
                  // print("Userid:"+sessionResponseBody['session']['user_id']);
                  // print( "CREATE AT: ${DateTime.parse(sessionResponseBody['session']['created_at'])}" );
                  // print("LaST TIME: ${DateTime.parse(sessionResponseBody['session']['last_active_at'])}");
                  var sessionData = SessionsModel(
                    sessionId: sessionResponseBody['session']['session_id'],
                    userId: sessionResponseBody['session']['user_id'],
                    createdAt: DateTime.parse(
                        sessionResponseBody['session']['created_at']),
                    lastActiveAt: DateTime.parse(
                        sessionResponseBody['session']['last_active_at']),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with image and wave
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background image
                Container(
                  height: MediaQuery.of(context).size.height * 0.4 - 1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '/Users/swarnimburnwal/Desktop/JarvisHome-FrontEnd/assets/images/login.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Wave clipper
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.2 - 40,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: const [
                            AppColor.primaryColor,
                            AppColor.secondaryColor
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                // Top icons
                Positioned(
                  top: 40,
                  left: 20,
                  child: LogoutButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  CustomTextField(
                      hintText: "Enter your email",
                      controller: emailController,
                      icon: Icons.email),
                  const SizedBox(height: 20),
                  CustomTextField(
                      hintText: "Enter you password",
                      obscureText: true,
                      controller: passwordController,
                      icon: Icons.lock),
                  const SizedBox(height: 20),
                  // Forgot password
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ResetPasswordScreen(),
                      //   ),
                      // );
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColor.themecolor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  // Login button
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      handleLogin(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  // sign up
                  GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const EmailSignUpScreen(),
                        //   ),
                        // );
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white, // First part color
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: "Sign up",
                                style: TextStyle(
                                  color: AppColor.themecolor, // Second part color
                                  fontSize: 15,
                                  fontWeight: FontWeight
                                      .bold, // Optional, to make it stand out
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  // divider with or
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColor.primaryColorLight,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "or",
                        style: TextStyle(
                          color: AppColor.primaryColorLight,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColor.primaryColorLight,
                        ),
                      ),
                    ],
                  ),
                  // sso's
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google
                      GestureDetector(
                        onTap: () {
                          // handleGoogleLogin(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Image(
                              image: AssetImage(
                                  '/Users/swarnimburnwal/Desktop/JarvisHome-FrontEnd/assets/icons/google.png'),
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Facebook
                      GestureDetector(
                        onTap: () {
                          // handleFacebookLogin(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Image(
                              image: AssetImage(
                                  '/Users/swarnimburnwal/Desktop/JarvisHome-FrontEnd/assets/icons/microsoft.png'),
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Facebook
                      GestureDetector(
                        onTap: () {
                          // handleFacebookLogin(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Image(
                              image: AssetImage(
                                  '/Users/swarnimburnwal/Desktop/JarvisHome-FrontEnd/assets/icons/apple.png'),
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
