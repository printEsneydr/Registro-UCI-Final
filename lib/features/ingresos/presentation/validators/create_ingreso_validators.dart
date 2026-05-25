// validaciones de los campos del formulario de creacion de ingreso

// valida que el nombre del paciente no este vacio
String? Function(String?) nombrePacienteValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};

// valida que la identificacion sea numerica y no este vacia
String? Function(String?) identificacionPacienteValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Introduce un número válido';
  }
  return null;
};

// valida que la carpeta sea numerica y no este vacia
String? Function(String?) carpetaValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Solo se permiten números';
  }
  return null;
};

// valida el formato de fecha yyyy-mm-dd
String? Function(String?) fechaNacimientoValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  // Validar el formato YYYY-MM-DD
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
    return 'Formato de fecha incorrecto (YYYY-MM-DD)';
  }
  return null;
};

// valida que el peso sea un numero valido
String? Function(String?) pesoValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  } else if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
    return 'Introduce un peso válido';
  }
  return null;
};

// valida que la talla sea un numero valido
String? Function(String?) tallaValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  } else if (!RegExp(r'^\d*\.?\d+$').hasMatch(value)) {
    return 'Introduce una talla válida (ej. 170 o 170.5)';
  }
  return null;
};

// valida que la cama no este vacia
String? Function(String?) camaValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};

// valida que el diagnostico de ingreso no este vacio
String? Function(String?) diagnosticoIngresoValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};

// valida que el nombre del familiar no este vacio
String? Function(String?) nombreFamiliarValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};

// valida que la sala haya sido seleccionada
String? Function(String?) salaValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};

// valida que el parentesco no este vacio
String? Function(String?) parentescoFamiliarValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};

// valida que se especifique el parentesco cuando se selecciona "otro"
String? Function(String?) otherParentescoFamiliarValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Debes especificar el parentesco';
  }
  return null;
};

// valida que la eps o arl haya sido seleccionada
String? Function(String?) epsOArlValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};

// valida que se especifique la eps cuando se selecciona "otro"
String? Function(String?) otherEpsArlValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Debes especificar la EPS o ARL';
  }
  return null;
};

// valida que el telefono tenga exactamente 10 digitos (colombia)
String? Function(String?) telefonoFamiliarValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  } else if (!RegExp(r'^\d+$').hasMatch(value)) {
    return 'Solo se permiten números';
  } else if (value.length != 10) {
    return 'El número telefónico debe contener 10 dígitos';
  }
  return null;
};
