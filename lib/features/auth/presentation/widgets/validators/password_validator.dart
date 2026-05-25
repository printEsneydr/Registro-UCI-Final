// valida que el campo de contrasena no este vacio
String? Function(String?) passwordValidator = (String? value) {
  if (value == null || value == '') {
    return 'Este campo es obligatorio';
  }
  return null;
};
