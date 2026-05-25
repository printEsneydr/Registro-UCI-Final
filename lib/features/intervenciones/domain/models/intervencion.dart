import 'package:freezed_annotation/freezed_annotation.dart';
part 'intervencion.freezed.dart';

// modelo de datos para una intervencion (NIC)
@freezed
class Intervencion with _$Intervencion {
  // constructor con id, idNIC y nombre de la intervencion
  const factory Intervencion({
    required String idIntervencion,
    required String idNIC,
    required String nombre,
  }) = _Intervencion;

  // construye una Intervencion desde un map json
  factory Intervencion.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return Intervencion(
      idIntervencion: id,
      idNIC: json['idNIC'] as String,
      nombre: json['nombre'] as String,
    );
  }
}
