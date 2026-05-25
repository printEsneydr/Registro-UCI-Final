import 'package:registro_uci/features/auth/domain/constants/strings.dart';

// enumeracion con los roles de usuario del sistema
enum UserRole {
  // administrador del sistema
  admin,
  // enfermero jefe
  headNurse,
  // enfermero auxiliar
  auxNurse,
  // nutricionista
  nutritionist,
  // medico
  doctor,
  // invitado sin permisos especiales
  guest,
}

// extension para convertir un string a UserRole
extension ToUserRole on String {
  UserRole toUserRole() {
    switch (this) {
      case Strings.admin:
        return UserRole.admin;
      case Strings.headNurse:
        return UserRole.headNurse;
      case Strings.auxNurse:
        return UserRole.auxNurse;
      case Strings.nutritionist:
        return UserRole.nutritionist;
      case Strings.doctor:
        return UserRole.doctor;
      default:
        return UserRole.guest;
    }
  }
}

// extension para convertir un UserRole a string
extension RoleToString on UserRole {
  String roleToString() {
    switch (this) {
      case UserRole.admin:
        return Strings.admin;
      case UserRole.headNurse:
        return Strings.headNurse;
      case UserRole.auxNurse:
        return Strings.auxNurse;
      case UserRole.nutritionist:
        return Strings.nutritionist;
      case UserRole.doctor:
        return Strings.doctor;
      case UserRole.guest:
        return Strings.guest;
    }
  }
}
