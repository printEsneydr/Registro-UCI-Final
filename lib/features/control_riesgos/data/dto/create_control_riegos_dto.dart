// dto para crear un control de riesgos con todos los campos
class CreateControlDeRiesgosDto {
  final bool tieneUPP;
  final DateTime? fechaRegistroUlcera;
  final String? numeroReporteEA;
  final String? sitioUPP;
  final bool uppResuelta;
  final DateTime? fechaResolucion;
  final int? diasConUlceras;
  final String riesgoCaida;
  final String? numeroReporteCaida;
  final bool usaAnticoagulantes;
  final String? anticoagulanteSeleccionado;
  final bool enAislamiento;
  final DateTime? fechaInicioAislamiento;
  final String? tipoAislamiento;
  final String? agenteAislamiento;
  final DateTime? fechaFinAislamiento;
  final int? diasDeAislamiento;
  final bool alergicoAMedicacion;
  final String? medicamentoAlergico;

  CreateControlDeRiesgosDto({
    required this.tieneUPP,
    this.fechaRegistroUlcera,
    this.numeroReporteEA,
    this.sitioUPP,
    required this.uppResuelta,
    this.fechaResolucion,
    this.diasConUlceras,
    required this.riesgoCaida,
    this.numeroReporteCaida,
    required this.usaAnticoagulantes,
    this.anticoagulanteSeleccionado,
    required this.enAislamiento,
    this.fechaInicioAislamiento,
    this.tipoAislamiento,
    this.agenteAislamiento,
    this.fechaFinAislamiento,
    this.diasDeAislamiento,
    this.alergicoAMedicacion = false,
    this.medicamentoAlergico,
  });

  // convierte el dto a un mapa para firestore
  Map<String, dynamic> toMap() {
    return {
      'tieneUPP': tieneUPP,
      'fechaRegistroUlcera': fechaRegistroUlcera?.toIso8601String(),
      'numeroReporteEA': numeroReporteEA,
      'sitioUPP': sitioUPP,
      'uppResuelta': uppResuelta,
      'fechaResolucion': fechaResolucion?.toIso8601String(),
      'diasConUlceras': diasConUlceras,
      'riesgoCaida': riesgoCaida,
      'numeroReporteCaida': numeroReporteCaida,
      'usaAnticoagulantes': usaAnticoagulantes,
      'anticoagulanteSeleccionado': anticoagulanteSeleccionado,
      'enAislamiento': enAislamiento,
      'fechaInicioAislamiento': fechaInicioAislamiento?.toIso8601String(),
      'tipoAislamiento': tipoAislamiento,
      'agenteAislamiento': agenteAislamiento,
      'fechaFinAislamiento': fechaFinAislamiento?.toIso8601String(),
      'diasDeAislamiento': diasDeAislamiento,
      'alergicoAMedicacion': alergicoAMedicacion,
      'medicamentoAlergico': medicamentoAlergico,
    };
  }
}
