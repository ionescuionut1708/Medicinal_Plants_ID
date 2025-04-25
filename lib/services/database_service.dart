import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:medicinal_plants_id/models/plant.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'medicinal_plants.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants(
        id TEXT PRIMARY KEY,
        scientificName TEXT,
        commonName TEXT,
        description TEXT,
        medicinalProperties TEXT,
        therapeuticUses TEXT,
        imagePath TEXT,
        identifiedAt TEXT
      )
    ''');
  }

  Future<int> insertPlant(Plant plant) async {
    Database db = await database;
    return await db.insert(
      'plants',
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Plant>> getPlants() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      orderBy: 'identifiedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Plant.fromMap(maps[i]);
    });
  }

  Future<Plant?> getPlant(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Plant.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deletePlant(String id) async {
    Database db = await database;
    return await db.delete(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllPlants() async {
    Database db = await database;
    return await db.delete('plants');
  }
}
