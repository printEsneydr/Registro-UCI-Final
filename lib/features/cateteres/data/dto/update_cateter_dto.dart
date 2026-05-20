import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCateterDto {
  final String? tipo;
  final String? via;
  final DateTime? fechaInsercion;
  final DateTime? fechaRetiro;
  final DateTime? fechaCuracionOCambio;
  final String? caracteristicasSitioInsercion;

  UpdateCateterDto({
    this.tipo,
    this.via,
    this.fechaInsercion,
    this.fechaRetiro,
    this.fechaCuracionOCambio,
    this.caracteristicasSitioInsercion,
  });

  Map<String, dynamic> toJson() {
    return {
      if (tipo != null) "tipo": tipo,
      if (via != null) "via": via,
      if (fechaInsercion != null)
        "fechaInsercion": Timestamp.fromDate(fechaInsercion!),
      if (fechaRetiro != null)
        "fechaRetiro": Timestamp.fromDate(fechaRetiro!),
      if (fechaCuracionOCambio != null)
        "fechaCuracionOCambio": Timestamp.fromDate(fechaCuracionOCambio!),
      if (caracteristicasSitioInsercion != null)
        "caracteristicasSitioInsercion": caracteristicasSitioInsercion,
    };
  }
}
