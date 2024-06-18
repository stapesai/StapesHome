import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SetupHomeScreen(),
    );
  }
}

class SetupHomeScreen extends StatefulWidget {
  @override
  _SetupHomeScreenState createState() => _SetupHomeScreenState();
}

class _SetupHomeScreenState extends State<SetupHomeScreen> {
  int _numberOfFloors = 1;
  List<int> _roomsPerFloor = [1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.home,
                    size: 80,
                    color: Color(0xFFFFA500),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Lets setup your home',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Select number of Floors',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFA500)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFFA500)),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              dropdownColor: Colors.black,
              value: _numberOfFloors,
              items: [1, 2, 3, 4, 5].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString(), style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _numberOfFloors = value!;
                  _roomsPerFloor = List.generate(_numberOfFloors, (index) => 1);
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Select number of Rooms in each floor',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
            Column(
              children: List.generate(_numberOfFloors, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF333333),
                      labelText: 'Floor ${index + 1}',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF333333)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF333333)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    dropdownColor: Color(0xFF333333),
                    value: _roomsPerFloor[index],
                    items: [1, 2, 3, 4, 5].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString(), style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _roomsPerFloor[index] = value!;
                      });
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  // primary: Color(0xFFA52A2A),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
