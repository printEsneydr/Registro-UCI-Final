// modelo de datos para un medicamento administrado usando freezed
import 'package:freezed_annotation/freezed_annotation.dart';
part 'medicamento_administrado.freezed.dart';

// clase inmutable que representa un medicamento administrado al paciente
@freezed
class MedicamentoAdministrado with _$MedicamentoAdministrado {
  // constructor con los campos del medicamento administrado
  const factory MedicamentoAdministrado({
    required String idMedicamentoAdministrado,
    required String medicamento,
    required int cantidad,
    required String unidad,
    required bool esTratamiento,
  }) = _MedicamentoAdministrado;

  // construye una instancia desde un mapa de firestore
  factory MedicamentoAdministrado.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return MedicamentoAdministrado(
      idMedicamentoAdministrado: id,
      medicamento: json['medicamento'] as String,
      cantidad: json['cantidad'] as int,
      unidad: json['unidad'] as String,
      esTratamiento: json['esTratamiento'] as bool,
    );
  }
}
