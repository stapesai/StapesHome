import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScanNodeorAddDeviceButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String icon;

  const ScanNodeorAddDeviceButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(1, 29, 29, 29),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.98, color: Color(0xFFFF9F1C)),
            borderRadius: BorderRadius.circular(29.45),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 30, height: 30),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 15.71,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
