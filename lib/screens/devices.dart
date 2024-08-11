import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Control',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C2B),
        primaryColor: Colors.orange,
      ),
      home: const DeviceScreen(),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  int activeFloor = 1;
  int activeRoom = 1;

  void setActiveFloor(int floor) {
    setState(() {
      activeFloor = floor;
    });
  }

  void setActiveRoom(int room) {
    setState(() {
      activeRoom = room;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Row(
                children: [
                  Text(
                    'Floors',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  AddCircleButton(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FloorRoomButton(
                      label: 'Floor 1',
                      isActive: activeFloor == 1,
                      onTap: () => setActiveFloor(1)),
                  const SizedBox(width: 10),
                  FloorRoomButton(
                      label: 'Floor 2',
                      isActive: activeFloor == 2,
                      onTap: () => setActiveFloor(2)),
                ],
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Text(
                    'Rooms',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  AddCircleButton(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  FloorRoomButton(
                      label: 'Room 1',
                      isActive: activeRoom == 1,
                      onTap: () => setActiveRoom(1)),
                  const SizedBox(width: 10),
                  FloorRoomButton(
                      label: 'Room 2',
                      isActive: activeRoom == 2,
                      onTap: () => setActiveRoom(2)),
                  const SizedBox(width: 10),
                  FloorRoomButton(
                      label: 'Room 3',
                      isActive: activeRoom == 3,
                      onTap: () => setActiveRoom(3)),
                ],
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C2B),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline), label: 'Devices'),
          BottomNavigationBarItem(icon: Icon(Icons.memory), label: 'Nodes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 1,
      ),
    );
  }
}

class AddCircleButton extends StatelessWidget {
  const AddCircleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF3F3F63),
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 14),
    );
  }
}

class FloorRoomButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FloorRoomButton(
      {super.key,
      required this.label,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
          ],
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
              color: isActive
                  ? Colors.orange.shade200
                  : Colors.black.withOpacity(0.5),
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
                  color: Colors.white,
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
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: Container(
        width: 396,
        height: 56,
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
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16)));
    final dashPath = Path();
    final pathMetrics = path.computeMetrics();
    for (var pathMetric in pathMetrics) {
      final double length = pathMetric.length;
      double distance = 0.0;
      while (distance < length) {
        final double nextDistance = distance + dashWidth;
        dashPath.addPath(
            pathMetric.extractPath(distance, nextDistance), Offset.zero);
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
