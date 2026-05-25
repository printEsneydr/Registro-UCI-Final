import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/domain/models/monitoria_hemodinamica.dart';

@immutable
// parametros para consultar una monitoria hemodinamica por ingreso y registro
class ParametrosMonitoriaHemodinamica {
  final String idIngreso;
  final String idRegistroDiario;
  final String? idMonitoria;

  // constructor con los parametros requeridos
  const ParametrosMonitoriaHemodinamica({
    required this.idIngreso,
    required this.idRegistroDiario,
    this.idMonitoria,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParametrosMonitoriaHemodinamica &&
          runtimeType == other.runtimeType &&
          idIngreso == other.idIngreso &&
          idRegistroDiario == other.idRegistroDiario &&
          idMonitoria == other.idMonitoria;

  @override
  int get hashCode => Object.hash(idIngreso, idRegistroDiario, idMonitoria);
}

@immutable
// parametros para guardar (crear o actualizar) una monitoria hemodinamica
class ParametrosGuardarMonitoria {
  final String idIngreso;
  final String idRegistroDiario;
  final int hora;
  final int? pas;
  final int? pad;
  final int? pam;
  final int? fc;
  final int? fr;
  final double? t;
  final int? pvc;
  final int? gc;
  final int? ic;
  final int? rvs;
  final int? irvs;
  final int? fio2;
  final int? pia;
  final int? ppa;
  final int? pic;
  final int? ppc;
  final int? glucometria;
  final int? insulina;
  final int? saturacion;
  final String? idMonitoria;
  final int? orden;

  const ParametrosGuardarMonitoria({
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.hora,
    this.pas,
    this.pad,
    this.pam,
    this.fc,
    this.fr,
    this.t,
    this.pvc,
    this.gc,
    this.ic,
    this.rvs,
    this.irvs,
    this.fio2,
    this.pia,
    this.ppa,
    this.pic,
    this.ppc,
    this.glucometria,
    this.insulina,
    this.saturacion,
    this.idMonitoria,
    this.orden,
  });
}

@immutable
// parametros para reordenar la lista de monitorias
class ParametrosReordenarMonitorias {
  final String idIngreso;
  final String idRegistroDiario;
  final List<String> idsEnOrden;

  const ParametrosReordenarMonitorias({
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.idsEnOrden,
  });
}

// provider que expone un stream en tiempo real de las monitorias
final monitoriasHemodinamicasStreamProvider = StreamProvider.family<
    List<MonitoriaHemodinamica>, ParametrosMonitoriaHemodinamica>(
  (ref, params) {
    final repo = ref.watch(monitoriasHemodinamicaRepositoryProvider);
    return repo.obtenerTodasLasMonitoriasStream(
      idIngreso: params.idIngreso,
      idRegistroDiario: params.idRegistroDiario,
    );
  },
);

// provider que guarda (crea o actualiza) una monitoria en firestore
final guardarMonitoriaHemodinamicaProvider =
    FutureProvider.family<void, ParametrosGuardarMonitoria>(
  (ref, params) async {
    final repo = ref.read(monitoriasHemodinamicaRepositoryProvider);

    try {
      if (params.idMonitoria != null) {
        await repo.actualizarMonitoria(
          idIngreso: params.idIngreso,
          idRegistroDiario: params.idRegistroDiario,
          idMonitoria: params.idMonitoria!,
          hora: params.hora,
          pas: params.pas,
          pad: params.pad,
          pam: params.pam,
          fc: params.fc,
          fr: params.fr,
          t: params.t,
          pvc: params.pvc,
          gc: params.gc,
          ic: params.ic,
          rvs: params.rvs,
          irvs: params.irvs,
          fio2: params.fio2,
          pia: params.pia,
          ppa: params.ppa,
          pic: params.pic,
          ppc: params.ppc,
          glucometria: params.glucometria,
          insulina: params.insulina,
          saturacion: params.saturacion,
          orden: params.orden,
        );
      } else {
        await repo.crearMonitoria(
          idIngreso: params.idIngreso,
          idRegistroDiario: params.idRegistroDiario,
          hora: params.hora,
          pas: params.pas,
          pad: params.pad,
          pam: params.pam,
          fc: params.fc,
          fr: params.fr,
          t: params.t,
          pvc: params.pvc,
          gc: params.gc,
          ic: params.ic,
          rvs: params.rvs,
          irvs: params.irvs,
          fio2: params.fio2,
          pia: params.pia,
          ppa: params.ppa,
          pic: params.pic,
          ppc: params.ppc,
          glucometria: params.glucometria,
          insulina: params.insulina,
          saturacion: params.saturacion,
        );
      }
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      throw Exception('Error al guardar monitoría hemodinámica: $e');
    }
  },
);

// provider que elimina una monitoria de firestore
final eliminarMonitoriaHemodinamicaProvider =
    FutureProvider.family<void, ParametrosMonitoriaHemodinamica>(
  (ref, params) async {
    if (params.idMonitoria == null) return;

    final repo = ref.read(monitoriasHemodinamicaRepositoryProvider);

    try {
      await repo.eliminarMonitoria(
        idIngreso: params.idIngreso,
        idRegistroDiario: params.idRegistroDiario,
        idMonitoria: params.idMonitoria!,
      );
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      throw Exception('Error al eliminar monitoría hemodinámica: $e');
    }
  },
);

// provider que reordena las monitorias segun una lista de ids
final reordenarMonitoriasHemodinamicasProvider =
    FutureProvider.family<void, ParametrosReordenarMonitorias>(
  (ref, params) async {
    final repo = ref.read(monitoriasHemodinamicaRepositoryProvider);

    try {
      await repo.reordenarMonitorias(
        idIngreso: params.idIngreso,
        idRegistroDiario: params.idRegistroDiario,
        idsEnOrden: params.idsEnOrden,
      );
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      throw Exception('Error al reordenar monitorías hemodinámicas: $e');
    }
  },
);
