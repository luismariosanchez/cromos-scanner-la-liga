import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:cromos_scanner_laliga/app/enums/status_sticker.dart';
import 'package:flutter/material.dart';

class StickerCardWidget extends StatelessWidget {
  
  final Sticker sticker;
  const StickerCardWidget({required this.sticker,super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/details',arguments: sticker.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    sticker.imagePath,
                    scale: 5,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      print(sticker.imagePath);
                      return Image.asset('lib/app/assets/stickers_image/sin imagen.jpg',scale: 3.5,width: 150,);
                    }
                  ),
                  const SizedBox(width: 11),
                  Flexible(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sticker.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStickerStat('Club', sticker.club),
                      _buildStickerStat(
                        'Card Number',
                        sticker.cardNumber,
                      ),
                      _buildStickerStat('Rarity', sticker.rarity),
                    ],
                  )),
                ],
              ),
            ),
            _buildIconStatus(sticker.status),
          ],
        ),
      ),
    );
  }
  Widget _buildStickerStat(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title ',
            style: TextStyle(color: Color(0x80FFFFFF)),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildIconStatus(StatusSticker statusSticker) {
    IconData iconData;
    Color color;
    switch (statusSticker) {
      case StatusSticker.missing:
        iconData = Icons.error_outline;
        color = Color(0xFFEB580C);
        break;
      case StatusSticker.owned:
        iconData = Icons.verified_outlined;
        color = Color(0xFFB3007A);
        break;
      case StatusSticker.duplicated:
        iconData = Icons.copy_rounded;
        color = Color(0xFFCEE6F1);
        break;
    }
    return Icon(iconData, color: color);
  }
}
