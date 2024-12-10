import 'package:sqflite/sqflite.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/models/fav_devices_model.dart';

abstract class FavDevicesLocalDataSource {
  Future<List<FavDevicesModel>> getFavDevices();
  Future<FavDevicesModel> createFavDevice(FavDevicesModel device);
  Future<void> deleteFavDevice(String entityId);
  Future<void> updateCachedFavDevices(List<FavDevicesModel> devices);
}

class FavDevicesLocalDataSourceImpl implements FavDevicesLocalDataSource {
  final SQLiteService sqliteService;

  FavDevicesLocalDataSourceImpl({required this.sqliteService});

  @override
  Future<List<FavDevicesModel>> getFavDevices() async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query('favourite_devices');

      return List.generate(maps.length, (i) {
        try {
          return FavDevicesModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse favorite device data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching favorite devices: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching favorite devices: ${e.toString()}');
    }
  }

  @override
  Future<FavDevicesModel> createFavDevice(FavDevicesModel device) async {
    try {
      if (device.entityId.isEmpty) {
        throw ValidationException('Entity ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingDevice = await db.query(
        'favourite_devices',
        where: 'entity_id = ?',
        whereArgs: [device.entityId],
      );

      if (existingDevice.isNotEmpty) {
        throw SQLiteException('Device with ID ${device.entityId} already exists');
      }

      final result = await db.insert('favourite_devices', device.toMap());

      if (result == 0) {
        throw SQLiteException('Failed to insert favorite device');
      }

      return device;
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while creating favorite device: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFavDevice(String entityId) async {
    try {
      if (entityId.isEmpty) {
        throw ValidationException('Entity ID cannot be empty');
      }

      final db = await sqliteService.database;
      final rowsAffected = await db.delete(
        'favourite_devices',
        where: 'entity_id = ?',
        whereArgs: [entityId],
      );

      if (rowsAffected == 0) {
        throw NotFoundException('Favorite device with ID $entityId not found');
      }
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while deleting favorite device: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCachedFavDevices(List<FavDevicesModel> devices) async {
    try {
      final db = await sqliteService.database;
      await db.transaction((txn) async {
        // Clear existing devices
        await txn.delete('favourite_devices');

        // Insert new devices
        for (var device in devices) {
          if (device.entityId.isEmpty) {
            throw ValidationException('Entity ID cannot be empty');
          }

          await txn.insert('favourite_devices', device.toMap());
        }
      });
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while updating cached devices: ${e.toString()}');
    }
  }
}
