// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cateter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CateterImpl _$$CateterImplFromJson(Map<String, dynamic> json) =>
    _$CateterImpl(
      id: json['id'] as String,
      tipo: json['tipo'] as String,
      via: json['via'] as String,
      fechaInsercion: DateTime.parse(json['fechaInsercion'] as String),
      fechaRetiro: json['fechaRetiro'] == null
          ? null
          : DateTime.parse(json['fechaRetiro'] as String),
      fechaCuracionOCambio: json['fechaCuracionOCambio'] == null
          ? null
          : DateTime.parse(json['fechaCuracionOCambio'] as String),
      caracteristicasSitioInsercion:
          json['caracteristicasSitioInsercion'] as String,
    );

Map<String, dynamic> _$$CateterImplToJson(_$CateterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo': instance.tipo,
      'via': instance.via,
      'fechaInsercion': instance.fechaInsercion.toIso8601String(),
      'fechaRetiro': instance.fechaRetiro?.toIso8601String(),
      'fechaCuracionOCambio': instance.fechaCuracionOCambio?.toIso8601String(),
      'caracteristicasSitioInsercion': instance.caracteristicasSitioInsercion,
    };
