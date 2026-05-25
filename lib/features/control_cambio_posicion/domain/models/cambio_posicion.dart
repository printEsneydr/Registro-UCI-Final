import 'package:freezed_annotation/freezed_annotation.dart';
part 'cambio_posicion.freezed.dart';

// modelo de cambio de posicion con hora, posicion y orden
@freezed
class CambioDePosicion with _$CambioDePosicion {
  const factory CambioDePosicion({
    required String idCambioDePosicion,
    required int hora,
    required String posicion,
    required int orden,
  }) = _CambioDePosicion;

  // construye desde firestore incluyendo el id del documento
  factory CambioDePosicion.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return CambioDePosicion(
      idCambioDePosicion: id,
      hora: json['hora'] as int,
      posicion: json['posicion'] as String,
      orden: json['orden'] as int,
    );
  }
}
