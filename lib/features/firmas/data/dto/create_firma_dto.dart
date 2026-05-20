import "dart:collection";
import 'package:registro_uci/features/firmas/data/dto/constants/strings.dart';

class CreateFirmaDto extends MapView<String, dynamic> {
  final String nombreFirma;
  final DateTime fechaFirma;
  final String tipoPersonal;
  final String turno;

  CreateFirmaDto({
    required this.nombreFirma,
    required this.fechaFirma,
    this.tipoPersonal = 'ENFERMERA',
    this.turno = '',
  }) : super({
          Strings.nombreFirma: nombreFirma,
          Strings.fechaFirma: fechaFirma,
          Strings.tipoPersonal: tipoPersonal,
          Strings.turno: turno,
        });
}
