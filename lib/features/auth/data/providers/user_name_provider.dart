import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/auth/presentation/controllers/auth_controller.dart';

// provider que expone el nombre del usuario desde el estado de auth
final userNameProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).when(
        data: (data) {
          return data.user?.name;
        },
        error: (error, stackTrace) => null,
        loading: () => null,
      );
});
