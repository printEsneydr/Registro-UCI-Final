import 'package:freezed_annotation/freezed_annotation.dart';
part 'indicador.freezed.dart';

// modelo de datos para un indicador de resultado
@freezed
class Indicador with _$Indicador {
  // constructor con id y descripcion del indicador
  const factory Indicador({
    required String idIndicador,
    required String descripcion,
  }) = _Indicador;

  // construye un Indicador desde un map json
  factory Indicador.fromJson(Map<String, dynamic> json, {required String id}) {
    return Indicador(
      idIndicador: id,
      descripcion: json['descripcion'] as String,
    );
  }
}
