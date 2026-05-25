import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/domain/models/glasgow.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/data/abstract_repositories/glasgow_repository.dart';
import '../../data/providers/glasgow_provider.dart';

// provider del controlador de estado para registros de glasgow
final glasgowControllerProvider =
    StateNotifierProvider<GlasgowController, AsyncValue<List<Glasgow>>>(
  (ref) => GlasgowController(
      ref.watch(glasgowRepositoryProvider)),
);

// controlador que maneja las operaciones crud de glasgow con state notifier
class GlasgowController
    extends StateNotifier<AsyncValue<List<Glasgow>>> {
  final GlasgowRepository _repository;

  GlasgowController(this._repository)
      : super(const AsyncValue.loading());

  // obtiene los registros de glasgow desde firestore via stream
  void fetchGlasgow(String idIngreso, String idRegistroDiario) {
    state = const AsyncValue.loading();
    _repository.getGlasgow(idIngreso, idRegistroDiario).listen(
      (result) {
        state = AsyncValue.data(result);
      },
      onError: (e, stack) {
        state = AsyncValue.error('Error al obtener registros de Glasgow', stack);
      },
    );
  }

  // agrega un nuevo registro de glasgow y refresca la lista
  Future<void> addGlasgow(String idIngreso, String idRegistroDiario,
      Glasgow glasgow) async {
    try {
      await _repository.addGlasgow(
          idIngreso, idRegistroDiario, glasgow);
      fetchGlasgow(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state =
          AsyncValue.error('Error al agregar registro de Glasgow', stack);
    }
  }

  // actualiza un registro de glasgow existente y refresca la lista
  Future<void> updateGlasgow(
      String idIngreso,
      String idRegistroDiario,
      String idGlasgow,
      Glasgow glasgow) async {
    try {
      await _repository.updateGlasgow(
          idIngreso, idRegistroDiario, idGlasgow, glasgow);
      fetchGlasgow(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state =
          AsyncValue.error('Error al actualizar registro de Glasgow', stack);
    }
  }

  // elimina un registro de glasgow y refresca la lista
  Future<void> deleteGlasgow(String idIngreso, String idRegistroDiario,
      String idGlasgow) async {
    try {
      await _repository.deleteGlasgow(
          idIngreso, idRegistroDiario, idGlasgow);
      fetchGlasgow(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state =
          AsyncValue.error('Error al eliminar registro de Glasgow', stack);
    }
  }
}
