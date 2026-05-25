import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'liquido_eliminado.freezed.dart';

// modelo freezed que representa un registro de liquidos eliminados
@freezed
class LiquidoEliminado with _$LiquidoEliminado {
  const factory LiquidoEliminado({
    required String idLiquidoEliminado,

    required double orina,
    required double perdidasInsensibles,
    required double sondaGastrica,
    required double residuoGastrico,
    required double tuboTorax1,
    required double tuboTorax2,
    required double tuboMediastino,
    required double drenAbdominal,
    required double ileostomia,
    required double fistulaEnterocutanea,
    required double deposicion,
    required double dialisis,
    required double ventriculosTomaExterna,
    required double otros,
    required double campoLibre1,
    required double campoLibre2,

    required DateTime hora,
    String? comentario,
  }) = _LiquidoEliminado;

  // construye el modelo desde un mapa de firestore con valores por defecto
  factory LiquidoEliminado.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) {
    return LiquidoEliminado(
      idLiquidoEliminado: id,
      orina: (json['orina'] as num?)?.toDouble() ?? 0.0,
      perdidasInsensibles:
          (json['perdidasInsensibles'] as num?)?.toDouble() ?? 0.0,
      sondaGastrica: (json['sondaGastrica'] as num?)?.toDouble() ?? 0.0,
      residuoGastrico: (json['residuoGastrico'] as num?)?.toDouble() ?? 0.0,
      tuboTorax1: (json['tuboTorax1'] as num?)?.toDouble() ?? 0.0,
      tuboTorax2: (json['tuboTorax2'] as num?)?.toDouble() ?? 0.0,
      tuboMediastino: (json['tuboMediastino'] as num?)?.toDouble() ?? 0.0,
      drenAbdominal: (json['drenAbdominal'] as num?)?.toDouble() ?? 0.0,
      ileostomia: (json['ileostomia'] as num?)?.toDouble() ?? 0.0,
      fistulaEnterocutanea:
          (json['fistulaEnterocutanea'] as num?)?.toDouble() ?? 0.0,
      deposicion: (json['deposicion'] as num?)?.toDouble() ?? 0.0,
      dialisis: (json['dialisis'] as num?)?.toDouble() ?? 0.0,
      ventriculosTomaExterna:
          (json['ventriculosTomaExterna'] as num?)?.toDouble() ?? 0.0,
      otros: (json['otros'] as num?)?.toDouble() ?? 0.0,
      campoLibre1: (json['campoLibre1'] as num?)?.toDouble() ?? 0.0,
      campoLibre2: (json['campoLibre2'] as num?)?.toDouble() ?? 0.0,
      hora: (json['hora'] as Timestamp).toDate(),
      comentario: json['comentario'] as String?,
    );
  }
}
