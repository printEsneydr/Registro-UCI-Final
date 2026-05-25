// modelo de datos para un procedimiento especial usando freezed
import 'package:freezed_annotation/freezed_annotation.dart';

part 'procedimientos_especiales.freezed.dart';

// clase inmutable que representa un procedimiento especial
@freezed
class ProcedimientoEspecial with _$ProcedimientoEspecial {
  // constructor con campos requeridos e informacion de infusion opcional
  const factory ProcedimientoEspecial({
    required String idProcedimiento,
    required String nombreProcedimiento,
    required String estado, // "Por realizar", "Realizado", "Reportado"
    String? medicamentoInfusion,
    String? dosisInfusion,
  }) = _ProcedimientoEspecial;

  // construye una instancia desde un mapa de firestore
  factory ProcedimientoEspecial.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return ProcedimientoEspecial(
      idProcedimiento: id,
      nombreProcedimiento: json['nombreProcedimiento'] as String,
      estado: (json['estado'] as String?) ?? 'Por realizar',
      medicamentoInfusion: json['medicamentoInfusion'] as String?,
      dosisInfusion: json['dosisInfusion'] as String?,
    );
  }
}
