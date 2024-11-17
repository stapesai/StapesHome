import 'package:sqflite/sqflite.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/models/node_model.dart';

abstract class NodesLocalDataSource {
  Future<List<NodeModel>> getNodesByRoomId(String roomId);
  Future<NodeModel> getNodeById(String id);
  Future<void> saveNode(NodeModel node);
  Future<void> deleteNode(String id);
  Future<void> updateNode(NodeModel node);
  Future<List<NodeModel>> getAllNodes();
}

class NodesLocalDataSourceImpl implements NodesLocalDataSource {
  final SQLiteService sqliteService;

  NodesLocalDataSourceImpl({required this.sqliteService});

  @override
  Future<List<NodeModel>> getNodesByRoomId(String roomId) async {
    final db = await sqliteService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'nodes',
      where: 'room_id = ?',
      whereArgs: [roomId],
    );

    return List.generate(maps.length, (i) => NodeModel.fromJson(maps[i]));
  }

  @override
  Future<NodeModel> getNodeById(String id) async {
    final db = await sqliteService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'nodes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw Exception('Node not found');
    }

    return NodeModel.fromJson(maps.first);
  }

  @override
  Future<void> saveNode(NodeModel node) async {
    final db = await sqliteService.database;
    await db.insert(
      'nodes',
      {
        'id': node.id,
        'room_id': node.roomId,
        'name': node.name,
        'hardware_chip': node.hardwareChip,
        'hardware_version': node.hardwareVersion,
        'hardware_mac_address': node.hardwareMacAddress,
        'firmware_version': node.firmwareVersion,
        'num_entities': node.numEntities,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNode(String id) async {
    final db = await sqliteService.database;
    await db.delete(
      'nodes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateNode(NodeModel node) async {
    final db = await sqliteService.database;
    await db.update(
      'nodes',
      {
        'room_id': node.roomId,
        'name': node.name,
        'hardware_chip': node.hardwareChip,
        'hardware_version': node.hardwareVersion,
        'hardware_mac_address': node.hardwareMacAddress,
        'firmware_version': node.firmwareVersion,
        'num_entities': node.numEntities,
      },
      where: 'id = ?',
      whereArgs: [node.id],
    );
  }

  @override
  Future<List<NodeModel>> getAllNodes() async {
    final db = await sqliteService.database;
    final List<Map<String, dynamic>> maps = await db.query('nodes');
    return List.generate(maps.length, (i) => NodeModel.fromJson(maps[i]));
  }
}
