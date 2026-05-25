// dto para actualizar el estado de un procedimiento especial
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_procedimiento_dto.freezed.dart';
part 'update_procedimiento_dto.g.dart';

// clase inmutable que solo permite cambiar el estado del procedimiento
@freezed
class UpdateProcedimientoDto with _$UpdateProcedimientoDto {
  const factory UpdateProcedimientoDto({
    required String estado, // Solo permitimos actualizar el estado
  }) = _UpdateProcedimientoDto;

  // construye el dto desde un json
  factory UpdateProcedimientoDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProcedimientoDtoFromJson(json);
}
