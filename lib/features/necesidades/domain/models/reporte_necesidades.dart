class ReporteNecesidades {
  final String id;
  final String necesidadesDetectadas;
  final String objetivosEnfermeria;
  final String intervencionesRealizadas;
  final String revistaMedica;

  const ReporteNecesidades({
    required this.id,
    this.necesidadesDetectadas = '',
    this.objetivosEnfermeria = '',
    this.intervencionesRealizadas = '',
    this.revistaMedica = '',
  });

  factory ReporteNecesidades.fromJson(Map<String, dynamic> json, {required String id}) {
    return ReporteNecesidades(
      id: id,
      necesidadesDetectadas: (json['necesidadesDetectadas'] as String?) ?? '',
      objetivosEnfermeria: (json['objetivosEnfermeria'] as String?) ?? '',
      intervencionesRealizadas: (json['intervencionesRealizadas'] as String?) ?? '',
      revistaMedica: (json['revistaMedica'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'necesidadesDetectadas': necesidadesDetectadas,
      'objetivosEnfermeria': objetivosEnfermeria,
      'intervencionesRealizadas': intervencionesRealizadas,
      'revistaMedica': revistaMedica,
    };
  }
}
