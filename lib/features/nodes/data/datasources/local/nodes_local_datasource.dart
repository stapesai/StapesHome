// nodes_local_datasource.dart

import 'package:sqflite/sqflite.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/models/node_model.dart';

abstract class NodesLocalDataSource {
  Future<List<NodeModel>> getAllNodes();
  Future<List<NodeModel>> getNodesByRoomId(String roomId);
  Future<NodeModel> createNode(NodeModel node);
  Future<NodeModel> updateNode(String id, NodeModel node);
  Future<void> deleteNode(String id);
  Future<void> updateCachedNodes(List<NodeModel> nodes);
}

class NodesLocalDataSourceImpl implements NodesLocalDataSource {
  final SQLiteService sqliteService;

  NodesLocalDataSourceImpl({required this.sqliteService});

  @override
  Future<List<NodeModel>> getAllNodes() async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query('nodes');
      return List.generate(maps.length, (i) {
        try {
          return NodeModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse node data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching nodes: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching nodes: ${e.toString()}');
    }
  }

  @override
  Future<List<NodeModel>> getNodesByRoomId(String roomId) async {
    try {
      final db = await sqliteService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'nodes',
        where: 'room_id = ?',
        whereArgs: [roomId],
      );
      return List.generate(maps.length, (i) {
        try {
          return NodeModel.fromJson(maps[i]);
        } catch (e) {
          throw SQLiteException('Failed to parse node data: ${e.toString()}');
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while fetching nodes: ${e.toString()}');
    } catch (e) {
      throw UnexpectedException('Unexpected error while fetching nodes: ${e.toString()}');
    }
  }

  @override
  Future<NodeModel> createNode(NodeModel node) async {
    try {
      if (node.id!.isEmpty) {
        throw ValidationException('Node ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingNode = await db.query(
        'nodes',
        where: 'id = ?',
        whereArgs: [node.id],
      );

      if (existingNode.isNotEmpty) {
        throw SQLiteException('Node with ID ${node.id} already exists');
      }

      final result = await db.insert('nodes', {
        'id': node.id,
        'room_id': node.roomId,
        'name': node.name,
        'hardware_chip': node.hardwareChip,
        'hardware_version': node.hardwareVersion,
        'hardware_mac_address': node.hardwareMacAddress,
        'firmware_version': node.firmwareVersion,
      });

      if (result == 0) {
        throw SQLiteException('Failed to insert node');
      }

      return node;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while creating node: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while creating node: ${e.toString()}');
    }
  }

  @override
  Future<NodeModel> updateNode(String id, NodeModel node) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Node ID cannot be empty');
      }

      final db = await sqliteService.database;
      final existingNode = await db.query(
        'nodes',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (existingNode.isEmpty) {
        throw NotFoundException('Node with ID $id not found');
      }

      final rowsAffected = await db.update(
        'nodes',
        {
          'room_id': node.roomId,
          'name': node.name,
          'hardware_chip': node.hardwareChip,
          'hardware_version': node.hardwareVersion,
          'hardware_mac_address': node.hardwareMacAddress,
          'firmware_version': node.firmwareVersion,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw SQLiteException('Failed to update node');
      }

      return node;
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating node: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while updating node: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNode(String id) async {
    try {
      if (id.isEmpty) {
        throw ValidationException('Node ID cannot be empty');
      }

      final db = await sqliteService.database;
      final rowsAffected = await db.delete(
        'nodes',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        throw NotFoundException('Node with ID $id not found');
      }
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while deleting node: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException || e is NotFoundException) rethrow;
      throw UnexpectedException('Unexpected error while deleting node: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCachedNodes(List<NodeModel> nodes) async {
    try {
      final db = await sqliteService.database;
      await db.transaction((txn) async {
        // Clear existing nodes
        await txn.delete('nodes');

        // Insert new nodes
        for (var node in nodes) {
          if (node.id!.isEmpty) {
            throw ValidationException('Node ID cannot be empty');
          }

          await txn.insert('nodes', {
            'id': node.id,
            'room_id': node.roomId,
            'name': node.name,
            'hardware_chip': node.hardwareChip,
            'hardware_version': node.hardwareVersion,
            'hardware_mac_address': node.hardwareMacAddress,
            'firmware_version': node.firmwareVersion,
          });
        }
      });
    } on StateError catch (e) {
      throw SQLiteException('Database not initialized: ${e.message}');
    } on DatabaseException catch (e) {
      throw SQLiteException('Database error while updating cached nodes: ${e.toString()}');
    } catch (e) {
      if (e is SQLiteException || e is ValidationException) rethrow;
      throw UnexpectedException('Unexpected error while updating cached nodes: ${e.toString()}');
    }
  }
}
