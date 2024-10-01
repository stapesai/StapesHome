// File: lib/presentation/pages/auth/signup/signup_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/font_sizes.dart';
import '../../../../core/constants/padding.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../bloc/auth/auth_bloc.dart';

class SignupDetailsPage extends StatefulWidget {
  final String transactionId;
  final String email;

  const SignupDetailsPage({
    Key? key,
    required this.transactionId,
    required this.email,
  }) : super(key: key);

  @override
  _SignupDetailsPageState createState() => _SignupDetailsPageState();
}

class _SignupDetailsPageState extends State<SignupDetailsPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      builder: (context, state) {
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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppPadding.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),
                      Text(
                        'Complete Signup',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Text(
                        'Please enter your details to complete the signup process.',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageSubHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.04),
                      CustomTextField(
                        hintText: 'First Name',
                        controller: firstNameController,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Last Name',
                        controller: lastNameController,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Password',
                        controller: passwordController,
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Date of Birth (YYYY-MM-DD)',
                        controller: dobController,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Gender',
                        controller: genderController,
                      ),
                      SizedBox(height: 40),
                      CustomButton(
                        text: 'Complete Signup',
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  CompleteSignupEvent(
                                    transactionId: widget.transactionId,
                                    password: passwordController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    dob: dobController.text,
                                    gender: genderController.text,
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
