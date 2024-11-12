import 'dart:convert';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/common/widgets/input/password.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/presentation/auth/pages/signup_details_form.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget nextScreen;
  final String email;
  final String transactionId;
  final TextEditingController passWord = TextEditingController();
  final TextEditingController confirmPassWord = TextEditingController();

  CreatePasswordScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.email,
    required this.transactionId,
    required this.nextScreen,
  });

  @override
  createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> checkPassword(String password, BuildContext context, Widget nextScreen) async {
    setState(() {
      _isLoading = true;
    });
    var response = await http.post(
      AuthRoutes.checkPassword(password),
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextScreen,
          ),
        );
      }
    } else {
      var responseBody = json.decode(response.body);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${responseBody['detail']}'),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
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
                  child: CircularProgressIndicator(color: AppColor.whiteColor),
                )
              : SafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: AppPadding.pagePadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenSize.height * 0.05),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: AppFontSizes.pageHeading,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            Text(
                              widget.subtitle,
                              style: const TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: AppFontSizes.pageSubHeading,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.04),
                            CustomPasswordTextField(
                              hintText: 'Password',
                              controller: widget.passWord,
                              icon: Icons.remove_red_eye_outlined,
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            CustomPasswordTextField(
                              hintText: 'Confirm Password',
                              controller: widget.confirmPassWord,
                              icon: Icons.remove_red_eye_outlined,
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
                                  text: "Continue",
                                  onPressed: () {
                                    if (widget.passWord.text == widget.confirmPassWord.text) {
                                      checkPassword(
                                        widget.passWord.text,
                                        context,
                                        SignupForm(
                                          password: widget.passWord.text,
                                          transaction_id: widget.transactionId,
                                          email: widget.email,
                                        ),
                                      );
                                    } else {
                                      _showErrorMessage('Passwords do not match');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_errorMessage != null)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: keyboardHeight > 0 ? keyboardHeight : screenSize.height * 0.05,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            color: Colors.red,
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
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
