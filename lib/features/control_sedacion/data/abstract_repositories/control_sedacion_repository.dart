import 'package:registro_uci/features/control_sedacion/domain/models/control_sedacion.dart';

// repositorio abstracto para el control de sedacion
abstract class ControlSedacionRepository {
  // obtiene un stream de todos los controles de sedacion registrados
  Stream<List<ControlSedacion>> getControlesSedacionStream(
    String idIngreso,
    String idRegistroDiario,
  );

  // obtiene todos los controles de sedacion registrados
  Future<List<ControlSedacion>> getControlesSedacion(
    String idIngreso,
    String idRegistroDiario,
  );

  // obtiene un control de sedacion especifico por su id
  Future<ControlSedacion?> getControlSedacionById(
    String idIngreso,
    String idRegistroDiario,
    String idControlSedacion,
  );

  // obtiene el ultimo control de sedacion registrado
  Future<ControlSedacion?> getUltimoControlSedacion(
    String idIngreso,
    String idRegistroDiario,
  );

  // guarda un nuevo control de sedacion
  Future<void> guardarControlSedacion(
    String idIngreso,
    String idRegistroDiario,
    int hora,
    String observacion,
    int rass,
  );

  // actualiza un control de sedacion existente
  Future<void> actualizarControlSedacion(
    String idIngreso,
    String idRegistroDiario,
    String idControlSedacion,
    int hora,
    String observacion,
    int rass, {
    int? orden,
  });

  // elimina un control de sedacion
  Future<void> eliminarControlSedacion(
    String idIngreso,
    String idRegistroDiario,
    String idControlSedacion,
  );

  // obtiene un resumen de los valores rass registrados
  Future<Map<String, int>> getResumenRASS(
    String idIngreso,
    String idRegistroDiario,
  );

  // reordena los controles de sedacion segun lista de ids
  Future<void> reordenarControlesSedacion(
    String idIngreso,
    String idRegistroDiario,
    List<String> idsEnOrden,
  );
}
