
enum ClubsEnum{
  fcBarcelona,
  realMadrid
}

ClubsEnum getClubByName(String name){
  switch(name){
    case 'FC Barcelona':
      return ClubsEnum.fcBarcelona;
    case 'Real Madrid':
      return ClubsEnum.realMadrid;
    default:
      return ClubsEnum.fcBarcelona;
  }
}