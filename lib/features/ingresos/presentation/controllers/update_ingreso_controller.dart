import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';
import 'package:registro_uci/features/ingresos/data/abstract_repositories/ingresos_repository.dart';
import 'package:registro_uci/features/ingresos/data/dto/update_ingreso_dto.dart';
import 'package:registro_uci/features/ingresos/data/providers/ingreso_by_id_provider.dart';
import 'package:registro_uci/features/ingresos/data/providers/ingresos_by_sala_provider.dart';

// controller que maneja la actualizacion de un ingreso existente
class UpdateIngresoController extends AsyncNotifier<void> {
  late final IngresosRepository _repository =
      ref.watch(ingresosRepositoryProvider);

  @override
  FutureOr<void> build() {}

  // ejecuta la actualizacion e invalida los providers de sala e ingreso
  Future<void> updateIngreso(String idIngreso, UpdateIngresoDto dto) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _repository.updateIngreso(idIngreso, dto));
    ref.invalidate(
      ingresosBySalaProvider,
    );

    ref.invalidate(ingresoByIdProvider);
  }
}

// provider del controller de actualizacion de ingreso
final updateIngresoControllerProvider =
    AsyncNotifierProvider<UpdateIngresoController, void>(
  () => UpdateIngresoController(),
);
