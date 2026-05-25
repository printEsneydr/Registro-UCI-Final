import 'package:freezed_annotation/freezed_annotation.dart';
part 'actividad.freezed.dart';

// modelo de datos para una actividad de intervencion
@freezed
class Actividad with _$Actividad {
  // constructor con id y descripcion de la actividad
  const factory Actividad({
    required String idActividad,
    required String descripcion,
  }) = _Actividad;

  // construye una Actividad desde un map json
  factory Actividad.fromJson(Map<String, dynamic> json, {required String id}) {
    return Actividad(
      idActividad: id,
      descripcion: json['descripcion'] as String,
    );
  }
}
