import 'package:cromos_scanner_laliga/app/entities/count.dart';
import 'package:flutter/material.dart';

import '../enums/count_type.dart';

class CountCardWidget extends StatelessWidget {
  final Count count;
  const CountCardWidget({required this.count, super.key});

  List<Color> _getGradientColors() {
    List<Color> gradientColors = [];
    switch (count.type) {
      case CountType.totalCards:
        gradientColors = [Color(0xFF2E2078), Color(0xFFB3007A)];
        break;
      case CountType.collected:
        gradientColors = [Color(0xFF43267B), Color(0xFF1C2B70)];
        break;
      case CountType.missing:
        gradientColors = [Color(0xFF5081A3), Color(0xFFE1F5FD)];
        break;
    }

    return gradientColors;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 97,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: _getGradientColors(),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              count.count.toString(),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(count.title, style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
