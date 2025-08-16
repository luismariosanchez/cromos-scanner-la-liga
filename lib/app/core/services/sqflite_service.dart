
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteService {
  Database? _database;
  Future<Database> get database async{
    if(_database != null) return _database!;
    await init();
    return _database!;
  }

  Future<void> init() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'stickers.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await createTable(db);
        await insertStickersFromJson(db);
      }
    );
  }
  Future<void> createTable(Database db) async{
    await db.execute('''
          CREATE TABLE IF NOT EXISTS stickers (
            id INTEGER PRIMARY KEY,
            name TEXT,
            club TEXT,
            imagePath TEXT,
            cardNumber TEXT,
            rarity TEXT,
            status TEXT,
            updatedAt DATETIME DEFAULT NULL,
            amount INTEGER DEFAULT 0
          )
        ''');
  }

  Future<void> insertStickersFromJson(Database db) async {
    // Cargar el JSON desde assets
    String jsonString = await rootBundle.loadString('lib/app/assets/cromos_json.txt');
    final List<dynamic> data = json.decode(jsonString);

    // Usar batch para insertar más rápido
    Batch batch = db.batch();

    for (var item in data) {
      batch.insert(
        'stickers',
        {
          'name': item['name'],
          'club': item['club'],
          'imagePath': item['imagePath'],
          'cardNumber': item['cardNumber'],
          'rarity': item['rarity'],
          'status': item['status'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}