import 'package:freezed_annotation/freezed_annotation.dart';

part 'procedimientos_especiales.freezed.dart';

@freezed
class ProcedimientoEspecial with _$ProcedimientoEspecial {
  const factory ProcedimientoEspecial({
    required String idProcedimiento,
    required String nombreProcedimiento,
    required String estado, // "Por realizar", "Realizado", "Reportado"
    String? medicamentoInfusion,
    String? dosisInfusion,
  }) = _ProcedimientoEspecial;

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
