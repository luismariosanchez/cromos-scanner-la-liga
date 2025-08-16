import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:cromos_scanner_laliga/app/widgets/sticker_card_widget.dart';
import 'package:flutter/material.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Sticker>? stickers = [
    Sticker(
      id: 1,
      name: 'Lamine yamal',
      club: 'FC Barcelona',
      imagePath:
          'lib/app/assets/stickers_image/Lamine Yamal - FC Barcelona - Panini Liga Este  - 2025 - 2026 - 019 - Básico.webp',
      cardNumber: '#002',
      rarity: 'Nomal',
    ),
    Sticker(
      id: 2,
      name: 'Lamine yamal',
      club: 'FC Barcelona',
      imagePath:
          'lib/app/assets/stickers_image/Lamine Yamal - FC Barcelona - Panini Liga Este  - 2025 - 2026 - 019 - Básico.webp',
      cardNumber: '#002',
      rarity: 'Nomal',
    ),
    Sticker(
      id: 3,
      name: 'Lamine yamal',
      club: 'FC Barcelona',
      imagePath:
          'lib/app/assets/stickers_image/Lamine Yamal - FC Barcelona - Panini Liga Este  - 2025 - 2026 - 019 - Básico.webp',
      cardNumber: '#002',
      rarity: 'Nomal',
    ),
    Sticker(
      id: 4,
      name: 'Lamine yamal',
      club: 'FC Barcelona',
      imagePath:
          'lib/app/assets/stickers_image/Lamine Yamal - FC Barcelona - Panini Liga Este  - 2025 - 2026 - 019 - Básico.webp',
      cardNumber: '#002',
      rarity: 'Nomal',
    ),
    Sticker(
      id: 5,
      name: 'Lamine yamal',
      club: 'FC Barcelona',
      imagePath:
          'lib/app/assets/stickers_image/Lamine Yamal - FC Barcelona - Panini Liga Este  - 2025 - 2026 - 019 - Básico.webp',
      cardNumber: '#002',
      rarity: 'Nomal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Collection')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<Sticker>? stickers = this.stickers;
    if (stickers == null) {
      return const Center(child: Text('No stickers found'));
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return StickerCardWidget(sticker: stickers[index]);
      },
      itemCount: stickers.length,
    );
  }
}
