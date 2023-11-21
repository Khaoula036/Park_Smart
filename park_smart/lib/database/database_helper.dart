// database_helper.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "parking_database.db";
  static const _databaseVersion = 1;

  static const table = 'favorites';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDistance = 'distance';
  static const columnAvailability = 'availability';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnName TEXT,
        $columnDistance REAL,
        $columnAvailability INTEGER
      )
    ''');
  }

  Future<int> insert(Favorite favorite) async {
    Database db = await instance.database;
    return await db.insert(table, favorite.toMap());
  }

  Future<List<Favorite>> getAllFavorites() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Favorite(
        id: maps[i][columnId],
        name: maps[i][columnName],
        distance: maps[i][columnDistance],
        availability: maps[i][columnAvailability],
      );
    });
  }

  Future<void> deleteFavorite(String id) async {
    Database db = await instance.database;
    await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
