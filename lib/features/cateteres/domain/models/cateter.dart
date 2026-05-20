import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cateter.freezed.dart';
part 'cateter.g.dart';

@freezed
class Cateter with _$Cateter {
  const factory Cateter({
    required String id,
    required String tipo,
    required String via,
    required DateTime fechaInsercion,
    DateTime? fechaRetiro,
    DateTime? fechaCuracionOCambio,
    required String caracteristicasSitioInsercion,
  }) = _Cateter;

  factory Cateter.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return Cateter(
      id: doc.id,
      tipo: data['tipo'] ?? 'Desconocido',
      via: (data['via'] ?? data['sitio'] ?? 'No especificado') as String,
      fechaInsercion: (data['fechaInsercion'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      fechaRetiro: (data['fechaRetiro'] as Timestamp?)?.toDate(),
      fechaCuracionOCambio: (data['fechaCuracionOCambio'] as Timestamp?)?.toDate(),
      caracteristicasSitioInsercion:
          data['caracteristicasSitioInsercion'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
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

  factory Cateter.fromJson(Map<String, dynamic> json) =>
      _$CateterFromJson(json);
}
