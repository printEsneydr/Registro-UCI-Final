// objeto de transferencia de datos para el login
class LoginDto {
  // correo electronico del usuario
  final String email;
  // contrasena del usuario
  final String password;

  // constructor con parametros requeridos
  LoginDto({required this.email, required this.password});
}
