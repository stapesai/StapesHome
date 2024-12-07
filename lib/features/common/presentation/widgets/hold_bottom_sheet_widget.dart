// Dart
import 'package:flutter/material.dart';

class HoldBottomSheetWidget extends StatelessWidget {
  final List<BottomSheetOption> options;

  const HoldBottomSheetWidget({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: options
            .map((option) => ListTile(
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

  BottomSheetOption({required this.label, required this.onTap});
}
