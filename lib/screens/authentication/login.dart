import 'dart:convert';
import 'package:jarvis/screens/authentication/signup.dart';
import 'package:flutter/material.dart';
import "package:jarvis/widgets/button.dart";
import 'package:http/http.dart' as http;
import 'package:jarvis/cache/hive.dart'; // Import your Hive service
import 'package:jarvis/cache/sessions_model.dart'; // Import your session model
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/main.dart';
import 'package:jarvis/widgets/input_fields.dart';
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

// class WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0,
//         size.height * 0.1); // Start the curve at 30% of the container's height

//     // First curve
//     var firstControlPoint = Offset(size.width * 0.15, size.height * 0.01);
//     var firstEndPoint = Offset(size.width * 0.4, size.height * 0.1);
//     path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
//         firstEndPoint.dx, firstEndPoint.dy);

//     // Second curve
//     var secondControlPoint = Offset(size.width * 0.75, size.height * 0.2);
//     var secondEndPoint = Offset(size.width, size.height * 0.1);
//     path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
//         secondEndPoint.dx, secondEndPoint.dy);

//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

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
          body: Container(
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  left: 0,
                  top: 117,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 267,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/267x150"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          'stapes.ai',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    left: 0,
                    top: 339,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Color(0xFF0084FF),
                                      fontSize: 15,
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          CustomButton(
                            text: 'Login',
                            onPressed: () {
                              handleLogin(context);
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmailSignUp(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: AppColor.blueColor,
                                    fontSize: 16,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppColor.DividerColor,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: AppColor.DividerColor,
                                      fontSize: 16,
                                      fontFamily: 'Ubuntu',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppColor.DividerColor,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
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
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF34373F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x26000000),
                                        blurRadius: 5.40,
                                        offset: Offset(1, 3),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: const Center(
                                    child: Image(
                                      image:
                                          AssetImage('assets/icons/google.png'),
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
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF34373F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x26000000),
                                        blurRadius: 5.40,
                                        offset: Offset(1, 3),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: const Center(
                                    child: Image(
                                      image: AssetImage(
                                          'assets/icons/microsoft.png'),
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
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF34373F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x26000000),
                                        blurRadius: 5.40,
                                        offset: Offset(1, 3),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: const Center(
                                    child: Image(
                                      image:
                                          AssetImage('assets/icons/apple.png'),
                                      height: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
