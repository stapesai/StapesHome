// File: lib/widgets/hold_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';

class HoldBottomSheet {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  HoldBottomSheet({required this.icon, required this.text, required this.onTap});
}

class CustomBottomSheet extends StatelessWidget {
  final List<HoldBottomSheet> options;

  const CustomBottomSheet({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.darkBackgroundColor,
        // color: Colors.red,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),

      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),

      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.whiteColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ...options.map((option) => _buildOptionTile(context, option)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, HoldBottomSheet option) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        option.onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Icon(option.icon, color: AppColor.whiteColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.text,
                style: const TextStyle(
                  color: AppColor.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomBottomSheet(BuildContext context, List<HoldBottomSheet> options) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.darkBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: CustomBottomSheet(options: options),
          ),
        ),
      );
    },
  );
}
