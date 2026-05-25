// extension para convertir un numero de dia a su abreviatura en ingles
extension ToDayString on int {
  // 1=lunes, 2=martes, ..., 7=domingo
  String toDayString() {
    switch (this) {
      case 7:
        return 'SUN';
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT ';
      default:
        return '';
    }
  }
}
