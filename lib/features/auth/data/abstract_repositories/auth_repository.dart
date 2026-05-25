import 'package:firebase_auth/firebase_auth.dart';
import 'package:registro_uci/features/auth/data/dto/login_dto.dart';
import 'package:registro_uci/features/auth/presentation/state/auth_state.dart';

// interfaz abstracta para el repositorio de autenticacion
abstract class IAuthRepository {
  // id del usuario autenticado o null
  String? get userId;
  // nombre del usuario autenticado
  String get displayName;
  // stream de cambios en la autenticacion
  Stream<User?> get authStateChanges;

  // cierra la sesion
  Future<void> logout();
  // inicia sesion con credenciales
  Future<AuthResult> login(LoginDto dto);
}
