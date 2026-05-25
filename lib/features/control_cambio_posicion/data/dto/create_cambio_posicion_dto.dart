import 'dart:collection';

// dto para crear un cambio de posicion con validaciones
class CreateCambioPosicionDto extends MapView<String, dynamic> {
  final String posicion;
  final int hora;
  final int orden;
  final String? observaciones;
  final String? responsable;

  CreateCambioPosicionDto({
    required this.posicion,
    required this.hora,
    required this.orden,
    this.observaciones,
    this.responsable,
  }) : super({
          'posicion': posicion,
          'hora': hora,
          'orden': orden,
          if (observaciones != null) 'observaciones': observaciones,
          if (responsable != null) 'responsable': responsable,
        }) {
    _validarParametros();
  }

  // valida que los parametros esten en rangos permitidos
  void _validarParametros() {
    if (posicion.isEmpty) {
      throw ArgumentError('La posición no puede estar vacía');
    }
    if (hora < 0 || hora > 23) {
      throw ArgumentError('La hora debe estar entre 0 y 23');
    }
    if (orden <= 0) {
      throw ArgumentError('El orden debe ser mayor a 0');
    }
    if (observaciones?.isEmpty ?? false) {
      throw ArgumentError(
          'Las observaciones no pueden estar vacías si se proporcionan');
    }
    if (responsable?.isEmpty ?? false) {
      throw ArgumentError(
          'El responsable no puede estar vacío si se proporciona');
    }
  }

  // convierte a mapa para firestore
  Map<String, dynamic> toFirestore() => Map<String, dynamic>.from(this);

  // construye desde firestore
  factory CreateCambioPosicionDto.fromFirestore(Map<String, dynamic> map) {
    return CreateCambioPosicionDto(
      posicion: map['posicion'] as String,
      hora: map['hora'] as int,
      orden: map['orden'] as int,
      observaciones: map['observaciones'] as String?,
      responsable: map['responsable'] as String?,
    );
  }

  // construye desde json
  factory CreateCambioPosicionDto.fromJson(Map<String, dynamic> json) {
    return CreateCambioPosicionDto.fromFirestore(json);
  }

  // convierte a json
  Map<String, dynamic> toJson() => toFirestore();

  // crea una copia con campos actualizados parcialmente
  CreateCambioPosicionDto copyWith({
    String? posicion,
    int? hora,
    int? orden,
    String? observaciones,
    String? responsable,
  }) {
    return CreateCambioPosicionDto(
      posicion: posicion ?? this.posicion,
      hora: hora ?? this.hora,
      orden: orden ?? this.orden,
      observaciones: observaciones ?? this.observaciones,
      responsable: responsable ?? this.responsable,
    );
  }

  @override
  String toString() {
    return 'CreateCambioPosicionDto('
        'posicion: $posicion, '
        'hora: $hora, '
        'orden: $orden, '
        'observaciones: $observaciones, '
        'responsable: $responsable)';
  }
}
