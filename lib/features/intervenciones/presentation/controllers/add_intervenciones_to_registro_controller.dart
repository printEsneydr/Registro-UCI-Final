import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/intervenciones/data/abstract_repositories/intervenciones_de_registro_repository.dart';
import 'package:registro_uci/features/intervenciones/data/providers/intervenciones_de_registro_provider.dart';

// controller para agregar multiples intervenciones a un registro
class AgregarIntervencionesARegistroController extends AsyncNotifier<void> {
  late final IntervencionesDeRegistroRepository _repository =
      ref.watch(intervencionesDeRegistroRepositoryProvider);

  // estado inicial del controller
  @override
  FutureOr<void> build() {}

  // agrega una lista de intervenciones a un registro
  Future<void> agregarIntervencionesARegistro(
    String idIngreso,
    String idRegistro,
    List<String> idsIntervenciones,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.agregarIntervencionesARegistro(
        idIngreso,
        idRegistro,
        idsIntervenciones,
      ),
    );
    ref.invalidate(intervencionesDeRegistroProvider(
        ReporteParams(idIngreso: idIngreso, idRegistro: idRegistro)));
  }
}

// provider del controller para agregar intervenciones
final agregarIntervencionesARegistroControllerProvider =
    AsyncNotifierProvider<AgregarIntervencionesARegistroController, void>(
  () => AgregarIntervencionesARegistroController(),
);
