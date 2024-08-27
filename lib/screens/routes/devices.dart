import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/utils/hive.dart';
import 'package:StapesHome/screens/views/devices/add_new_device.dart';
import 'package:StapesHome/screens/views/common/floor_room_selector.dart';

class DeviceScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const DeviceScreen({
    super.key,
    required this.sessionId,
    required this.userId,
  });

  @override
  createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  String activeFloorId = '';
  int activeRoomIndex = -1;
  final HiveService hiveService = HiveService();

  @override
  void initState() {
    super.initState();
  }

  void handleFloorSelected(String floorId) {
    setState(() {
      activeFloorId = floorId;
    });
  }

  void handleRoomSelected(int roomIndex) {
    setState(() {
      activeRoomIndex = roomIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Adjust this color to match your theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Devices',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 24),
              FloorRoomSelector(
                context: context,
                onFloorSelected: handleFloorSelected,
                onRoomSelected: handleRoomSelected,
                sessionId: widget.sessionId,
                userId: widget.userId,
                activeFloorId: activeFloorId,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: const [
                    DeviceButton(label: 'Bedroom Light'),
                    DeviceButton(label: 'Bedroom Light'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: AddDeviceButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceButton extends StatefulWidget {
  final String label;

  const DeviceButton({super.key, required this.label});

  @override
  createState() => _DeviceButtonState();
}

class _DeviceButtonState extends State<DeviceButton> {
  bool isActive = false;

  void toggleButton() {
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleButton,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF343450), Color(0xFF161622)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.orange.shade200 : Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 6),
              blurRadius: 10,
              spreadRadius: -3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isActive
                      ? [Colors.orange.shade700, Colors.orange.shade400]
                      : [const Color(0xFF2A2A40), const Color(0xFF1C1C2B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppColor.whiteColor,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class AddDeviceButton extends StatelessWidget {
  const AddDeviceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNewDevice()),
        );
      },
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          width: 396,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C2B),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(4, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.orange, size: 24),
                SizedBox(height: 4),
                Text(
                  'Add device',
                  style: TextStyle(color: Colors.orange, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)));
    final dashPath = Path();
    final pathMetrics = path.computeMetrics();
    for (var pathMetric in pathMetrics) {
      final double length = pathMetric.length;
      double distance = 0.0;
      while (distance < length) {
        final double nextDistance = distance + dashWidth;
        dashPath.addPath(pathMetric.extractPath(distance, nextDistance), Offset.zero);
        distance = nextDistance + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
