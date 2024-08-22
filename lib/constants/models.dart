// import 'package:flutter/material.dart';

class Floor {
  final String id;
  final int level;
  final String alias;

  Floor({required this.id, required this.level, required this.alias});
}

class Room {
  final String id;
  final String floorId;
  final String name;
  final String type;

  Room({required this.id, required this.floorId, required this.name, required this.type});
}

// class Device {
//   final String id;
//   final String name;
//   final IconData icon;
//   final bool isActive;
//   final bool hasSlider;
//   final double sliderValue;

//   Device({
//     required this.id,
//     required this.name,
//     required this.icon,
//     this.isActive = false,
//     this.hasSlider = false,
//     this.sliderValue = 0.0,
//   });
// }
