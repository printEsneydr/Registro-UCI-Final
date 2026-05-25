import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/control_riesgos/data/repositories/firabase_control_de_riesgos.dart';
import 'package:registro_uci/features/control_riesgos/domain/models/control_de_riesgos.dart';
import 'package:registro_uci/features/control_riesgos/data/abstract_repositories/control_de_riesgos_repository.dart';

// provider del repositorio de control de riesgos
final controlDeRiesgosRepositoryProvider =
    Provider<ControlDeRiesgosRepository>((ref) {
  return FirebaseControlDeRiesgosRepository();
});

// provider que expone un stream de controles de riesgos por ingreso y registro
final controlDeRiesgosByIngresoProvider = StreamProvider.family<
    List<ControlDeRiesgos>, ({String idIngreso, String idRegistroDiario})>(
  (ref, params) {
    final repository = ref.watch(controlDeRiesgosRepositoryProvider);
    return repository.getControlDeRiesgos(
      params.idIngreso,
      params.idRegistroDiario,
    );
  },
);

// provider que obtiene un control de riesgos por su id
final controlDeRiesgosByIdProvider = FutureProvider.family<ControlDeRiesgos?,
    ({String idIngreso, String idRegistroDiario, String idControlDeRiesgos})>(
  (ref, params) async {
    final repository = ref.read(controlDeRiesgosRepositoryProvider);
    return await repository.getControlDeRiesgosById(
      params.idIngreso,
      params.idRegistroDiario,
      params.idControlDeRiesgos,
    );
  },
);
