import 'package:cloud_firestore/cloud_firestore.dart';

// dto para crear un registro de liquidos eliminados en firestore
class CreateLiquidoEliminadoDto {
  final double orina;
  final double perdidasInsensibles;
  final double sondaGastrica;
  final double residuoGastrico;
  final double tuboTorax1;
  final double tuboTorax2;
  final double tuboMediastino;
  final double drenAbdominal;
  final double ileostomia;
  final double fistulaEnterocutanea;
  final double deposicion;
  final double dialisis;
  final double ventriculosTomaExterna;
  final double otros;
  final double campoLibre1;
  final double campoLibre2;
  final DateTime hora;
  final String? comentario;

  CreateLiquidoEliminadoDto({
    required this.orina,
    required this.perdidasInsensibles,
    required this.sondaGastrica,
    required this.residuoGastrico,
    required this.tuboTorax1,
    required this.tuboTorax2,
    required this.tuboMediastino,
    required this.drenAbdominal,
    required this.ileostomia,
    required this.fistulaEnterocutanea,
    required this.deposicion,
    required this.dialisis,
    required this.ventriculosTomaExterna,
    required this.otros,
    required this.campoLibre1,
    required this.campoLibre2,
    required this.hora,
    this.comentario,
  });

  // convierte el dto a un mapa para almacenarlo en firestore
  Map<String, dynamic> toMap() {
    return {
      'orina': orina,
      'perdidasInsensibles': perdidasInsensibles,
      'sondaGastrica': sondaGastrica,
      'residuoGastrico': residuoGastrico,
      'tuboTorax1': tuboTorax1,
      'tuboTorax2': tuboTorax2,
      'tuboMediastino': tuboMediastino,
      'drenAbdominal': drenAbdominal,
      'ileostomia': ileostomia,
      'fistulaEnterocutanea': fistulaEnterocutanea,
      'deposicion': deposicion,
      'dialisis': dialisis,
      'ventriculosTomaExterna': ventriculosTomaExterna,
      'otros': otros,
      'campoLibre1': campoLibre1,
      'campoLibre2': campoLibre2,
      'hora': Timestamp.fromDate(hora),
      'comentario': comentario,
    };
  }
}
