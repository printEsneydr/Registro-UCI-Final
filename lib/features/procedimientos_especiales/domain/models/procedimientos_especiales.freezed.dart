// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procedimientos_especiales.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProcedimientoEspecial {
  String get idProcedimiento => throw _privateConstructorUsedError;
  String get nombreProcedimiento => throw _privateConstructorUsedError;
  String get estado =>
      throw _privateConstructorUsedError; // "Por realizar", "Realizado", "Reportado"
  String? get medicamentoInfusion => throw _privateConstructorUsedError;
  String? get dosisInfusion => throw _privateConstructorUsedError;

  /// Create a copy of ProcedimientoEspecial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcedimientoEspecialCopyWith<ProcedimientoEspecial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcedimientoEspecialCopyWith<$Res> {
  factory $ProcedimientoEspecialCopyWith(ProcedimientoEspecial value,
          $Res Function(ProcedimientoEspecial) then) =
      _$ProcedimientoEspecialCopyWithImpl<$Res, ProcedimientoEspecial>;
  @useResult
  $Res call(
      {String idProcedimiento,
      String nombreProcedimiento,
      String estado,
      String? medicamentoInfusion,
      String? dosisInfusion});
}

/// @nodoc
class _$ProcedimientoEspecialCopyWithImpl<$Res,
        $Val extends ProcedimientoEspecial>
    implements $ProcedimientoEspecialCopyWith<$Res> {
  _$ProcedimientoEspecialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcedimientoEspecial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idProcedimiento = null,
    Object? nombreProcedimiento = null,
    Object? estado = null,
    Object? medicamentoInfusion = freezed,
    Object? dosisInfusion = freezed,
  }) {
    return _then(_value.copyWith(
      idProcedimiento: null == idProcedimiento
          ? _value.idProcedimiento
          : idProcedimiento // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$ProcedimientoEspecialImplCopyWith<$Res>
    implements $ProcedimientoEspecialCopyWith<$Res> {
  factory _$$ProcedimientoEspecialImplCopyWith(
          _$ProcedimientoEspecialImpl value,
          $Res Function(_$ProcedimientoEspecialImpl) then) =
      __$$ProcedimientoEspecialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String idProcedimiento,
      String nombreProcedimiento,
      String estado,
      String? medicamentoInfusion,
      String? dosisInfusion});
}

/// @nodoc
class __$$ProcedimientoEspecialImplCopyWithImpl<$Res>
    extends _$ProcedimientoEspecialCopyWithImpl<$Res,
        _$ProcedimientoEspecialImpl>
    implements _$$ProcedimientoEspecialImplCopyWith<$Res> {
  __$$ProcedimientoEspecialImplCopyWithImpl(_$ProcedimientoEspecialImpl _value,
      $Res Function(_$ProcedimientoEspecialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProcedimientoEspecial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idProcedimiento = null,
    Object? nombreProcedimiento = null,
    Object? estado = null,
    Object? medicamentoInfusion = freezed,
    Object? dosisInfusion = freezed,
  }) {
    return _then(_$ProcedimientoEspecialImpl(
      idProcedimiento: null == idProcedimiento
          ? _value.idProcedimiento
          : idProcedimiento // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$ProcedimientoEspecialImpl implements _ProcedimientoEspecial {
  const _$ProcedimientoEspecialImpl(
      {required this.idProcedimiento,
      required this.nombreProcedimiento,
      required this.estado,
      this.medicamentoInfusion,
      this.dosisInfusion});

  @override
  final String idProcedimiento;
  @override
  final String nombreProcedimiento;
  @override
  final String estado;
// "Por realizar", "Realizado", "Reportado"
  @override
  final String? medicamentoInfusion;
  @override
  final String? dosisInfusion;

  @override
  String toString() {
    return 'ProcedimientoEspecial(idProcedimiento: $idProcedimiento, nombreProcedimiento: $nombreProcedimiento, estado: $estado, medicamentoInfusion: $medicamentoInfusion, dosisInfusion: $dosisInfusion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcedimientoEspecialImpl &&
            (identical(other.idProcedimiento, idProcedimiento) ||
                other.idProcedimiento == idProcedimiento) &&
            (identical(other.nombreProcedimiento, nombreProcedimiento) ||
                other.nombreProcedimiento == nombreProcedimiento) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.medicamentoInfusion, medicamentoInfusion) ||
                other.medicamentoInfusion == medicamentoInfusion) &&
            (identical(other.dosisInfusion, dosisInfusion) ||
                other.dosisInfusion == dosisInfusion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, idProcedimiento,
      nombreProcedimiento, estado, medicamentoInfusion, dosisInfusion);

  /// Create a copy of ProcedimientoEspecial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcedimientoEspecialImplCopyWith<_$ProcedimientoEspecialImpl>
      get copyWith => __$$ProcedimientoEspecialImplCopyWithImpl<
          _$ProcedimientoEspecialImpl>(this, _$identity);
}

abstract class _ProcedimientoEspecial implements ProcedimientoEspecial {
  const factory _ProcedimientoEspecial(
      {required final String idProcedimiento,
      required final String nombreProcedimiento,
      required final String estado,
      final String? medicamentoInfusion,
      final String? dosisInfusion}) = _$ProcedimientoEspecialImpl;

  @override
  String get idProcedimiento;
  @override
  String get nombreProcedimiento;
  @override
  String get estado; // "Por realizar", "Realizado", "Reportado"
  @override
  String? get medicamentoInfusion;
  @override
  String? get dosisInfusion;

  /// Create a copy of ProcedimientoEspecial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcedimientoEspecialImplCopyWith<_$ProcedimientoEspecialImpl>
      get copyWith => throw _privateConstructorUsedError;
}
