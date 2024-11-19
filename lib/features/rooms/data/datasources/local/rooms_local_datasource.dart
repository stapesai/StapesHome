import 'package:sqflite/sqflite.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/models/room_model.dart';

abstract class RoomsLocalDataSource {
  Future<List<RoomModel>> getRooms();
  Future<RoomModel> createRoom(RoomModel room);
  Future<RoomModel> updateRoom(String id, RoomModel room);
  Future<void> deleteRoom(String id);
  Future<void> updateCachedRooms(List<RoomModel> rooms);
}

class RoomsLocalDataSourceImpl implements RoomsLocalDataSource {
  final SQLiteService sqliteService;

  RoomsLocalDataSourceImpl({required this.sqliteService});

  @override
  Future<List<RoomModel>> getRooms() async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query('rooms');
      return List.generate(maps.length, (i) {
        try {
          return RoomModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse room data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching rooms: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching rooms: ${e.toString()}');
    }
  }

  @override
  Future<RoomModel> createRoom(RoomModel room) async {
    try {
      if (room.id!.isEmpty) {
        throw ValidationException('Room ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingRoom = await db.query(
        'rooms',
        where: 'id = ?',
        whereArgs: [room.id],
      );

      if (existingRoom.isNotEmpty) {
        throw SQLiteException('Room with ID ${room.id} already exists');
      }

      final result = await db.insert('rooms', room.toMap());
      if (result == 0) {
        throw SQLiteException('Failed to insert room');
      }

      return room;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while creating room: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while creating room: ${e.toString()}');
    }
  }

  @override
  Future<RoomModel> updateRoom(String id, RoomModel room) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Room ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingRoom = await db.query(
        'rooms',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (existingRoom.isEmpty) {
        throw NotFoundException('Room with ID $id not found');
      }

      final rowsAffected = await db.update(
        'rooms',
        room.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw SQLiteException('Failed to update room');
      }

      return room;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating room: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while updating room: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRoom(String id) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Room ID cannot be empty');
      }

      final db = await sqliteService.database;
      final rowsAffected = await db.delete(
        'rooms',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw NotFoundException('Room with ID $id not found');
      }
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while deleting room: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while deleting room: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCachedRooms(List<RoomModel> rooms) async {
    try {
      final db = await sqliteService.database;
      await db.transaction((txn) async {
        await txn.delete('rooms');
        for (var room in rooms) {
          if (room.id!.isEmpty) {
            throw ValidationException('Room ID cannot be empty');
          }
          await txn.insert('rooms', room.toMap());
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating cached rooms: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while updating cached rooms: ${e.toString()}');
    }
  }
}
