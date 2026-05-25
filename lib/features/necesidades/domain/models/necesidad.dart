import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:registro_uci/features/necesidades/data/constants/strings.dart';
part 'necesidad.freezed.dart';

// modelo freezed que representa una necesidad de enfermeria
@freezed
class Necesidad with _$Necesidad {
  const factory Necesidad({
    required String idNecesidad,
    required String nombreNecesidad,
  }) = _Necesidad;

  // crea una necesidad desde un mapa de firestore
  factory Necesidad.fromJson(Map<String, dynamic> json, {required String id}) {
    return Necesidad(
      idNecesidad: id,
      nombreNecesidad: json[Strings.nombreNecesidad] as String,
    );
  }
}
