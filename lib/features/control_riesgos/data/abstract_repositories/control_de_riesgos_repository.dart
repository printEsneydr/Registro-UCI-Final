import 'package:registro_uci/features/control_riesgos/domain/models/control_de_riesgos.dart';

// repositorio abstracto para operaciones de control de riesgos
abstract class ControlDeRiesgosRepository {
  // obtiene un stream de controles de riesgos
  Stream<List<ControlDeRiesgos>> getControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
  );

  // agrega un nuevo control de riesgos
  Future<void> addControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
    ControlDeRiesgos controlDeRiesgos,
  );

  // actualiza un control de riesgos existente
  Future<void> updateControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
    String idControlDeRiesgos,
    ControlDeRiesgos controlDeRiesgos,
  );

  // elimina un control de riesgos
  Future<void> deleteControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
    String idControlDeRiesgos,
  );

  // obtiene un control de riesgos por su id
  Future<ControlDeRiesgos?> getControlDeRiesgosById(
    String idIngreso,
    String idRegistroDiario,
    String idControlDeRiesgos,
  );
}
