// valida que el email tenga formato correcto y no este vacio
String? Function(String?) emailValidator = (String? value) {
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  } else if (!emailRegex.hasMatch(value)) {
    return 'Introduce un correo válido';
  }

  return null;
};
