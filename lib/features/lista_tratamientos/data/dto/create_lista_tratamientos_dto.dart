// dto para crear un tratamiento en la lista de tratamientos
class CreateListaTratamientosDto {
  final String medicamento;
  final int cantidad;
  final String unidad;
  final int frecuencia;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String? observaciones;
  final String? usuarioRegistro;

  CreateListaTratamientosDto({
    required this.medicamento,
    required this.cantidad,
    required this.unidad,
    required this.frecuencia,
    required this.fechaInicio,
    this.fechaFin,
    this.observaciones,
    this.usuarioRegistro,
  });

  // convierte el dto a un mapa para guardar en firestore
  Map<String, dynamic> toMap() {
    return {
      'medicamento': medicamento,
      'cantidad': cantidad,
      'unidad': unidad,
      'frecuencia': frecuencia,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'observaciones': observaciones,
      'usuarioRegistro': usuarioRegistro,
      'fechaRegistro': DateTime.now().toIso8601String(),
    };
  }
}
