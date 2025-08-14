import 'dart:async';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _debounce;

  List<Sticker>? stickers;

  void _onQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isNotEmpty) {
        setState(() {
          stickers = [];
        });
      } else {
        setState(() {
          stickers = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      barHintText: 'Search players',
      barLeading: Icon(Icons.search, color: Colors.white),
      viewLeading: IconButton(
        onPressed: _onPressedViewLeading,
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      onChanged: _onQueryChanged,
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        if (stickers == null) {
          return [];
        }

        return stickers!.map(
          (Sticker sticker) => ListTile(title: Text(sticker.name)),
        );
      },
    );
  }

  void _onPressedViewLeading() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
