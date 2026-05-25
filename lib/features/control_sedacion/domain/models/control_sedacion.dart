import 'package:freezed_annotation/freezed_annotation.dart';

part 'control_sedacion.freezed.dart';

// modelo de control de sedacion con escala rass, hora, orden y observaciones
@freezed
class ControlSedacion with _$ControlSedacion {
  const factory ControlSedacion({
    required String id,
    required int hora,
    required String observacion,
    required int orden,
    required int rass,
  }) = _ControlSedacion;

  // construye desde firestore incluyendo el id del documento
  factory ControlSedacion.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return ControlSedacion(
      id: id,
      hora: json['hora'] as int,
      observacion: json['observacion'] as String,
      orden: json['orden'] as int,
      rass: json['rass'] as int,
    );
  }
}
