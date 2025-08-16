import 'package:cromos_scanner_laliga/app/core/services/sqflite_service.dart';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:sqflite/sqflite.dart';

class StickersDataSource{

  Future<List<int>> getCounts() async {
    Database db = await SqfliteService().database;

    // Total de cartas
    final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM stickers');
    final total = Sqflite.firstIntValue(totalResult) ?? 0;

    // Collected = owned + duplicate
    final collectedResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM stickers WHERE status IN ('owned', 'duplicated')"
    );
    final collected = Sqflite.firstIntValue(collectedResult) ?? 0;

    // Missing
    final missingResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM stickers WHERE status = 'missing'"
    );
    final missing = Sqflite.firstIntValue(missingResult) ?? 0;

    return [total, collected, missing];
  }

  Future<List<Sticker>> getMissingStickers() async {
    Database db = await SqfliteService().database;
    final List<Map<String, Object?>> result = await db.query('stickers', where: 'status = ?', whereArgs: ['missing']);
    return result.map((Map<String, Object?> e) => Sticker.fromJson(e)).toList();
  }

  Future<List<Sticker>> getOwnedAndDuplicateStickers() async {
    Database db = await SqfliteService().database;
    final List<Map<String, Object?>> result = await db.query('stickers', where: 'status IN (?, ?)', whereArgs: ['owned', 'duplicated'], orderBy: 'rarity DESC');
    return result.map((Map<String, Object?> e) => Sticker.fromJson(e)).toList();
  }

  Future<List<Sticker>> getStickersByName(String name) async {
    Database db = await SqfliteService().database;
    final List<Map<String, Object?>> result = await db.query('stickers', where: 'name LIKE ?', whereArgs: ['%$name%']);
    return result.map((Map<String, Object?> e) => Sticker.fromJson(e)).toList();
  }
  Future<Sticker> getSticker(int id) async {
    Database db = await SqfliteService().database;
    final List<Map<String, Object?>> result = await db.query('stickers', where: 'id = ?', whereArgs: [id]);
    return Sticker.fromJson(result.first);
  }
}