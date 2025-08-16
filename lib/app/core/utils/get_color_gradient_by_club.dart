
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
        gradient = [Color(0xFFEEB812), Color(0xFF091698),Color(0xFFF9F9F9)];
        break;
      case ClubsEnum.alaves:
        gradient = [Color(0xFF091698),Color(0xFFF7F7F5), ];
        break;
      case ClubsEnum.athletic:
        gradient = [Color(0xFFDA2719), Color(0xFFFBF9F9)];
        break;
      case ClubsEnum.atleticoMadrid:
        gradient = [Color(0xFF201C69),Color(0xFF201C69), Color(0xFFD3221C),Color(0xFFFBF9F9),];
        break;
      case ClubsEnum.realBetis:
        gradient = [Color(0xFF138B0D), Color(0xFFFBF9F9)];
        break;
      case ClubsEnum.celta:
        gradient = [Color(0xFF8BB0DE),Color(0xFF8BB0DE), Color(0xFFCC1322)];
        break;
      case ClubsEnum.elche:
        gradient = [Color(0xFF0C8C05),Color(0xFFC8C17A)];
        break;
      case ClubsEnum.espanyol:
        gradient = [ Color(0xFF2178CB),Color(0xFFFFFFFF)];
        break;
      case ClubsEnum.getafe:
        gradient = [ Color(0xFF141478),Color(0xFFCBC9CE)];
        break;
      case ClubsEnum.girona:
        gradient = [ Color(0xFFC60E10),Color(0xFFEFBB1D)];
        break;
      case ClubsEnum.levante:
        gradient = [ Color(0xFF2346AA),Color(0xFFA22231)];
        break;
      case ClubsEnum.mallorca:
        gradient = [ Color(0xFFEFE73B),Color(0xFFB51213)];
        break;
      case ClubsEnum.oviedo:
        gradient = [Color(0xFF171C83),Color(0xFFEFF5F3)];
        break;
      case ClubsEnum.rayoVallecano:
        gradient = [Color(0xFFE0341C),Color(0xFFFAFAFA)];
        break;
      case ClubsEnum.realSociedad:
        gradient = [Color(0xFF2753BD),Color(0xFFE5EEEC)];
        break;
      case ClubsEnum.sevilla:
        gradient = [Color(0xFFE0341C),Color(0xFFFAFAFA)];
        break;
      case ClubsEnum.valencia:
        gradient = [ Color(0xFFEFE73B),Color(0xFFB51213)];
        break;
      case ClubsEnum.villareal:
        gradient = [ Color(0xFFEFE73B),Color(0xFFB51213)];
        break;
      case ClubsEnum.osasuna:
        gradient = [ Color(0xFFD21502),Color(0xFF110849)];
        break;
    }
    return gradient;
  }
}