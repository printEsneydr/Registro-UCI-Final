import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registro_uci/features/auth/data/abstract_repositories/auth_repository.dart';
import 'package:registro_uci/features/auth/data/dto/login_dto.dart';
import 'package:registro_uci/features/auth/presentation/state/auth_state.dart';

// implementacion con firebase authentication del repositorio de auth
class FirebaseAuthRepository implements IAuthRepository {
  // constructor constante
  const FirebaseAuthRepository();

  // devuelve el uid del usuario actual o null
  @override
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  // devuelve el nombre del usuario actual o string vacio
  @override
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  // stream que notifica cambios en el estado de autenticacion
  @override
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  // cierra la sesion en firebase
  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // inicia sesion con email y contrasena en firebase
  @override
  Future<AuthResult> login(LoginDto dto) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: dto.email, password: dto.password);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'user-not-found') {
        throw Exception('Correo no registrado');
      } else if (e.code == 'wrong-password') {
        throw Exception('Credenciales inválidas');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Credenciales inválidas');
      } else if (e.code == 'invalid-email') {
        throw Exception('Correo no válido');
      }
    }

    return AuthResult.success;
  }
}
