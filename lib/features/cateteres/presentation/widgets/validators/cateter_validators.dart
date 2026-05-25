import 'package:intl/intl.dart'; // ✅ Importado para el manejo de fechas

// valida que la fecha de colocacion no este vacia
String? fechaColocacionValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "La fecha de colocación es obligatoria.";
  }
  try {
    DateFormat('yyyy-MM-dd')
        .parseStrict(value.trim()); // ✅ Verifica el formato correcto
    return null;
  } catch (_) {
    return "Ingrese una fecha válida (Formato: YYYY-MM-DD).";
  }
}

// valida que el modo del marcapaso haya sido seleccionado
String? modoMarcapasoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Debe seleccionar un modo de marcapaso.";
  }
  return null;
}

// valida que la via del marcapaso haya sido seleccionada
String? viaMarcapasoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Debe seleccionar una vía de marcapaso.";
  }
  return null;
}

// valida que la frecuencia sea un numero entero positivo
String? frecuenciaMarcapasoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Debe ingresar una frecuencia válida.";
  }
  final int? frecuencia = int.tryParse(value.trim());
  if (frecuencia == null || frecuencia <= 0) {
    return "La frecuencia debe ser un número entero positivo.";
  }
  return null;
}

// valida que la sensibilidad sea un numero mayor a 0
String? sensibilidadMarcapasoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Debe ingresar una sensibilidad válida.";
  }
  final double? sensibilidad = double.tryParse(value.trim());
  if (sensibilidad == null || sensibilidad <= 0) {
    return "La sensibilidad debe ser un número mayor a 0.";
  }
  return null;
}

// valida que la salida sea un numero mayor a 0
String? salidaMarcapasoValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Debe ingresar una salida válida.";
  }
  final double? salida = double.tryParse(value.trim());
  if (salida == null || salida <= 0) {
    return "La salida debe ser un número mayor a 0.";
  }
  return null;
}
