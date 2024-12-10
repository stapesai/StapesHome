// Dart
import 'package:flutter/material.dart';

class HoldBottomSheetWidget extends StatelessWidget {
  final List<BottomSheetOption> options;

  const HoldBottomSheetWidget({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: options
            .map((option) => ListTile(
                  leading: Icon(option.icon),
                  title: Text(option.label),
                  onTap: option.onTap,
                ))
            .toList(),
      ),
    );
  }
}

class BottomSheetOption {
  final String label;
  final VoidCallback onTap;
  final IconData icon;

  BottomSheetOption({
    required this.label,
    required this.onTap,
    required this.icon,
  });
}
