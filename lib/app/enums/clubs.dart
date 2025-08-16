
enum ClubsEnum{
  alaves,
  athletic,
  atleticoMadrid,
  fcBarcelona,
  realBetis,
  celta,
  elche,
  espanyol,
  getafe,
  girona,
  levante,
  realMadrid,
  mallorca,
  oviedo,
  rayoVallecano,
  realSociedad,
  sevilla,
  valencia,
  villareal,
  osasuna,
}

ClubsEnum getClubByName(String name){
  switch(name){
    case 'Alavés':
      return ClubsEnum.alaves;
    case 'Athletic Club':
      return ClubsEnum.athletic;
    case 'Atlético de Madrid':
      return ClubsEnum.atleticoMadrid;
    case 'FC Barcelona':
      return ClubsEnum.fcBarcelona;
    case 'Real Betis':
      return ClubsEnum.realBetis;
    case 'RC Celta':
      return ClubsEnum.celta;
    case 'Elche CF':
      return ClubsEnum.elche;
    case 'RCD Espanyol':
      return ClubsEnum.espanyol;
    case 'Real Madrid':
      return ClubsEnum.realMadrid;
    case 'Getafe CF':
      return ClubsEnum.getafe;
    case 'Girona FC':
      return ClubsEnum.girona;
    case 'UD Levante':
      return ClubsEnum.levante;
    case 'RCD Mallorca':
      return ClubsEnum.mallorca;
    case 'Rayo Vallecano':
      return ClubsEnum.rayoVallecano;
    case 'CA Osasuna':
      return ClubsEnum.osasuna;
    case 'Real Oviedo':
      return ClubsEnum.oviedo;
    case 'Real Sociedad':
      return ClubsEnum.realSociedad;
    case 'Sevilla FC':
      return ClubsEnum.sevilla;
    case 'Valencia CF':
      return ClubsEnum.valencia;
    case 'Villarreal CF':
      return ClubsEnum.villareal;
    default:
      return ClubsEnum.fcBarcelona;

  }
}