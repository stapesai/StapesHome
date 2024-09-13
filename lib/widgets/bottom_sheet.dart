import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';

class BottomSheetOption {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  BottomSheetOption({
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

void showOptionsBottomSheet({
  required BuildContext context,
  required String itemName,
  required List<BottomSheetOption> options,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
      final fontSize = isTablet ? 22.0 : 18.0;

      return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.4,
        snap: true,
        snapSizes: const [0.3, 0.4],
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColor.instructionPanelColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Options for $itemName',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: fontSize + 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ...options
                    .map((option) => _buildOptionTile(
                          icon: option.icon,
                          title: option.text,
                          onTap: () {
                            Navigator.pop(context);
                            option.onTap();
                          },
                          fontSize: fontSize,
                          color: option.color,
                        ))
                    .toList(),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildOptionTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  required double fontSize,
  required Color color,
}) {
  return ListTile(
    leading: Icon(icon, color: color, size: fontSize * 1.5),
    title: Text(title, style: TextStyle(fontSize: fontSize, color: color)),
    onTap: onTap,
  );
}
