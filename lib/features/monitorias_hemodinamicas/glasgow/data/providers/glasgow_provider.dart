import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/data/repositories/firebase_glasgow_repository.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/domain/models/glasgow.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/data/abstract_repositories/glasgow_repository.dart';

// provider del repositorio de glasgow
final glasgowRepositoryProvider = Provider<GlasgowRepository>((ref) {
  return FirebaseGlasgowRepository();
});

// provider que expone un stream de los registros de glasgow por ingreso
final glasgowByIngresoProvider = StreamProvider.family<
    List<Glasgow>, ({String idIngreso, String idRegistroDiario})>(
  (ref, params) {
    final repository = ref.watch(glasgowRepositoryProvider);
    return repository.getGlasgow(
      params.idIngreso,
      params.idRegistroDiario,
    );
  },
);

// provider que obtiene un registro de glasgow por su id
final glasgowByIdProvider = FutureProvider.family<
    Glasgow?,
    ({String idIngreso, String idRegistroDiario, String idGlasgow})>(
  (ref, params) async {
    final repository = ref.read(glasgowRepositoryProvider);
    return await repository.getGlasgowById(
      params.idIngreso,
      params.idRegistroDiario,
      params.idGlasgow,
    );
  },
);
