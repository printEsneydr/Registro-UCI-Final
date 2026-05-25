import "dart:collection";

import "package:registro_uci/features/registros_diarios/data/constants/strings.dart";

// dto para crear un registro diario, extiende MapView para serializar a firestore
class CreateRegistroDiarioDto extends MapView<String, dynamic> {
  final DateTime fechaRegistro;

  CreateRegistroDiarioDto({
    required this.fechaRegistro,
  }) : super({
          Strings.fechaRegistro: fechaRegistro,
        });
}
