import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stapes_home.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE nodes(
        id TEXT PRIMARY KEY,
        room_id TEXT NOT NULL,
        name TEXT NOT NULL,
        hardware_chip TEXT NOT NULL,
        hardware_version TEXT NOT NULL,
        hardware_mac_address TEXT NOT NULL,
        firmware_version TEXT NOT NULL,
        num_entities INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
