import 'package:freezed_annotation/freezed_annotation.dart';
part 'resultado.freezed.dart';

// modelo de datos para un resultado esperado (NOC)
@freezed
class Resultado with _$Resultado {
  // constructor con id, idNOC y nombre del resultado
  const factory Resultado({
    required String idResultado,
    required String idNOC,
    required String nombre,
  }) = _Resultado;

  // construye un Resultado desde un map json
  factory Resultado.fromJson(Map<String, dynamic> json, {required String id}) {
    return Resultado(
      idResultado: id,
      idNOC: json['idNOC'] as String,
      nombre: json['nombre'] as String,
    );
  }
}
