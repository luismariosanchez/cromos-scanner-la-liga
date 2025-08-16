import 'package:cromos_scanner_laliga/app/enums/status_sticker.dart';

class Sticker {
  final int id;
  final String name;
  final String club;
  final String imagePath;
  final String cardNumber;
  final String rarity;
  final StatusSticker status;
  Sticker({
    required this.id,
    required this.name,
    required this.club,
    required this.imagePath,
    required this.cardNumber,
    required this.rarity,
    this.status = StatusSticker.missing
  });
}
