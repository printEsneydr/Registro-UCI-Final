import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_procedimiento_dto.freezed.dart';
part 'create_procedimiento_dto.g.dart';

@freezed
class CreateProcedimientoDto with _$CreateProcedimientoDto {
  const factory CreateProcedimientoDto({
    required String nombreProcedimiento,
    @Default("Por realizar") String estado,
    String? medicamentoInfusion,
    String? dosisInfusion,
  }) = _CreateProcedimientoDto;

  factory CreateProcedimientoDto.fromJson(Map<String, dynamic> json) =>
      _$CreateProcedimientoDtoFromJson(json);
}
