import 'package:registro_uci/features/auth/domain/models/user.dart';

// interfaz abstracta para el repositorio de usuarios
abstract class IUsersRepository {
  // busca un usuario por su id, devuelve null si no existe
  Future<User?> findUser(String userId);
}
