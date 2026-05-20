// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firma.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Firma {
  String get nombreFirma => throw _privateConstructorUsedError;
  DateTime get fechaFirma => throw _privateConstructorUsedError;
  String get tipoPersonal => throw _privateConstructorUsedError;
  String get turno => throw _privateConstructorUsedError;

  /// Create a copy of Firma
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FirmaCopyWith<Firma> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirmaCopyWith<$Res> {
  factory $FirmaCopyWith(Firma value, $Res Function(Firma) then) =
      _$FirmaCopyWithImpl<$Res, Firma>;
  @useResult
  $Res call(
      {String nombreFirma,
      DateTime fechaFirma,
      String tipoPersonal,
      String turno});
}

/// @nodoc
class _$FirmaCopyWithImpl<$Res, $Val extends Firma>
    implements $FirmaCopyWith<$Res> {
  _$FirmaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Firma
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombreFirma = null,
    Object? fechaFirma = null,
    Object? tipoPersonal = null,
    Object? turno = null,
  }) {
    return _then(_value.copyWith(
      nombreFirma: null == nombreFirma
          ? _value.nombreFirma
          : nombreFirma // ignore: cast_nullable_to_non_nullable
              as String,
      fechaFirma: null == fechaFirma
          ? _value.fechaFirma
          : fechaFirma // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tipoPersonal: null == tipoPersonal
          ? _value.tipoPersonal
          : tipoPersonal // ignore: cast_nullable_to_non_nullable
              as String,
      turno: null == turno
          ? _value.turno
          : turno // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FirmaImplCopyWith<$Res> implements $FirmaCopyWith<$Res> {
  factory _$$FirmaImplCopyWith(
          _$FirmaImpl value, $Res Function(_$FirmaImpl) then) =
      __$$FirmaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String nombreFirma,
      DateTime fechaFirma,
      String tipoPersonal,
      String turno});
}

/// @nodoc
class __$$FirmaImplCopyWithImpl<$Res>
    extends _$FirmaCopyWithImpl<$Res, _$FirmaImpl>
    implements _$$FirmaImplCopyWith<$Res> {
  __$$FirmaImplCopyWithImpl(
      _$FirmaImpl _value, $Res Function(_$FirmaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Firma
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nombreFirma = null,
    Object? fechaFirma = null,
    Object? tipoPersonal = null,
    Object? turno = null,
  }) {
    return _then(_$FirmaImpl(
      nombreFirma: null == nombreFirma
          ? _value.nombreFirma
          : nombreFirma // ignore: cast_nullable_to_non_nullable
              as String,
      fechaFirma: null == fechaFirma
          ? _value.fechaFirma
          : fechaFirma // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tipoPersonal: null == tipoPersonal
          ? _value.tipoPersonal
          : tipoPersonal // ignore: cast_nullable_to_non_nullable
              as String,
      turno: null == turno
          ? _value.turno
          : turno // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FirmaImpl implements _Firma {
  const _$FirmaImpl(
      {required this.nombreFirma,
      required this.fechaFirma,
      this.tipoPersonal = 'ENFERMERA',
      this.turno = ''});

  @override
  final String nombreFirma;
  @override
  final DateTime fechaFirma;
  @override
  @JsonKey()
  final String tipoPersonal;
  @override
  @JsonKey()
  final String turno;

  @override
  String toString() {
    return 'Firma(nombreFirma: $nombreFirma, fechaFirma: $fechaFirma, tipoPersonal: $tipoPersonal, turno: $turno)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FirmaImpl &&
            (identical(other.nombreFirma, nombreFirma) ||
                other.nombreFirma == nombreFirma) &&
            (identical(other.fechaFirma, fechaFirma) ||
                other.fechaFirma == fechaFirma) &&
            (identical(other.tipoPersonal, tipoPersonal) ||
                other.tipoPersonal == tipoPersonal) &&
            (identical(other.turno, turno) || other.turno == turno));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nombreFirma, fechaFirma, tipoPersonal, turno);

  /// Create a copy of Firma
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FirmaImplCopyWith<_$FirmaImpl> get copyWith =>
      __$$FirmaImplCopyWithImpl<_$FirmaImpl>(this, _$identity);
}

abstract class _Firma implements Firma {
  const factory _Firma(
      {required final String nombreFirma,
      required final DateTime fechaFirma,
      final String tipoPersonal,
      final String turno}) = _$FirmaImpl;

  @override
  String get nombreFirma;
  @override
  DateTime get fechaFirma;
  @override
  String get tipoPersonal;
  @override
  String get turno;

  /// Create a copy of Firma
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FirmaImplCopyWith<_$FirmaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
