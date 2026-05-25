import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'firma.freezed.dart'; // Add this line for the Firma model

// modelo que representa la firma de un reporte por parte del personal
@freezed
class Firma with _$Firma {
  const factory Firma({
    required String nombreFirma,
    required DateTime fechaFirma,
    @Default('ENFERMERA') String tipoPersonal,
    @Default('') String turno,
  }) = _Firma;

  // construye una firma desde un mapa de firestore
  factory Firma.fromJson(Map<String, dynamic> json) {
    return Firma(
      nombreFirma: json['nombreFirma'] as String,
      fechaFirma: (json['fechaFirma'] as Timestamp).toDate(),
      tipoPersonal: (json['tipoPersonal'] as String?) ?? 'ENFERMERA',
      turno: (json['turno'] as String?) ?? '',
    );
  }
}
