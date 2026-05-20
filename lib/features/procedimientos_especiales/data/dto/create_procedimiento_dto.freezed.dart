// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_procedimiento_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateProcedimientoDto _$CreateProcedimientoDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateProcedimientoDto.fromJson(json);
}

/// @nodoc
mixin _$CreateProcedimientoDto {
  String get nombreProcedimiento => throw _privateConstructorUsedError;
  String get estado => throw _privateConstructorUsedError;
  String? get medicamentoInfusion => throw _privateConstructorUsedError;
  String? get dosisInfusion => throw _privateConstructorUsedError;

  /// Serializes this CreateProcedimientoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateProcedimientoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateProcedimientoDtoCopyWith<CreateProcedimientoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProcedimientoDtoCopyWith<$Res> {
  factory $CreateProcedimientoDtoCopyWith(CreateProcedimientoDto value,
          $Res Function(CreateProcedimientoDto) then) =
      _$CreateProcedimientoDtoCopyWithImpl<$Res, CreateProcedimientoDto>;
  @useResult
  $Res call(
      {String nombreProcedimiento,
      String estado,
      String? medicamentoInfusion,
      String? dosisInfusion});
}

/// @nodoc
class _$CreateProcedimientoDtoCopyWithImpl<$Res,
        $Val extends CreateProcedimientoDto>
    implements $CreateProcedimientoDtoCopyWith<$Res> {
  _$CreateProcedimientoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateProcedimientoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombreProcedimiento = null,
    Object? estado = null,
    Object? medicamentoInfusion = freezed,
    Object? dosisInfusion = freezed,
  }) {
    return _then(_value.copyWith(
      nombreProcedimiento: null == nombreProcedimiento
          ? _value.nombreProcedimiento
          : nombreProcedimiento // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      medicamentoInfusion: freezed == medicamentoInfusion
          ? _value.medicamentoInfusion
          : medicamentoInfusion // ignore: cast_nullable_to_non_nullable
              as String?,
      dosisInfusion: freezed == dosisInfusion
          ? _value.dosisInfusion
          : dosisInfusion // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateProcedimientoDtoImplCopyWith<$Res>
    implements $CreateProcedimientoDtoCopyWith<$Res> {
  factory _$$CreateProcedimientoDtoImplCopyWith(
          _$CreateProcedimientoDtoImpl value,
          $Res Function(_$CreateProcedimientoDtoImpl) then) =
      __$$CreateProcedimientoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String nombreProcedimiento,
      String estado,
      String? medicamentoInfusion,
      String? dosisInfusion});
}

/// @nodoc
class __$$CreateProcedimientoDtoImplCopyWithImpl<$Res>
    extends _$CreateProcedimientoDtoCopyWithImpl<$Res,
        _$CreateProcedimientoDtoImpl>
    implements _$$CreateProcedimientoDtoImplCopyWith<$Res> {
  __$$CreateProcedimientoDtoImplCopyWithImpl(
      _$CreateProcedimientoDtoImpl _value,
      $Res Function(_$CreateProcedimientoDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateProcedimientoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombreProcedimiento = null,
    Object? estado = null,
    Object? medicamentoInfusion = freezed,
    Object? dosisInfusion = freezed,
  }) {
    return _then(_$CreateProcedimientoDtoImpl(
      nombreProcedimiento: null == nombreProcedimiento
          ? _value.nombreProcedimiento
          : nombreProcedimiento // ignore: cast_nullable_to_non_nullable
              as String,
      estado: null == estado
          ? _value.estado
          : estado // ignore: cast_nullable_to_non_nullable
              as String,
      medicamentoInfusion: freezed == medicamentoInfusion
          ? _value.medicamentoInfusion
          : medicamentoInfusion // ignore: cast_nullable_to_non_nullable
              as String?,
      dosisInfusion: freezed == dosisInfusion
          ? _value.dosisInfusion
          : dosisInfusion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateProcedimientoDtoImpl implements _CreateProcedimientoDto {
  const _$CreateProcedimientoDtoImpl(
      {required this.nombreProcedimiento,
      this.estado = "Por realizar",
      this.medicamentoInfusion,
      this.dosisInfusion});

  factory _$CreateProcedimientoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateProcedimientoDtoImplFromJson(json);

  @override
  final String nombreProcedimiento;
  @override
  @JsonKey()
  final String estado;
  @override
  final String? medicamentoInfusion;
  @override
  final String? dosisInfusion;

  @override
  String toString() {
    return 'CreateProcedimientoDto(nombreProcedimiento: $nombreProcedimiento, estado: $estado, medicamentoInfusion: $medicamentoInfusion, dosisInfusion: $dosisInfusion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateProcedimientoDtoImpl &&
            (identical(other.nombreProcedimiento, nombreProcedimiento) ||
                other.nombreProcedimiento == nombreProcedimiento) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.medicamentoInfusion, medicamentoInfusion) ||
                other.medicamentoInfusion == medicamentoInfusion) &&
            (identical(other.dosisInfusion, dosisInfusion) ||
                other.dosisInfusion == dosisInfusion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nombreProcedimiento, estado,
      medicamentoInfusion, dosisInfusion);

  /// Create a copy of CreateProcedimientoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateProcedimientoDtoImplCopyWith<_$CreateProcedimientoDtoImpl>
      get copyWith => __$$CreateProcedimientoDtoImplCopyWithImpl<
          _$CreateProcedimientoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateProcedimientoDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateProcedimientoDto implements CreateProcedimientoDto {
  const factory _CreateProcedimientoDto(
      {required final String nombreProcedimiento,
      final String estado,
      final String? medicamentoInfusion,
      final String? dosisInfusion}) = _$CreateProcedimientoDtoImpl;

  factory _CreateProcedimientoDto.fromJson(Map<String, dynamic> json) =
      _$CreateProcedimientoDtoImpl.fromJson;

  @override
  String get nombreProcedimiento;
  @override
  String get estado;
  @override
  String? get medicamentoInfusion;
  @override
  String? get dosisInfusion;

  /// Create a copy of CreateProcedimientoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateProcedimientoDtoImplCopyWith<_$CreateProcedimientoDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
