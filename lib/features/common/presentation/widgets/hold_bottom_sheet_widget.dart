// File: lib/features/common/presentation/widgets/hold_bottom_sheet_widget.dart

import 'package:flutter/material.dart';

class HoldBottomSheetWidget extends StatelessWidget {
  final List<BottomSheetOption> options;

  const HoldBottomSheetWidget({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: fix this, but dont apply anything here this should be done in the parent widget
      // width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Wrap(
        children: options
            .map((option) => ListTile(
                  leading: Icon(option.icon),
                  title: Text(option.label),
                  onTap: () {
                    Navigator.pop(context);
                    option.onTap();
                  },
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
