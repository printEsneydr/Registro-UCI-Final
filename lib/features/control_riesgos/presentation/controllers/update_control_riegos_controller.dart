import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/control_riesgos/domain/models/control_de_riesgos.dart';
import 'package:registro_uci/features/control_riesgos/data/abstract_repositories/control_de_riesgos_repository.dart';
import '../../data/providers/control_de_riesgos_provider.dart'; // Asegúrate de importar el provider del repositorio

// provider del controller para actualizar controles de riesgos
final updateControlRiesgosControllerProvider = StateNotifierProvider<
    UpdateControlRiesgosController, AsyncValue<List<ControlDeRiesgos>>>(
  (ref) => UpdateControlRiesgosController(
      ref.watch(controlDeRiesgosRepositoryProvider)),
);

// controller que maneja la actualizacion y eliminacion de controles de riesgos
class UpdateControlRiesgosController
    extends StateNotifier<AsyncValue<List<ControlDeRiesgos>>> {
  final ControlDeRiesgosRepository _repository;

  UpdateControlRiesgosController(this._repository)
      : super(const AsyncValue.loading());

  // obtiene la lista de controles de riesgos en tiempo real
  void fetchControlDeRiesgos(String idIngreso, String idRegistroDiario) {
    state = const AsyncValue.loading();

    _repository.getControlDeRiesgos(idIngreso, idRegistroDiario).listen(
      (result) {
        state = AsyncValue.data(result);
      },
      onError: (e, stack) {
        state = AsyncValue.error(
          'Error al obtener los controles de riesgos',
          stack,
        );
      },
    );
  }

  // actualiza un control de riesgos existente y refresca la lista
  Future<void> updateControlDeRiesgos(String idIngreso, String idRegistroDiario,
      String idControlDeRiesgos, ControlDeRiesgos controlDeRiesgos) async {
    try {
      await _repository.updateControlDeRiesgos(
          idIngreso, idRegistroDiario, idControlDeRiesgos, controlDeRiesgos);
      fetchControlDeRiesgos(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state = AsyncValue.error('Error al actualizar el control de riesgos',
          stack);
    }
  }

  // elimina un control de riesgos y refresca la lista
  Future<void> deleteControlDeRiesgos(String idIngreso, String idRegistroDiario,
      String idControlDeRiesgos) async {
    try {
      await _repository.deleteControlDeRiesgos(
          idIngreso, idRegistroDiario, idControlDeRiesgos);
      fetchControlDeRiesgos(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state = AsyncValue.error('Error al eliminar el control de riesgos',
          stack);
    }
  }
}
