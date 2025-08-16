import 'package:cromos_scanner_laliga/app/core/utils/get_color_gradient_by_club.dart';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:cromos_scanner_laliga/app/enums/status_sticker.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final int id;
  const DetailsScreen({required this.id, super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Sticker? sticker = Sticker(
    id: 1,
    name: 'Lamine yamal',
    club: 'FC Barcelona',
    imagePath:
        'lib/app/assets/stickers_image/Lamine Yamal - FC Barcelona - Panini Liga Este  - 2025 - 2026 - 019 - Básico.webp',
    cardNumber: '#002',
    rarity: 'Normal',
  );
  @override
  Widget build(BuildContext context) {
    Sticker? sticker = this.sticker;
    if (sticker == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Details')),
        body: Center(child: Text('Sticker not found')),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: GetColorGradientByClub().call(sticker.club),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  _buildAppbarCustom(sticker),
                  const SizedBox(height: 10),
                  Image.asset(sticker.imagePath, scale: 2.5),
                  const SizedBox(height: 10),
                  Text(
                    sticker.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTag(sticker.club),
                      const SizedBox(width: 12),
                      _buildTag(sticker.rarity),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildStatusWidget(sticker.status),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildButtonWidget(sticker.id, sticker.status),
                  const SizedBox(height: 10),
                  Text(
                    'Player Stats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStats(sticker)
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(Sticker sticker) {
    Map<String, String> stats = <String, String>{
      'Club' : sticker.club,
      'Card Number' : sticker.cardNumber,
      'Rarity' : sticker.rarity,

    };
    final entries = stats.entries.toList();

    return Column(
      children: [
        for (int i = 0; i < entries.length; i += 2)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                // Primera columna
                Expanded(
                  child: _buildStatItem(entries[i]),
                ),
                // Segunda columna (si existe)
                Expanded(
                  child: i + 1 < entries.length
                      ? _buildStatItem(entries[i + 1])
                      : const SizedBox(), // Espacio vacío si no hay segundo elemento
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatItem(MapEntry<String, String> entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.key,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0x80FFFFFF)
          ),
        ),
        const SizedBox(height: 2),
        Text(
          entry.value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonWidget(int id, StatusSticker statusSticker) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB3007A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_outlined, color: Colors.white,size: 24,),
          const SizedBox(width: 10),
          Text(
            'Add to collection',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusWidget(StatusSticker statusSticker) {
    IconData iconData;
    Color colorIcon;
    Color colorBackground;
    String name;
    switch (statusSticker) {
      case StatusSticker.missing:
        iconData = Icons.error_outline;
        colorIcon = Color(0xFFEB580C);
        colorBackground = Color(0x7DEB580C);
        name = 'Missing';
        break;
      case StatusSticker.owned:
        iconData = Icons.verified_outlined;
        colorIcon = Color(0xFFB3007A);
        colorBackground = Color(0x7DB3007A);
        name = 'Owned';
        break;
      case StatusSticker.duplicated:
        iconData = Icons.copy_rounded;
        colorIcon = Color(0xFFCEE6F1);
        colorBackground = Color(0x7DCEE6F1);
        name = 'Duplicated';
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: colorIcon, size: 32),
          const SizedBox(width: 11),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String value) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF303030),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Center(
        child: Text(
          value,
          style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildAppbarCustom(Sticker sticker) {
    return Padding(
      padding: EdgeInsets.only(top: 30, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 3),
              _buildTitle(sticker),
            ],
          ),
          Text(sticker.cardNumber,style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),)
        ],
      ),
    );
  }

  _buildTitle(Sticker sticker) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${sticker.name}\n',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: sticker.club,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
