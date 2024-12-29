import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_padding.dart';

class CustomGradientAndPaddingContainer extends StatelessWidget {
  final Widget child;

  const CustomGradientAndPaddingContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Experimented - We can't directly wrap the MaterialApp with this Container because it will cause the app to rebuiid when page is rebuit after any event.
    return Container(
      clipBehavior: Clip.antiAlias,
      // color: Colors.red,
      // padding: AppPadding.pagePadding(context),
      decoration: ShapeDecoration(
        gradient: AppColor.backgroundColorgradient,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: child,
    );
  }
}
