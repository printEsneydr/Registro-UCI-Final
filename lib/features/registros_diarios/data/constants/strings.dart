import 'package:flutter/foundation.dart';

// clase inmutable con constantes de nombres de campos en firestore
@immutable
class Strings {
  // nombre del campo para la fecha del registro diario
  static const String fechaRegistro = 'fechaRegistro';
  // nombre del campo para la firma de necesidades
  static const String firmaNecesidades = 'firmaNecesidades';
  // nombre del campo para observaciones
  static const String observaciones = 'observaciones';
}
