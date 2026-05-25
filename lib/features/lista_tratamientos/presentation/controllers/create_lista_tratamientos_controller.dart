// controlador para manejar el estado y las operaciones crud de tratamientos
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/lista_tratamientos/domain/models/lista_tratamientos.dart';
import 'package:registro_uci/features/lista_tratamientos/data/abstract_repositories/lista_tratamientos_repository.dart';
import '../../data/providers/lista_tratamientos_provider.dart';

// proveedor del controlador como statenotifier
final createListaTratamientosControllerProvider =
    StateNotifierProvider<CreateListaTratamientosController,
        AsyncValue<List<ListaTratamientos>>>(
  (ref) => CreateListaTratamientosController(
      ref.watch(listaTratamientosRepositoryProvider)),
);

class CreateListaTratamientosController
    extends StateNotifier<AsyncValue<List<ListaTratamientos>>> {
  final ListaTratamientosRepository _repository;

  CreateListaTratamientosController(this._repository)
      : super(const AsyncValue.loading());

  // obtiene la lista de tratamientos del registro diario via stream
  void fetchListaTratamientos(String idIngreso, String idRegistroDiario) {
    state = const AsyncValue.loading();
    _repository.getListaTratamientos(idIngreso, idRegistroDiario).listen(
      (result) {
        state = AsyncValue.data(result);
      },
      onError: (e, stack) {
        state = AsyncValue.error('Error al obtener lista de tratamientos', stack);
      },
    );
  }

  // agrega un nuevo tratamiento y refresca la lista
  Future<void> addListaTratamientos(String idIngreso, String idRegistroDiario,
      ListaTratamientos listaTratamientos) async {
    try {
      await _repository.addListaTratamientos(
          idIngreso, idRegistroDiario, listaTratamientos);
      fetchListaTratamientos(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state =
          AsyncValue.error('Error al agregar tratamiento', stack);
    }
  }

  // actualiza un tratamiento existente y refresca la lista
  Future<void> updateListaTratamientos(
      String idIngreso,
      String idRegistroDiario,
      String idListaTratamientos,
      ListaTratamientos listaTratamientos) async {
    try {
      await _repository.updateListaTratamientos(
          idIngreso, idRegistroDiario, idListaTratamientos, listaTratamientos);
      fetchListaTratamientos(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state =
          AsyncValue.error('Error al actualizar tratamiento', stack);
    }
  }

  // elimina un tratamiento y refresca la lista
  Future<void> deleteListaTratamientos(String idIngreso, String idRegistroDiario,
      String idListaTratamientos) async {
    try {
      await _repository.deleteListaTratamientos(
          idIngreso, idRegistroDiario, idListaTratamientos);
      fetchListaTratamientos(idIngreso, idRegistroDiario);
    } catch (e, stack) {
      state =
          AsyncValue.error('Error al eliminar tratamiento', stack);
    }
  }
}
