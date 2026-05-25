// dto para crear un procedimiento especial en firestore
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_procedimiento_dto.freezed.dart';
part 'create_procedimiento_dto.g.dart';

// clase inmutable con los datos necesarios para crear un procedimiento
@freezed
class CreateProcedimientoDto with _$CreateProcedimientoDto {
  // constructor con nombre requerido, estado por defecto e infusion opcional
  const factory CreateProcedimientoDto({
    required String nombreProcedimiento,
    @Default("Por realizar") String estado,
    String? medicamentoInfusion,
    String? dosisInfusion,
  }) = _CreateProcedimientoDto;

  // construye el dto desde un json
  factory CreateProcedimientoDto.fromJson(Map<String, dynamic> json) =>
      _$CreateProcedimientoDtoFromJson(json);
}
