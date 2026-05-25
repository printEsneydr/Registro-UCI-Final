import 'dart:collection';

// dto para crear/actualizar un control de sedacion con validaciones
class CreateControlSedacionDto extends MapView<String, dynamic> {
  final int rass; // valor de la escala rass (+4 a -5)
  final int hora;
  final int orden;
  final String observacion; // obligatorio para controles de sedacion

  CreateControlSedacionDto({
    required this.rass,
    required this.hora,
    required this.orden,
    required this.observacion,
  }) : super({
          'rass': rass,
          'hora': hora,
          'orden': orden,
          'observacion': observacion,
        }) {
    _validarParametros();
  }

  // valida que los parametros esten en rangos permitidos
  void _validarParametros() {
    if (rass < -5 || rass > 4) {
      throw ArgumentError('El valor RASS debe estar entre -5 y +4');
    }
    if (hora < 0 || hora > 23) {
      throw ArgumentError('La hora debe estar entre 0 y 23');
    }
    if (orden <= 0) {
      throw ArgumentError('El orden debe ser mayor a 0');
    }
    if (observacion.isEmpty) {
      throw ArgumentError('La observación es obligatoria');
    }
  }

  // convierte a mapa para guardar en firestore
  Map<String, dynamic> toFirestore() => Map<String, dynamic>.from(this);

  // construye desde firestore
  factory CreateControlSedacionDto.fromFirestore(Map<String, dynamic> map) {
    return CreateControlSedacionDto(
      rass: map['rass'] as int,
      hora: map['hora'] as int,
      orden: map['orden'] as int,
      observacion: map['observacion'] as String,
    );
  }

  // construye desde json
  factory CreateControlSedacionDto.fromJson(Map<String, dynamic> json) {
    return CreateControlSedacionDto.fromFirestore(json);
  }

  // convierte a json
  Map<String, dynamic> toJson() => toFirestore();

  // crea una copia con campos actualizados parcialmente
  CreateControlSedacionDto copyWith({
    int? rass,
    int? hora,
    int? orden,
    String? observacion,
  }) {
    return CreateControlSedacionDto(
      rass: rass ?? this.rass,
      hora: hora ?? this.hora,
      orden: orden ?? this.orden,
      observacion: observacion ?? this.observacion,
    );
  }

  @override
  String toString() {
    return 'CreateControlSedacionDto('
        'rass: $rass, '
        'hora: $hora, '
        'orden: $orden, '
        'observacion: $observacion)';
  }
}
