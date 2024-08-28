import 'package:flutter/material.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/colors.dart';

class FanComponent extends StatefulWidget {
  final Device device;

  const FanComponent({Key? key, required this.device}) : super(key: key);

  @override
  _FanComponentState createState() => _FanComponentState();
}

class _FanComponentState extends State<FanComponent> {
  bool isOn = false;
  int speed = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialState();
  }

  Future<void> _fetchInitialState() async {
    // TODO: Implement API call to fetch initial state
    // For now, we'll assume it's off
    setState(() {
      isOn = false;
      speed = 0;
    });
  }

  Future<void> toggleFan() async {
    setState(() {
      isOn = !isOn;
      speed = isOn ? 1 : 0;
    });
  }

  Future<void> changeSpeed(int newSpeed) async {
    if (!isOn) return;
    setState(() {
      speed = newSpeed;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFF1D1D1D),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isOn ? Color(0xCCFF9F1C) : Colors.transparent,
            blurRadius: 16,
            offset: Offset(8, 7),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: toggleFan,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn ? Color(0xFFFFA52D) : Colors.white.withOpacity(0.5),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/devices/fan.svg',
                  width: 63,
                  height: 63,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.device.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isOn) ...[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSpeedButton('-', () => changeSpeed(speed > 1 ? speed - 1 : 1)),
                SizedBox(width: 10),
                Text(
                  speed.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(width: 10),
                _buildSpeedButton('+', () => changeSpeed(speed < 3 ? speed + 1 : 3)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpeedButton(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
