// File: lib/features/floor_room_sel/presentation/widgets/plus_button.dart

import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        padding: EdgeInsets.all(12),
        child: Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF3E3E62),
          ),
          child: const Icon(Icons.add, color: AppColor.whiteColor, size: 14),
        ),
      ),
    );
  }
}
