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

class Node {
  final String roomId;
  final String name;
  final String hardwareChip;
  final double hardwareVersion;
  final String hardwareMacAddress;
  final String firmwareVersion;
  final String id;

  Node({
    required this.roomId,
    required this.name,
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.hardwareMacAddress,
    required this.firmwareVersion,
    required this.id,
  });
}

class Device {
  final String nodeId;
  final String name;
  final String type;
  final int channelId;
  final String id;

  Device({
    required this.nodeId,
    required this.name,
    required this.type,
    required this.channelId,
    required this.id,
  });
}
