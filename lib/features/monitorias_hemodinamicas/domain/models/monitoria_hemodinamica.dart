import 'package:freezed_annotation/freezed_annotation.dart';
part 'monitoria_hemodinamica.freezed.dart';

@freezed
class MonitoriaHemodinamica with _$MonitoriaHemodinamica {
  const factory MonitoriaHemodinamica({
    required String idMonitoria,
    required int hora,
    required int orden,
    int? pas,
    int? pad,
    int? pam,
    int? fc,
    int? fr,
    double? t,
    int? pvc,
    int? gc,
    int? ic,
    int? rvs,
    int? irvs,
    int? fio2,
    int? pia,
    int? ppa,
    int? pic,
    int? ppc,
    int? glucometria,
    int? insulina,
    int? saturacion,
  }) = _MonitoriaHemodinamica;

  factory MonitoriaHemodinamica.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return MonitoriaHemodinamica(
      idMonitoria: id,
      hora: json['hora'] as int,
      orden: json['orden'] as int,
      pas: (json['pas'] as num?)?.toInt(),
      pad: (json['pad'] as num?)?.toInt(),
      pam: (json['pam'] as num?)?.toInt(),
      fc: json['fc'] as int?,
      fr: json['fr'] as int?,
      t: (json['t'] as num?)?.toDouble(),
      pvc: json['pvc'] as int?,
      gc: json['gc'] as int?,
      ic: json['ic'] as int?,
      rvs: json['rvs'] as int?,
      irvs: json['irvs'] as int?,
      fio2: json['fio2'] as int?,
      pia: json['pia'] as int?,
      ppa: json['ppa'] as int?,
      pic: json['pic'] as int?,
      ppc: json['ppc'] as int?,
      glucometria: json['glucometria'] as int?,
      insulina: json['insulina'] as int?,
      saturacion: json['saturacion'] as int?,
    );
  }
}
