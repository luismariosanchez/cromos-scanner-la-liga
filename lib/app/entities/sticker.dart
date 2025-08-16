import 'package:cromos_scanner_laliga/app/enums/status_sticker.dart';

class Sticker {
  final int id;
  final String name;
  final String club;
  final String imagePath;
  final String cardNumber;
  final String rarity;

  final int amount;

  StatusSticker status;

  Sticker({
    required this.id,
    required this.name,
    required this.club,
    required this.imagePath,
    required this.cardNumber,
    required this.rarity,
    this.status = StatusSticker.missing,
    this.amount = 0,
  });

  factory Sticker.fromJson(Map<String, dynamic> json) {
    return Sticker(
      id: json["id"],
      name: json["name"],
      club: json["club"],
      imagePath: json["imagePath"],
      cardNumber: json["cardNumber"],
      rarity: json["rarity"],
      status: StatusSticker.values.firstWhere((element) => element.name == json["status"]),
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "club": club,
      "imagePath": imagePath,
      "cardNumber": cardNumber,
      "rarity": rarity,
      "status": status.name,
      "amount": amount,
    };
  }
}
