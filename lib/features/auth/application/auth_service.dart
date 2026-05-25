import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';
import 'package:registro_uci/features/auth/data/abstract_repositories/auth_repository.dart';
import 'package:registro_uci/features/auth/data/abstract_repositories/users_repository.dart';
import 'package:registro_uci/features/auth/data/dto/login_dto.dart';
import 'package:registro_uci/features/auth/presentation/state/auth_state.dart';

// logica de negocio de autenticacion, orquesta auth y users
class AuthService {
  final IAuthRepository _authRepository;
  final IUsersRepository _usersRepository;

  // constructor que recibe los repositorios por inyeccion
  AuthService(
      {required IAuthRepository authRepository,
      required IUsersRepository usersRepository})
      : _authRepository = authRepository,
        _usersRepository = usersRepository;

  // inicia sesion y devuelve el estado con el usuario si es exitoso
  Future<AuthState> login(LoginDto dto) async {
    final AuthResult result = await _authRepository.login(dto);

    final String? userId = _authRepository.userId;

    if (result == AuthResult.success && userId != null) {
      final user = await _usersRepository.findUser(userId);

      if (user != null) {
        return AuthState(result, user);
      }
    }
    return AuthState(AuthResult.failure, null);
  }

  // cierra sesion y devuelve estado de logout
  Future<AuthState> logout() async {
    await _authRepository.logout();
    return AuthState(AuthResult.logout, null);
  }

  // verifica si hay un usuario con sesion activa y lo devuelve
  Future<AuthState> getCurrentSession() async {
    final String? userId = _authRepository.userId;
    if (userId != null) {
      final user = await _usersRepository.findUser(userId);

      if (user != null) {
        return AuthState(AuthResult.success, user);
      }
    }
    return AuthState(AuthResult.logout, null);
  }
}

// provider de riverpod que construye el AuthService con sus dependencias
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    authRepository: ref.watch(authRepositoryProvider),
    usersRepository: ref.watch(usersRepositoryProvider),
  );
});
