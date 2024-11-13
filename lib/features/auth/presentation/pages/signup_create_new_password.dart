import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/common/widgets/input/password.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class SignUpCreateNewPasswordScreen extends StatefulWidget {
  final String email;
  final String transactionId;

  const SignUpCreateNewPasswordScreen({
    super.key,
    required this.email,
    required this.transactionId,
  });

  @override
  createState() => _SignUpCreateNewPasswordScreenState();
}

class _SignUpCreateNewPasswordScreenState extends State<SignUpCreateNewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
          body: SafeArea(
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
                          'Create Password',
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
                        'Please create a strong password.',
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
                        controller: passwordController,
                        icon: Icons.remove_red_eye_outlined,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      CustomPasswordTextField(
                        hintText: 'Confirm Password',
                        controller: confirmPasswordController,
                        icon: Icons.remove_red_eye_outlined,
                      ),
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: EdgeInsets.only(
                          bottom:
                              keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.02 : screenSize.height * 0.1,
                        ),
                        child: Center(
                          child: CustomButton(
                            text: "Continue",
                            onPressed: () {
                              if (passwordController.text == confirmPasswordController.text) {
                                checkPassword(
                                  passwordController.text,
                                  context,
                                  SignupForm(
                                    password: passwordController.text,
                                    transaction_id: widget.transactionId,
                                    email: widget.email,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // if (_errorMessage != null)
                //   Positioned(
                //     left: 0,
                //     right: 0,
                //     bottom: keyboardHeight > 0 ? keyboardHeight : screenSize.height * 0.05,
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                //       color: Colors.red,
                //       child: Text(
                //         _errorMessage!,
                //         style: const TextStyle(color: Colors.white),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
