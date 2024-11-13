import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/common/widgets/input/textfield.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class SignUpDetailsForm extends StatefulWidget {
  final String password;
  final String email;
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final String transactionId;
  SignUpDetailsForm({
    super.key,
    required this.password,
    required this.transactionId,
    required this.email,
  });

  @override
  createState() => _SignUpDetailsFormState();
}

class _SignUpDetailsFormState extends State<SignUpDetailsForm> {
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
            child: Padding(
              padding: AppPadding.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.pageHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  SizedBox(
                    width: screenSize.width * 0.9,
                    child: Text(
                      'Please enter your personal details.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.pageSubHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  CustomTextField(
                    hintText: 'First Name',
                    controller: widget.firstName,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomTextField(
                    hintText: 'Last Name',
                    controller: widget.lastName,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomTextField(
                    hintText: 'Date of Birth',
                    controller: widget.dob,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomTextField(
                    hintText: 'Gender',
                    controller: widget.gender,
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      bottom: keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.02 : screenSize.height * 0.1,
                    ),
                    child: Center(
                      child: CustomButton(
                        text: "Done",
                        onPressed: () {
                          handleConfirmSignup(
                            context,
                            widget.email,
                            widget.firstName.text,
                            widget.lastName.text,
                            widget.dob.text,
                            widget.gender.text,
                          );
                        },
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
