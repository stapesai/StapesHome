import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  static Database? _database;

  Future<void> initializeDatabase() async {
    if (_database != null) return;

    try {
      _database = await _initDB('stapes_home.db');
    } catch (e) {
      print('Database initialization failed: $e');
      rethrow;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    throw StateError('Database not initialized. Call initializeDatabase() first.');
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
    //   await db.execute('''
    //   CREATE TABLE user_session(
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     access_token TEXT NOT NULL,
    //     refresh_token TEXT NOT NULL,
    //     expires_at INTEGER NOT NULL
    //   )
    // ''');

    //   await db.execute('''
    //   CREATE TABLE user(
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     email TEXT NOT NULL,
    //     name TEXT NOT NULL
    //   )
    // ''');

    await db.execute('''
      CREATE TABLE floors(
      id TEXT PRIMARY KEY,
      level INTEGER NOT NULL,
      alias TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE rooms(
      id TEXT PRIMARY KEY,
      floor_id TEXT NOT NULL,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      FOREIGN KEY (floor_id) REFERENCES floors(id) ON DELETE CASCADE
      )
    ''');

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
