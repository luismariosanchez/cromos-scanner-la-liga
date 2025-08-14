import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {
  final List<Widget> children;
  final int? childPerRow;
  final double spacing;
  final double breakpointWidth;

  const CustomGrid({
    required this.children,
    this.childPerRow,
    this.spacing = 21,
    this.breakpointWidth = 250.0,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    // Determinar cuántos botones por fila según el ancho de pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveButtonsPerRow = childPerRow ??
        (screenWidth >= breakpointWidth ? 2 : 1);

    // Si solo hay 1 columna, usar el layout normal
    if (effectiveButtonsPerRow == 1) {
      return _buildSingleColumnLayout();
    }

    // Para múltiples columnas, usar layout con espacios invisibles
    return _buildBalancedLayout(effectiveButtonsPerRow);
  }

  Widget _buildSingleColumnLayout() {
    List<Widget> columnChildren = [];

    for (int i = 0; i < children.length; i++) {
      columnChildren.add(children[i]);

      // Agregar espacio entre elementos (excepto el último)
      if (i < children.length - 1) {
        columnChildren.add(SizedBox(height: spacing));
      }
    }

    return Column(children: columnChildren);
  }

  Widget _buildBalancedLayout(int buttonsPerRow) {
    List<Widget> rows = [];

    for (int i = 0; i < children.length; i += buttonsPerRow) {
      List<Widget> rowItems = [];

      // Recoger elementos para esta fila
      for (int j = 0; j < buttonsPerRow && i + j < children.length; j++) {
        rowItems.add(children[i + j]);
      }

      rows.add(_buildRow(rowItems, buttonsPerRow));

      // Agregar espacio entre filas (excepto la última)
      if (i + buttonsPerRow < children.length) {
        rows.add(SizedBox(height: spacing));
      }
    }

    return Column(children: rows);
  }

  Widget _buildRow(List<Widget> rowItems, int maxItemsPerRow) {
    List<Widget> rowChildren = [];

    for (int i = 0; i < maxItemsPerRow; i++) {
      if (i < rowItems.length) {
        // Agregar el widget real
        rowChildren.add(Expanded(child: rowItems[i]));
      } else {
        // Agregar espacio invisible para mantener la proporción
        rowChildren.add(Expanded(child: SizedBox()));
      }

      // Agregar espacio entre elementos (excepto el último)
      if (i < maxItemsPerRow - 1) {
        rowChildren.add(SizedBox(width: spacing));
      }
    }

    return Row(children: rowChildren);
  }
}