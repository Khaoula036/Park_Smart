import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:park_smart/models/favorite.dart'; 

class DatabaseHelper {
  static const _databaseName = 'park_smart.db';
  static const _databaseVersion = 1;

  // Nom de la table des favoris
  static const tableFavorites = 'favorites';

  // Colonnes de la table des favoris
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnDistance = 'distance';
  static const columnAvailability = 'availability';

  // Base de données
  late Database _database;

  // Constructeur privé
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Accès à la base de données (initialisation si nécessaire)
  Future<Database> get database async {
  return _database ??= await _initDatabase();
}


  // Initialisation de la base de données
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Création de la table des favoris
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFavorites (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT,
        $columnDistance REAL,
        $columnAvailability INTEGER
      )
    ''');
  }

  // Opérations CRUD pour la table des favoris

  Future<int> addFavorite(Favorite favorite) async {
    Database db = await instance.database;
    return await db.insert(tableFavorites, favorite.toMap());
  }

  Future<List<Favorite>> getFavorites() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableFavorites);
    return List.generate(maps.length, (i) {
      return Favorite(
        id: maps[i][columnId],
        name: maps[i][columnName],
        distance: maps[i][columnDistance],
        availability: maps[i][columnAvailability],
      );
    });
  }

  Future<void> removeFavorite(int id) async {
    Database db = await instance.database;
    await db.delete(tableFavorites, where: '$columnId = ?', whereArgs: [id]);
  }

  // Ajoutez d'autres méthodes CRUD si nécessaire pour d'autres fonctionnalités.
}
