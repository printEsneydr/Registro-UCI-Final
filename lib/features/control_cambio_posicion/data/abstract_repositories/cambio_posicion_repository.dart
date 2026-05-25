import 'package:registro_uci/features/control_cambio_posicion/domain/models/cambio_posicion.dart';

// repositorio abstracto para operaciones de cambios de posicion
abstract class CambioPosicionRepository {
  // obtiene todos los cambios de posicion de un registro diario
  Future<List<CambioDePosicion>> getCambiosDePosicion(
    String idIngreso,
    String idRegistroDiario,
  );

  // obtiene un cambio de posicion por su id
  Future<CambioDePosicion?> getCambioPosicionById(
    String idIngreso,
    String idRegistroDiario,
    String idCambioPosicion,
  );

  // obtiene el ultimo cambio de posicion registrado
  Future<CambioDePosicion?> getUltimoCambioPosicion(
    String idIngreso,
    String idRegistroDiario,
  );

  // guarda un nuevo cambio de posicion
  Future<void> guardarCambioPosicion(
    String idIngreso,
    String idRegistroDiario,
    int hora,
    String posicion,
  );

  // actualiza un cambio de posicion existente
  Future<void> actualizarCambioPosicion(
    String idIngreso,
    String idRegistroDiario,
    String idCambioPosicion,
    int hora,
    String posicion, {
    int? orden,
  });

  // elimina un cambio de posicion
  Future<void> eliminarCambioPosicion(
    String idIngreso,
    String idRegistroDiario,
    String idCambioPosicion,
  );

  // obtiene resumen de posiciones con conteo de cada una
  Future<Map<String, int>> getResumenPosiciones(
    String idIngreso,
    String idRegistroDiario,
  );

  // reordena los cambios de posicion segun lista de ids
  Future<void> reordenarCambiosPosicion(
    String idIngreso,
    String idRegistroDiario,
    List<String> idsEnOrden,
  );
}
