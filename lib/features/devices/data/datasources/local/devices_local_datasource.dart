// devices_local_datasource.dart

import 'package:sqflite/sqflite.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/models/device_model.dart';

abstract class DevicesLocalDataSource {
  Future<List<DeviceModel>> getAllDevices();
  Future<List<DeviceModel>> getDevicesByRoomId(String roomId);
  Future<List<DeviceModel>> getDevicesByNodeId(String nodeId);
  Future<DeviceModel> createDevice(DeviceModel device);
  Future<DeviceModel> updateDevice(String id, DeviceModel device);
  Future<void> deleteDevice(String id);
  Future<void> updateCachedDevices(List<DeviceModel> devices);
}

class DevicesLocalDataSourceImpl implements DevicesLocalDataSource {
  final SQLiteService sqliteService;

  DevicesLocalDataSourceImpl({required this.sqliteService});

  @override
  Future<List<DeviceModel>> getAllDevices() async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query('devices');
      return List.generate(maps.length, (i) {
        try {
          return DeviceModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse device data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching devices: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching devices: ${e.toString()}');
    }
  }

  @override
  Future<List<DeviceModel>> getDevicesByRoomId(String roomId) async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'devices',
        where: 'room_id = ?',
        whereArgs: [roomId],
      );
      return List.generate(maps.length, (i) {
        try {
          return DeviceModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse device data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching devices: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching devices: ${e.toString()}');
    }
  }

  @override
  Future<List<DeviceModel>> getDevicesByNodeId(String nodeId) async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'devices',
        where: 'node_id = ?',
        whereArgs: [nodeId],
      );
      return List.generate(maps.length, (i) {
        try {
          return DeviceModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse device data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching devices: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching devices: ${e.toString()}');
    }
  }

  @override
  Future<DeviceModel> createDevice(DeviceModel device) async {
    try {
      if (device.id!.isEmpty) {
        throw ValidationException('Device ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingDevice = await db.query(
        'devices',
        where: 'id = ?',
        whereArgs: [device.id],
      );

      if (existingDevice.isNotEmpty) {
        throw SQLiteException('Device with ID ${device.id} already exists');
      }

      final result = await db.insert('devices', {
        'id': device.id,
        'node_id': device.nodeId,
        'name': device.name,
        'type': device.type,
        'channel_id': device.channelId,
      });

      if (result == 0) {
        throw SQLiteException('Failed to insert device');
      }

      return device;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while creating device: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while creating device: ${e.toString()}');
    }
  }

  @override
  Future<DeviceModel> updateDevice(String id, DeviceModel device) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Device ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingDevice = await db.query(
        'devices',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (existingDevice.isEmpty) {
        throw NotFoundException('Device with ID $id not found');
      }

      final rowsAffected = await db.update(
        'devices',
        {
          'node_id': device.nodeId,
          'name': device.name,
          'type': device.type,
          'channel_id': device.channelId,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw SQLiteException('Failed to update device');
      }

      return device;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating device: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while updating device: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDevice(String id) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Device ID cannot be empty');
      }

      final db = await sqliteService.database;
      final rowsAffected = await db.delete(
        'devices',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw NotFoundException('Device with ID $id not found');
      }
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while deleting device: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while deleting device: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCachedDevices(List<DeviceModel> devices) async {
    try {
      final db = await sqliteService.database;
      await db.transaction((txn) async {
        // Clear existing devices
        await txn.delete('devices');

        // Insert new devices
        for (var device in devices) {
          if (device.id!.isEmpty) {
            throw ValidationException('Device ID cannot be empty');
          }

          await txn.insert('devices', {
            'id': device.id,
            'node_id': device.nodeId,
            'name': device.name,
            'type': device.type,
            'channel_id': device.channelId,
          });
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating cached devices: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while updating cached devices: ${e.toString()}');
    }
  }
}
