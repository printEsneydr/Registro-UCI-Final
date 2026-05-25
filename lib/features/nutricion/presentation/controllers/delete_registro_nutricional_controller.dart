import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/nutricion/data/providers/nutricion_provider.dart';
import 'package:registro_uci/features/nutricion/data/repositories/firebase_nutricion_repository.dart';

// controlador que maneja la logica de eliminar un registro nutricional
class DeleteRegistroNutricionalController extends AsyncNotifier<void> {
  late final FirebaseNutricionRepository _repository =
      ref.watch(nutricionRepositoryProvider);

  @override
  FutureOr<void> build() {}

  // elimina un registro nutricional de firestore e invalida los providers
  Future<void> deleteRegistroNutricional(
    String idIngreso,
    String idRegistroNutricional,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.deleteRegistroNutricional(
          idIngreso,
          idRegistroNutricional,
        ));

    ref.invalidate(registrosNutricionalesProvider(idIngreso));
    ref.invalidate(ultimoRegistroNutricionalProvider(idIngreso));
  }
}

// provider del controlador de eliminacion de registros nutricionales
final deleteRegistroNutricionalControllerProvider =
    AsyncNotifierProvider<DeleteRegistroNutricionalController, void>(
  () => DeleteRegistroNutricionalController(),
);
