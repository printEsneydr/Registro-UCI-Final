// validador de campo obligatorio para la fecha de registro
String? Function(String?) fechaRegistroValidator = (String? value) {
  if (value == null || value.isEmpty) {
    return 'Este campo es obligatorio';
  }
  return null;
};
