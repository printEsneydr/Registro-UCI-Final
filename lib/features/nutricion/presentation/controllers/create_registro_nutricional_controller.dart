import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/nutricion/data/dto/create_registro_nutricional_dto.dart';
import 'package:registro_uci/features/nutricion/data/providers/nutricion_provider.dart';
import 'package:registro_uci/features/nutricion/data/repositories/firebase_nutricion_repository.dart';

// controlador que maneja la logica de crear un registro nutricional
class CreateRegistroNutricionalController extends AsyncNotifier<void> {
  late final FirebaseNutricionRepository _repository =
      ref.watch(nutricionRepositoryProvider);

  @override
  FutureOr<void> build() {}

  // crea un registro nutricional en firestore e invalida los providers
  Future<void> createRegistroNutricional(
    String idIngreso,
    CreateRegistroNutricionalDto dto,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.createRegistroNutricional(
          idIngreso,
          dto,
        ));

    ref.invalidate(registrosNutricionalesProvider(idIngreso));
    ref.invalidate(ultimoRegistroNutricionalProvider(idIngreso));
  }
}

// provider del controlador de creacion de registros nutricionales
final createRegistroNutricionalControllerProvider =
    AsyncNotifierProvider<CreateRegistroNutricionalController, void>(
  () => CreateRegistroNutricionalController(),
);
