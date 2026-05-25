// error que se lanza cuando la sesion del usuario expira
class SessionExpiredError implements Exception {
  final String error;

  // constructor con mensaje de error por defecto
  SessionExpiredError([
    this.error = 'Sesión expirada. Vuelva a Iniciar Sesión',
  ]);

  @override
  String toString() {
    return error;
  }
}
