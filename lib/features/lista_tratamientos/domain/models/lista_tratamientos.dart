// modelo inmutable de un tratamiento medico en la lista de tratamientos
class ListaTratamientos {
  final String idListaTratamientos;
  final String medicamento;
  final int cantidad;
  final String unidad;
  final int frecuencia;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String? observaciones;
  final String? usuarioRegistro;
  final DateTime? fechaRegistro;

  ListaTratamientos({
    required this.idListaTratamientos,
    required this.medicamento,
    required this.cantidad,
    required this.unidad,
    required this.frecuencia,
    required this.fechaInicio,
    this.fechaFin,
    this.observaciones,
    this.usuarioRegistro,
    this.fechaRegistro,
  });

  // convierte el modelo a un mapa para firestore
  Map<String, dynamic> toJson() {
    return {
      'medicamento': medicamento,
      'cantidad': cantidad,
      'unidad': unidad,
      'frecuencia': frecuencia,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'observaciones': observaciones,
      'usuarioRegistro': usuarioRegistro,
      'fechaRegistro': fechaRegistro?.toIso8601String(),
    };
  }

  // construye el modelo desde un mapa de firestore
  factory ListaTratamientos.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return ListaTratamientos(
      idListaTratamientos: id,
      medicamento: json['medicamento'] as String,
      cantidad: json['cantidad'] as int,
      unidad: json['unidad'] as String,
      frecuencia: json['frecuencia'] as int,
      fechaInicio:
          json['fechaInicio'] != null ? DateTime.parse(json['fechaInicio']) : DateTime.now(),
      fechaFin: json['fechaFin'] != null ? DateTime.parse(json['fechaFin']) : null,
      observaciones: json['observaciones'] as String?,
      usuarioRegistro: json['usuarioRegistro'] as String?,
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'])
          : null,
    );
  }
}
