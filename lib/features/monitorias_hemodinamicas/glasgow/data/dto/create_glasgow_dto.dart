// dto con los datos para crear un registro de escala de glasgow
class CreateGlasgowDto {
  final int aperturaOcular;
  final int respuestaVerbal;
  final int respuestaMotora;
  final int puntajeTotal;
  final DateTime? horaRegistro;
  final String? observaciones;
  final String? usuarioRegistro;

  CreateGlasgowDto({
    required this.aperturaOcular,
    required this.respuestaVerbal,
    required this.respuestaMotora,
    required this.puntajeTotal,
    this.horaRegistro,
    this.observaciones,
    this.usuarioRegistro,
  });

  // convierte el dto a un mapa para guardar en firestore
  Map<String, dynamic> toMap() {
    return {
      'aperturaOcular': aperturaOcular,
      'respuestaVerbal': respuestaVerbal,
      'respuestaMotora': respuestaMotora,
      'puntajeTotal': puntajeTotal,
      'horaRegistro': horaRegistro,
      'observaciones': observaciones,
      'usuarioRegistro': usuarioRegistro,
      'fechaCreacion': DateTime.now(),
    };
  }
}
