import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/auth/application/auth_service.dart';
import 'package:registro_uci/features/auth/data/dto/login_dto.dart';
import 'package:registro_uci/features/auth/presentation/state/auth_state.dart';

// controlador principal de autenticacion (riverpod async notifier)
class AuthController extends AsyncNotifier<AuthState> {
  // servicio de autenticacion inyectado por riverpod
  late final AuthService _service = ref.watch(authServiceProvider);
  @override
  // construye el estado inicial verificando si hay sesion activa
  FutureOr<AuthState> build() async {
    return _service.getCurrentSession();
  }

  // inicia sesion con las credenciales del dto
  Future<void> login(LoginDto dto) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _service.login(dto),
    );
  }

  // cierra la sesion actual
  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _service.logout(),
    );
  }
}

// provider de riverpod para acceder al AuthController
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(() => AuthController());
