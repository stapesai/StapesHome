import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:stapes_home/core/common/widgets/input/textfield.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/features/floors/domain/usecases/create_floor_usecase.dart';
import 'package:stapes_home/features/floors/presentation/bloc/create_floor_bloc.dart';
import 'package:stapes_home/features/floors/presentation/bloc/create_floor_event.dart';
import 'package:stapes_home/features/floors/presentation/bloc/create_floor_state.dart';
import 'package:stapes_home/service_locator.dart';

class CreateFloorPage extends StatefulWidget {
  const CreateFloorPage({super.key});

  @override
  createState() => _CreateFloorPageState();
}

class _CreateFloorPageState extends State<CreateFloorPage> {
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  static const _pageTitle = Text(
    'Create a new floor',
    style: TextStyle(
      color: AppColor.whiteColor,
      fontSize: AppFontSizes.pageHeading,
      fontFamily: 'Ubuntu',
      fontWeight: FontWeight.w700,
    ),
  );

  static const _pageSubtitle = Text(
    'Enter the details for creating a new floor.',
    style: TextStyle(
      color: AppColor.whiteColor,
      fontSize: AppFontSizes.pageSubHeading,
      fontFamily: 'Ubuntu',
      fontWeight: FontWeight.w400,
    ),
  );

  @override
  void dispose() {
    aliasController.dispose();
    levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider(
      create: (context) => CreateFloorBloc(
        createFloorUseCase: serviceLocator<CreateFloorUseCase>(),
      ),
      child: BlocListener<CreateFloorBloc, CreateFloorState>(
        listener: (context, state) {
          if (state is CreateFloorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColor.errorColor,
                content: Text(state.message),
              ),
            );
          } else if (state is CreateFloorSuccess) {
            Navigator.pop(context);
          }
        },
        child: KeyboardDismissOnTap(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  _pageTitle,
                  SizedBox(height: screenSize.height * 0.02),
                  _pageSubtitle,
                  SizedBox(height: screenSize.height * 0.04),
                  CustomTextField(
                    hintText: 'Floor Name',
                    controller: aliasController,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  CustomTextField(
                    hintText: 'Floor Level',
                    controller: levelController,
                    keyboardType: TextInputType.number,
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      bottom: keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.01 : screenSize.height * 0.1,
                    ),
                    child: Center(
                      child: BlocBuilder<CreateFloorBloc, CreateFloorState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: 'Create',
                            isLoading: state is CreateFloorLoading,
                            onPressed: () {
                              context.read<CreateFloorBloc>().add(
                                    CreateFloorSubmitted(
                                      alias: aliasController.text,
                                      level: levelController.text,
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
    );
  }
}
