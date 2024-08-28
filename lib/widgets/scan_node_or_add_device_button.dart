import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_border/dotted_border.dart';

class ScanNodeorAddDeviceButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String icon;

  const ScanNodeorAddDeviceButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(30),
        color: Color(0xFFFF9F1C),
        strokeWidth: 1,
        dashPattern: const [10, 10],
        child: Container(
          // decoration: BoxDecoration(
            // color: Color.fromARGB(1, 29, 29, 29),
            // borderRadius: BorderRadius.circular(30),
            // boxShadow: [
            //   BoxShadow(
            //     color: Color.fromARGB(62, 255, 0, 0),
            //     blurRadius: 3.80,
            //     offset: Offset(4, 9),
            //     spreadRadius: 0,
            //   )
            // ],
          // ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(1, 29, 29, 29),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: onPressed,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(icon, width: 30, height: 30),
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 16,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w700,
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
