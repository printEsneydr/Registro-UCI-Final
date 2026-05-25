import "dart:collection";

import "package:registro_uci/features/necesidades/data/constants/strings.dart";

// dto para actualizar una necesidad, extiende MapView para usar con firestore
class UpdateNecesidadDto extends MapView<String, dynamic> {
  final String? nombreNecesidad;

  UpdateNecesidadDto({
    this.nombreNecesidad,
  }) : super({
          if (nombreNecesidad != null) Strings.nombreNecesidad: nombreNecesidad,
        });
}
