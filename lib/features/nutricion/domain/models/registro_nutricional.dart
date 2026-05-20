import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'registro_nutricional.freezed.dart';

@freezed
class RegistroNutricional with _$RegistroNutricional {
  const factory RegistroNutricional({
    required String idRegistroNutricional,

    // ANTROPOMETRÍA
    required double peso,
    required double talla,
    required double imc,
    required double requerimientoCalorico,

    // REGISTRO
    required DateTime hora,
    required String via,
    double? total,
    double? proteinas,
    double? lipidos,
    double? carbohidratos,
    String? observaciones,
  }) = _RegistroNutricional;

  factory RegistroNutricional.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) {
    return RegistroNutricional(
      idRegistroNutricional: id,
      peso: (json['peso'] as num?)?.toDouble() ?? 0,
      talla: (json['talla'] as num?)?.toDouble() ?? 0,
      imc: (json['imc'] as num?)?.toDouble() ?? 0,
      requerimientoCalorico: (json['requerimientoCalorico'] as num?)?.toDouble() ?? 0,
      hora: (json['hora'] as Timestamp).toDate(),
      via: json['via'] as String? ?? '',
      total: (json['total'] as num?)?.toDouble(),
      proteinas: (json['proteinas'] as num?)?.toDouble(),
      lipidos: (json['lipidos'] as num?)?.toDouble(),
      carbohidratos: (json['carbohidratos'] as num?)?.toDouble(),
      observaciones: json['observaciones'] as String?,
    );
  }
}
