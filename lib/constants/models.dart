import 'package:flutter/material.dart';

class Floor {
  final String id;
  final String name;

  Floor({required this.id, required this.name});
}

class Room {
  final String id;
  final String name;

  Room({required this.id, required this.name});
}

class Device {
  final String id;
  final String name;
  final IconData icon;
  final bool isActive;
  final bool hasSlider;
  final double sliderValue;

  Device({
    required this.id,
    required this.name,
    required this.icon,
    this.isActive = false,
    this.hasSlider = false,
    this.sliderValue = 0.0,
  });
}