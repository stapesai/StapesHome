// import 'package:flutter/material.dart';

class Floor {
  final String id;
  final int level;
  final String alias;

  Floor({required this.id, required this.level, required this.alias});

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'],
      level: json['level'],
      alias: json['alias'],
    );
  }
}

class Room {
  final String id;
  final String floorId;
  final String name;
  final String type;

  Room({required this.id, required this.floorId, required this.name, required this.type});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      floorId: json['floor_id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class Node {
  final String roomId;
  final String name;
  final String hardwareChip;
  final String hardwareVersion;
  final String hardwareMacAddress;
  final String firmwareVersion;
  final String id;
  final int numEntities;

  Node({
    required this.roomId,
    required this.name,
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.hardwareMacAddress,
    required this.firmwareVersion,
    required this.id,
    required this.numEntities,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      roomId: json['room_id'],
      name: json['name'],
      hardwareChip: json['hardware_chip'],
      hardwareVersion: json['hardware_version'],
      hardwareMacAddress: json['hardware_mac_address'],
      firmwareVersion: json['firmware_version'],
      id: json['id'],
      numEntities: json['num_entities'],
    );
  }
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

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      nodeId: json['node_id'],
      name: json['name'],
      type: json['type'],
      channelId: json['channel_id'],
      id: json['id'],
    );
  }
}

class NodeStatusUpdate {
  final String nodeId;
  final String isOnline;
  final DateTime lastSeen;

  NodeStatusUpdate({
    required this.nodeId,
    required this.isOnline,
    required this.lastSeen,
  });

  factory NodeStatusUpdate.fromJson(Map<String, dynamic> json) {
    return NodeStatusUpdate(
      nodeId: json['node_id'],
      isOnline: json['is_online'],
      lastSeen: DateTime.parse(json['last_seen']),
    );
  }
}

class DeviceStatusUpdate {
  final String deviceId;
  final String state;

  DeviceStatusUpdate({
    required this.deviceId,
    required this.state,
  });

  factory DeviceStatusUpdate.fromJson(Map<String, dynamic> json) {
    return DeviceStatusUpdate(
      deviceId: json['entity_id'],
      state: json['state'],
    );
  }
}
