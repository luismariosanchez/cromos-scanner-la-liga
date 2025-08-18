import 'dart:async';
import 'package:cromos_scanner_laliga/app/data/stickers_datasource.dart';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:cromos_scanner_laliga/app/widgets/sticker_card_widget.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final Map<String, Future<List<Sticker>>> _searchCache = {};

  Future<List<Sticker>> _getSearchResults(String query) {
    if (query.isEmpty) return Future.value([]);


    // Crear nuevo future con debounce incorporado
    final completer = Completer<List<Sticker>>();

    Timer(const Duration(milliseconds: 400), () async {
      try {
        final results = await StickersDataSource().getStickersByName(query);
        if (!completer.isCompleted) {
          completer.complete(results);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.complete([]);
        }
      }
    });

    final future = completer.future;
    _searchCache[query] = future;

    // Limpiar cache después de un tiempo para evitar memory leaks
    Timer(const Duration(minutes: 5), () {
      _searchCache.remove(query);
    });

    return future;
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: Icon(Icons.search, color: Colors.white),
          hintText: 'Search players',
        );
      },
      viewBuilder: (suggestions) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // Contenido de búsqueda
              Expanded(
                child: suggestions.isNotEmpty ? suggestions.first : Container(),
              ),
            ],
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final query = controller.text.trim();

        return [
          FutureBuilder<List<Sticker>>(
            key: ValueKey(query),
            future: _getSearchResults(query),
            builder: (context, snapshot) {
              if (query.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Escribe para buscar jugadores',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Buscando...'),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 48),
                        SizedBox(height: 16),
                        Text('Error en la búsqueda'),
                      ],
                    ),
                  ),
                );
              }

              final stickers = snapshot.data ?? [];

              if (stickers.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No se encontraron jugadores'),
                        SizedBox(height: 8),
                        Text(
                          'Intenta con otro nombre',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Encontrados: ${stickers.length} resultados',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 16),
                        itemCount: stickers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: StickerCardWidget(sticker: stickers[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ];
      },
    );
  }
}