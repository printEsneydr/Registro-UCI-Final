import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/cateteres/data/providers/cateteres_providers.dart';
import 'package:registro_uci/features/cateteres/data/abstract_repositories/cateteres_repository.dart';

final deleteCateterControllerProvider =
    StateNotifierProvider<DeleteCateterController, AsyncValue<void>>(
  (ref) => DeleteCateterController(
    ref.watch(cateteresRepositoryProvider),
    ref,
  ),
);

// controlador que maneja la eliminacion de un cateter
class DeleteCateterController extends StateNotifier<AsyncValue<void>> {
  final CateteresRepository _repository;
  final Ref _ref;

  DeleteCateterController(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  // elimina el cateter y refresca la lista
  Future<void> deleteCateter(String idIngreso, String idCateter) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteCateter(idIngreso, idCateter);
      _ref.invalidate(cateteresByIngresoProvider(idIngreso));
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}
