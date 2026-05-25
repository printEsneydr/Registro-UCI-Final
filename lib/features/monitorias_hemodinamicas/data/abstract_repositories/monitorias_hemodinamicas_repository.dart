import 'package:registro_uci/features/monitorias_hemodinamicas/domain/models/monitoria_hemodinamica.dart';

// repositorio abstracto que define el contrato para monitorias hemodinamicas
abstract class MonitoriaHemodinamicaRepository {
  // obtiene un stream en tiempo real de todas las monitorias
  Stream<List<MonitoriaHemodinamica>> obtenerTodasLasMonitoriasStream({
    required String idIngreso,
    required String idRegistroDiario,
  });

  // obtiene todas las monitorias como future
  Future<List<MonitoriaHemodinamica>> obtenerTodasLasMonitorias({
    required String idIngreso,
    required String idRegistroDiario,
  });

  // obtiene una monitoria especifica por su id
  Future<MonitoriaHemodinamica?> obtenerMonitoriaPorId({
    required String idIngreso,
    required String idRegistroDiario,
    required String idMonitoria,
  });

  // crea una nueva monitoria con todos los parametros hemodinamicos
  Future<void> crearMonitoria({
    required String idIngreso,
    required String idRegistroDiario,
    required int hora,
    int? pas,
    int? pad,
    int? pam,
    int? fc,
    int? fr,
    double? t,
    int? pvc,
    int? gc,
    int? ic,
    int? rvs,
    int? irvs,
    int? fio2,
    int? pia,
    int? ppa,
    int? pic,
    int? ppc,
    int? glucometria,
    int? insulina,
    int? saturacion,
  });

  // actualiza una monitoria existente
  Future<void> actualizarMonitoria({
    required String idIngreso,
    required String idRegistroDiario,
    required String idMonitoria,
    required int hora,
    int? pas,
    int? pad,
    int? pam,
    int? fc,
    int? fr,
    double? t,
    int? pvc,
    int? gc,
    int? ic,
    int? rvs,
    int? irvs,
    int? fio2,
    int? pia,
    int? ppa,
    int? pic,
    int? ppc,
    int? glucometria,
    int? insulina,
    int? saturacion,
    int? orden,
  });

  // elimina una monitoria por su id
  Future<void> eliminarMonitoria({
    required String idIngreso,
    required String idRegistroDiario,
    required String idMonitoria,
  });

  // reordena las monitorias segun una lista de ids
  Future<void> reordenarMonitorias({
    required String idIngreso,
    required String idRegistroDiario,
    required List<String> idsEnOrden,
  });
}
