import 'package:flutter/material.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';

class DevFloorRoomSelPage extends StatefulWidget {
  const DevFloorRoomSelPage({super.key});

  @override
  State<DevFloorRoomSelPage> createState() => _DevFloorRoomSelPageState();
}

class _DevFloorRoomSelPageState extends State<DevFloorRoomSelPage> {
  final List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString()}: $message');
      if (_logs.length > 10) {
        _logs.removeAt(0); // Keep only last 10 logs
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Dev Floor Room Selector', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            SizedBox(
              // height: 100, // Adjust height as needed
              child: FloorRoomSelector(
                onFloorSelected: (floorId) {
                  _addLog('Floor selected: $floorId');
                },
                onRoomSelected: (roomId) {
                  _addLog('Room selected: $roomId');
                },
              ),
            ),
            const SizedBox(height: 40),
            // Debug Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Debug Log:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _logs[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
