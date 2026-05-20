import 'package:cloud_firestore/cloud_firestore.dart';

class CreateCateterDto {
  final String idIngreso;
  final String tipo;
  final String via;
  final DateTime fechaInsercion;
  final DateTime? fechaRetiro;
  final DateTime? fechaCuracionOCambio;
  final String caracteristicasSitioInsercion;

  CreateCateterDto({
    required this.idIngreso,
    required this.tipo,
    required this.via,
    required this.fechaInsercion,
    this.fechaRetiro,
    this.fechaCuracionOCambio,
    this.caracteristicasSitioInsercion = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "idIngreso": idIngreso,
      "tipo": tipo,
      "via": via,
      "fechaInsercion": Timestamp.fromDate(fechaInsercion),
      "fechaRetiro":
          fechaRetiro != null ? Timestamp.fromDate(fechaRetiro!) : null,
      "fechaCuracionOCambio": fechaCuracionOCambio != null
          ? Timestamp.fromDate(fechaCuracionOCambio!)
          : null,
      "caracteristicasSitioInsercion": caracteristicasSitioInsercion,
    };
  }
}
