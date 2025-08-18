
import 'package:cromos_scanner_laliga/app/core/services/sqflite_service.dart';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:sqflite/sqflite.dart';

class ScannerService {

  Future<List<Sticker>?> getStickerScanned(List<String?> names) async {

    String? playerName = await getPlayerName(names);

    if(playerName == null ) return null;

    String? rarity = await getRarity(names);

    Database db = await SqfliteService().database;
    List<Map<String, dynamic>> stickers;

    if(rarity != null) {
      stickers = await db.query('stickers', where: 'name = ? AND rarity = ?', whereArgs: [playerName, rarity]);
    }else {
      stickers = await db.query('stickers', where: 'name = ?', whereArgs: [playerName]);
    }
    if(stickers.isEmpty) return null;

    return stickers.map((e) => Sticker.fromJson(e)).toList();
  }

  Future<String?> getPlayerName(List<String?> names) async {
    Database db = await SqfliteService().database;
    String? playerName;
    print('BUSCANDO PLAYER');
    for (String? name in names) {
      if(name == null) continue;
      print(name);
      final List<Map<String, Object?>> stickers = await db.query('stickers', where: 'name LIKE ?', whereArgs: ['%${name.trim().replaceAll(" ", "")}%']);
      if(stickers.isEmpty) continue;

      playerName = stickers.first['name'] as String;
    }
    return playerName;
  }

  Future<String?> getRarity(List<String?> names) async {
    Database db = await SqfliteService().database;
    String? playerName;
    for (String? name in names) {
      if(name == null) continue;

      List<Map<String, dynamic>> stickers = await db.query('stickers',where: 'rarity LIKE ', whereArgs: ['%$name%']);
      if(stickers.isEmpty) continue;

      playerName = stickers.first['name'];
    }
    return playerName;
  }
}