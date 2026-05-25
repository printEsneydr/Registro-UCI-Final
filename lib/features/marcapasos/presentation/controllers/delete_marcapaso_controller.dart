import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/providers/marcapasos_provider.dart';

final deleteMarcapasoControllerProvider =
    StateNotifierProvider<DeleteMarcapasoController, AsyncValue<void>>(
  (ref) => DeleteMarcapasoController(ref),
);

// controlador que maneja la eliminacion de un marcapaso
class DeleteMarcapasoController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  DeleteMarcapasoController(this.ref) : super(const AsyncValue.data(null));

  // elimina el marcapaso y refresca la lista
  Future<void> deleteMarcapaso(String idIngreso, String idMarcapaso) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(marcapasosRepositoryProvider);
      await repository.deleteMarcapaso(idIngreso, idMarcapaso);
      ref.invalidate(marcapasosByIngresoProvider(idIngreso));
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}
