import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/intervenciones/data/abstract_repositories/intervenciones_de_registro_repository.dart';
import 'package:registro_uci/features/intervenciones/data/providers/intervenciones_de_registro_provider.dart';

// controller para importar intervenciones de un registro a otro
class ImportIntervencionesDeRegistroController extends AsyncNotifier<void> {
  late final IntervencionesDeRegistroRepository _repository =
      ref.watch(intervencionesDeRegistroRepositoryProvider);

  // estado inicial del controller
  @override
  FutureOr<void> build() {}

  // importa las intervenciones desde un registro origen a uno destino
  Future<void> importIntervencionesFromRegistro(
    String idIngreso,
    String originRegistro,
    String targetRegistro,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => _repository.importIntervencionesFromRegistro(
              idIngreso,
              originRegistro,
              targetRegistro,
            ));
    ref.invalidate(intervencionesDeRegistroProvider(
        ReporteParams(idIngreso: idIngreso, idRegistro: targetRegistro)));
  }
}

// provider del controller de importacion de intervenciones
final importIntervencionesDeRegistroControllerProvider =
    AsyncNotifierProvider<ImportIntervencionesDeRegistroController, void>(
  () => ImportIntervencionesDeRegistroController(),
);
