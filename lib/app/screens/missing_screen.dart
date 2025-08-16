import 'package:cromos_scanner_laliga/app/data/stickers_datasource.dart';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:cromos_scanner_laliga/app/widgets/sticker_card_widget.dart';
import 'package:flutter/material.dart';

class MissingScreen extends StatefulWidget {
  const MissingScreen({super.key});

  @override
  State<MissingScreen> createState() => _MissingScreenState();
}

class _MissingScreenState extends State<MissingScreen> {

  bool isLoading = true;
  late List<Sticker> stickers;

  Future<void> setStickers() async {
    stickers = await StickersDataSource().getMissingStickers();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    setStickers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Missing')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(),);
    }
    List<Sticker>? stickers = this.stickers;
    return ListView.builder(
      itemBuilder: (context, index) {
        return StickerCardWidget(sticker: stickers[index]);
      },
      itemCount: stickers.length,
    );
  }
}
