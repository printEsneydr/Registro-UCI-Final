// modelos de datos para observaciones extras, solicitudes, gram, firmas
import 'package:cloud_firestore/cloud_firestore.dart';

// modelo para una solicitud de laboratorio o radiologia
class SolicitudLaboratorio {
  DateTime? fecha;
  String solicitud;
  String resultados;

  SolicitudLaboratorio({
    this.fecha,
    this.solicitud = '',
    this.resultados = '',
  });

  Map<String, dynamic> toJson() => {
        'fecha': fecha != null ? Timestamp.fromDate(fecha!) : null,
        'solicitud': solicitud,
        'resultados': resultados,
      };

  factory SolicitudLaboratorio.fromJson(Map<String, dynamic> json) =>
      SolicitudLaboratorio(
        fecha: json['fecha'] != null
            ? (json['fecha'] as Timestamp).toDate()
            : null,
        solicitud: json['solicitud'] as String? ?? '',
        resultados: json['resultados'] as String? ?? '',
      );
}

// modelo para un registro de gram o cultivo
class GramCultivo {
  DateTime? fecha;
  String cultivo;
  String resultados;

  GramCultivo({
    this.fecha,
    this.cultivo = '',
    this.resultados = '',
  });

  Map<String, dynamic> toJson() => {
        'fecha': fecha != null ? Timestamp.fromDate(fecha!) : null,
        'cultivo': cultivo,
        'resultados': resultados,
      };

  factory GramCultivo.fromJson(Map<String, dynamic> json) => GramCultivo(
        fecha: json['fecha'] != null
            ? (json['fecha'] as Timestamp).toDate()
            : null,
        cultivo: json['cultivo'] as String? ?? '',
        resultados: json['resultados'] as String? ?? '',
      );
}

// modelo para una orden de transfusion de componentes sanguineos
class OrdenTransfusion {
  DateTime? fecha;
  String hora;
  String globulosRojos;
  String plaquetas;
  String plasma;

  OrdenTransfusion({
    this.fecha,
    this.hora = '',
    this.globulosRojos = '',
    this.plaquetas = '',
    this.plasma = '',
  });

  Map<String, dynamic> toJson() => {
        'fecha': fecha != null ? Timestamp.fromDate(fecha!) : null,
        'hora': hora,
        'globulosRojos': globulosRojos,
        'plaquetas': plaquetas,
        'plasma': plasma,
      };

  factory OrdenTransfusion.fromJson(Map<String, dynamic> json) =>
      OrdenTransfusion(
        fecha: json['fecha'] != null
            ? (json['fecha'] as Timestamp).toDate()
            : null,
        hora: json['hora'] as String? ?? '',
        globulosRojos: json['globulosRojos'] as String? ?? '',
        plaquetas: json['plaquetas'] as String? ?? '',
        plasma: json['plasma'] as String? ?? '',
      );
}

// modelo para la firma del personal de enfermeria por turno
class FirmaPersonal {
  String tipoPersonal;
  String turno;
  String firmaBase64;
  DateTime? fechaFirma;

  FirmaPersonal({
    required this.tipoPersonal,
    required this.turno,
    this.firmaBase64 = '',
    this.fechaFirma,
  });

  Map<String, dynamic> toJson() => {
        'tipoPersonal': tipoPersonal,
        'turno': turno,
        'firmaBase64': firmaBase64,
        'fechaFirma':
            fechaFirma != null ? Timestamp.fromDate(fechaFirma!) : null,
      };

  factory FirmaPersonal.fromJson(Map<String, dynamic> json) => FirmaPersonal(
        tipoPersonal: json['tipoPersonal'] as String? ?? '',
        turno: json['turno'] as String? ?? '',
        firmaBase64: json['firmaBase64'] as String? ?? '',
        fechaFirma: json['fechaFirma'] != null
            ? (json['fechaFirma'] as Timestamp).toDate()
            : null,
      );
}

// modelo principal que agrupa todas las observaciones extras del ingreso
class ObservacionesExtrasData {
  List<SolicitudLaboratorio> solicitudes;
  List<GramCultivo> grams;
  List<OrdenTransfusion> ordenes;
  String observaciones;
  List<FirmaPersonal> firmas;

  ObservacionesExtrasData({
    List<SolicitudLaboratorio>? solicitudes,
    List<GramCultivo>? grams,
    List<OrdenTransfusion>? ordenes,
    this.observaciones = '',
    List<FirmaPersonal>? firmas,
  })  : solicitudes = solicitudes ?? List.generate(8, (_) => SolicitudLaboratorio()),
        grams = grams ?? List.generate(6, (_) => GramCultivo()),
        ordenes = ordenes ?? List.generate(6, (_) => OrdenTransfusion()),
        firmas = firmas ??
            [
              FirmaPersonal(tipoPersonal: 'ENFERMERA JEFE', turno: 'Mañana'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA JEFE', turno: 'Tarde'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA JEFE', turno: 'Noche'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA', turno: 'Mañana'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA', turno: 'Tarde'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA', turno: 'Noche'),
            ];

  Map<String, dynamic> toJson() => {
        'solicitudes': solicitudes.map((s) => s.toJson()).toList(),
        'grams': grams.map((g) => g.toJson()).toList(),
        'ordenes': ordenes.map((o) => o.toJson()).toList(),
        'observaciones': observaciones,
        'firmas': firmas.map((f) => f.toJson()).toList(),
      };

  factory ObservacionesExtrasData.fromJson(Map<String, dynamic> json) => ObservacionesExtrasData(
        solicitudes: (json['solicitudes'] as List<dynamic>?)
                ?.map((s) =>
                    SolicitudLaboratorio.fromJson(s as Map<String, dynamic>))
                .toList() ??
            List.generate(8, (_) => SolicitudLaboratorio()),
        grams: (json['grams'] as List<dynamic>?)
                ?.map(
                    (g) => GramCultivo.fromJson(g as Map<String, dynamic>))
                .toList() ??
            List.generate(6, (_) => GramCultivo()),
        ordenes: (json['ordenes'] as List<dynamic>?)
                ?.map(
                    (o) => OrdenTransfusion.fromJson(o as Map<String, dynamic>))
                .toList() ??
            List.generate(6, (_) => OrdenTransfusion()),
        observaciones: json['observaciones'] as String? ?? '',
        firmas: (json['firmas'] as List<dynamic>?)
                ?.map(
                    (f) => FirmaPersonal.fromJson(f as Map<String, dynamic>))
                .toList() ??
            [
              FirmaPersonal(tipoPersonal: 'ENFERMERA JEFE', turno: 'Mañana'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA JEFE', turno: 'Tarde'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA JEFE', turno: 'Noche'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA', turno: 'Mañana'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA', turno: 'Tarde'),
              FirmaPersonal(tipoPersonal: 'ENFERMERA', turno: 'Noche'),
            ],
      );
}
