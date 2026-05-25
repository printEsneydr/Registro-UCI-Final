import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:registro_uci/features/firmas/domain/models/firma.dart';
import 'package:registro_uci/features/registros_diarios/data/constants/strings.dart';
part 'registro_diario.freezed.dart';

// modelo principal de registro diario usando freezed para inmutable
@freezed
class RegistroDiario with _$RegistroDiario {
  // constructor con campos: id, fecha, firma y observaciones
  const factory RegistroDiario({
    required String idRegistroDiario,
    required DateTime fechaRegistro,
    Firma? firmaNecesidades,
    @Default('') String observaciones,
  }) = _RegistroDiario;

  // factory que construye un registro diario desde firestore incluyendo el id
  factory RegistroDiario.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) {
    return RegistroDiario(
      idRegistroDiario: id,
      fechaRegistro: (json[Strings.fechaRegistro] as Timestamp).toDate(),
      firmaNecesidades: json[Strings.firmaNecesidades] != null
          ? Firma.fromJson(json[Strings.firmaNecesidades])
          : null,
      observaciones: (json[Strings.observaciones] as String?) ?? '',
    );
  }
}
