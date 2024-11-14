import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/common/widgets/input/textfield.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';
import 'package:stapes_home/features/auth/presentation/blocs/signup/signup_details_form_bloc.dart';
import 'package:stapes_home/features/auth/presentation/blocs/signup/signup_details_form_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/signup/signup_details_form_state.dart';
import 'package:stapes_home/service_locator.dart';

class SignUpDetailsFormScreen extends StatefulWidget {
  final String password;
  final String email;
  final String transactionId;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  SignUpDetailsFormScreen({
    super.key,
    required this.password,
    required this.transactionId,
    required this.email,
  });

  @override
  createState() => _SignUpDetailsFormScreenState();
}

class _SignUpDetailsFormScreenState extends State<SignUpDetailsFormScreen> {
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
        child: BlocProvider(
          create: (context) => SignUpDetailsFormBloc(
            completeSignUpUseCase: serviceLocator<CompleteSignUpUseCase>(),
          ),
          child: BlocListener<SignUpDetailsFormBloc, SignUpDetailsFormState>(
            listener: (context, state) {
              if (state is SignUpDetailsFormSuccess) {
                GoRouter.of(context).go(AppRouteConstants.devPageUserDetailsShow.routePath);
              } else if (state is SignUpDetailsFormError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.errorColor,
                  ),
                );
              }
            },
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
                        controller: widget.firstNameController,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      CustomTextField(
                        hintText: 'Last Name',
                        controller: widget.lastNameController,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      CustomTextField(
                        hintText: 'Date of Birth',
                        controller: widget.dobController,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      CustomTextField(
                        hintText: 'Gender',
                        controller: widget.genderController,
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
                          child: BlocBuilder<SignUpDetailsFormBloc, SignUpDetailsFormState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: "Sign Up",
                                isLoading: state is SignUpDetailsFormLoading,
                                onPressed: () {
                                  context.read<SignUpDetailsFormBloc>().add(
                                        SignUpDetailsFormSubmittedEvent(
                                          transactionId: widget.transactionId,
                                          user: UserModel(
                                              email: widget.email,
                                              firstName: widget.firstNameController.text,
                                              lastName: widget.lastNameController.text,
                                              dob: DateTime.parse(widget.dobController.text),
                                              gender: widget.genderController.text),
                                          password: widget.password,
                                        ),
                                      );
                                },
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
        ),
      ),
    );
  }
}
