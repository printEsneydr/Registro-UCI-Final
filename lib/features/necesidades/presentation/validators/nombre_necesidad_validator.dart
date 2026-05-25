// validador que verifica que el nombre de la necesidad no este vacio
String? Function(String?) nombreNecesidadValidator = (String? value) {
  if (value == null || value == '') {
    return 'Este campo es obligatorio';
  }
  return null;
};
