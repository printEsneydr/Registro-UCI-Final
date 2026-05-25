import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/intervenciones/data/abstract_repositories/intervenciones_de_registro_repository.dart';
import 'package:registro_uci/features/intervenciones/data/providers/intervenciones_de_registro_provider.dart';

// controller para eliminar una intervencion de un registro
class EliminarIntervencionDeRegistroController extends AsyncNotifier<void> {
  late final IntervencionesDeRegistroRepository _repository =
      ref.watch(intervencionesDeRegistroRepositoryProvider);

  // estado inicial del controller
  @override
  FutureOr<void> build() {}

  // elimina una intervencion especifica de un registro
  Future<void> eliminarIntervencionDeRegistro(
    String idIngreso,
    String idRegistro,
    String idIntervencion,
  ) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _repository.eliminarIntervencionDeRegistro(
              idIngreso,
              idRegistro,
              idIntervencion,
            ));
    ref.invalidate(intervencionesDeRegistroProvider(
        ReporteParams(idIngreso: idIngreso, idRegistro: idRegistro)));
  }
}

// provider del controller de eliminacion de intervenciones
final eliminarIntervencionDeRegistroControllerProvider =
    AsyncNotifierProvider<EliminarIntervencionDeRegistroController, void>(
  () => EliminarIntervencionDeRegistroController(),
);
