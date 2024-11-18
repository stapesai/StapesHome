import 'package:sqflite/sqflite.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/models/floor_model.dart';

abstract class FloorsLocalDataSource {
  // Gets all floors from the local database
  Future<List<FloorModel>> getFloors();

  // Creates a new floor in the local database
  Future<FloorModel> createFloor(FloorModel floor);

  // Updates a floor in the local database by its id
  Future<FloorModel> updateFloor(String id, FloorModel floor);

  // Deletes a floor in the local database by its id
  Future<void> deleteFloor(String id);

  // Deletes all floors in the local database and caches the new ones
  Future<void> updateCachedFloors(List<FloorModel> floors);
}

class FloorsLocalDataSourceImpl implements FloorsLocalDataSource {
  final SQLiteService sqliteService;

  FloorsLocalDataSourceImpl({required this.sqliteService});

  @override
  Future<List<FloorModel>> getFloors() async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query('floors');
      return List.generate(maps.length, (i) {
        try {
          return FloorModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse floor data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching floors: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching floors: ${e.toString()}');
    }
  }

  @override
  Future<FloorModel> createFloor(FloorModel floor) async {
    try {
      if (floor.id.isEmpty) {
        throw ValidationException('Floor ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingFloor = await db.query(
        'floors',
        where: 'id = ?',
        whereArgs: [floor.id],
      );

      if (existingFloor.isNotEmpty) {
        throw SQLiteException('Floor with ID ${floor.id} already exists');
      }

      final result = await db.insert(
        'floors',
        {
          'id': floor.id,
          'level': floor.level,
          'alias': floor.alias,
        },
      );

      if (result == 0) {
        throw SQLiteException('Failed to insert floor');
      }

      return floor;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while creating floor: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while creating floor: ${e.toString()}');
    }
  }

  @override
  Future<FloorModel> updateFloor(String id, FloorModel floor) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Floor ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingFloor = await db.query(
        'floors',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (existingFloor.isEmpty) {
        throw NotFoundException('Floor with ID $id not found');
      }

      final rowsAffected = await db.update(
        'floors',
        {
          'level': floor.level,
          'alias': floor.alias,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw SQLiteException('Failed to update floor');
      }

      return floor;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating floor: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while updating floor: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFloor(String id) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Floor ID cannot be empty');
      }

      final db = await sqliteService.database;
      final rowsAffected = await db.delete(
        'floors',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw NotFoundException('Floor with ID $id not found');
      }
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while deleting floor: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while deleting floor: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCachedFloors(List<FloorModel> floors) async {
    try {
      final db = await sqliteService.database;
      await db.transaction((txn) async {
        await txn.delete('floors');
        for (var floor in floors) {
          if (floor.id.isEmpty) {
            throw ValidationException('Floor ID cannot be empty');
          }
          await txn.insert('floors', {
            'id': floor.id,
            'level': floor.level,
            'alias': floor.alias,
          });
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating cached floors: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while updating cached floors: ${e.toString()}');
    }
  }
}
