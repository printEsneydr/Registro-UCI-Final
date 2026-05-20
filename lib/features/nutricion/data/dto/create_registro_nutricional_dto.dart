import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRegistroNutricionalDto {
  final double peso;
  final double talla;
  final double imc;
  final double requerimientoCalorico;
  final DateTime hora;
  final String via;
  final double? total;
  final double? proteinas;
  final double? lipidos;
  final double? carbohidratos;
  final String? observaciones;

  CreateRegistroNutricionalDto({
    required this.peso,
    required this.talla,
    required this.imc,
    required this.requerimientoCalorico,
    required this.hora,
    required this.via,
    this.total,
    this.proteinas,
    this.lipidos,
    this.carbohidratos,
    this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'peso': peso,
      'talla': talla,
      'imc': imc,
      'requerimientoCalorico': requerimientoCalorico,
      'hora': Timestamp.fromDate(hora),
      'via': via,
      'total': total,
      'proteinas': proteinas,
      'lipidos': lipidos,
      'carbohidratos': carbohidratos,
      'observaciones': observaciones,
    };
  }
}
