// valida que la fecha de colocacion no este vacia
String? fechaColocacionValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "La fecha de colocación es obligatoria.";
  }
  return null;
}

// valida que el modo del marcapaso haya sido seleccionado
String? modoMarcapasoValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Debe seleccionar un modo de marcapaso.";
  }
  return null;
}

// valida que la via del marcapaso haya sido seleccionada
String? viaMarcapasoValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Debe seleccionar una vía de marcapaso.";
  }
  return null;
}

// valida que la frecuencia sea un numero mayor a 0
String? frecuenciaMarcapasoValidator(int? value) {
  if (value == null || value <= 0) {
    return "Debe ingresar una frecuencia válida.";
  }
  return null;
}

// valida que la sensibilidad sea un numero mayor a 0
String? sensibilidadMarcapasoValidator(double? value) {
  if (value == null || value <= 0) {
    return "Debe ingresar una sensibilidad válida.";
  }
  return null;
}

// valida que la salida sea un numero mayor a 0
String? salidaMarcapasoValidator(double? value) {
  if (value == null || value <= 0) {
    return "Debe ingresar una salida válida.";
  }
  return null;
}
