import 'package:freezed_annotation/freezed_annotation.dart';
part 'balance_de_liquidos.freezed.dart';

// modelo freezed que representa un balance de liquidos
@freezed
class BalanceDeLiquidos with _$BalanceDeLiquidos {
  const factory BalanceDeLiquidos({
    required String idBalanceDeLiquidos,
    required int hora,
    required int orden,
  }) = _BalanceDeLiquidos;

  // construye el modelo desde un mapa de firestore
  factory BalanceDeLiquidos.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return BalanceDeLiquidos(
      idBalanceDeLiquidos: id,
      hora: json['hora'] as int,
      orden: json['orden'] as int,
    );
  }
}
