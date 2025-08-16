
import 'package:cromos_scanner_laliga/app/enums/clubs.dart';
import 'package:flutter/material.dart';

class GetColorGradientByClub{

  List<Color> call(String club) {
    ClubsEnum clubEnum = getClubByName(club);
    List<Color> gradient = [];

    switch (clubEnum) {
      case ClubsEnum.fcBarcelona:
        gradient = [Color(0xFF004D98), Color(0xFFA50044)];
        break;
      case ClubsEnum.realMadrid:
        gradient = [Colors.red, Colors.blue];
        break;
    }
    return gradient;
  }
}