import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/dto/create_liquido_eliminado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/providers/liquidos_eliminados_provider.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/repositories/firebase_liquidos_eliminados_repository.dart';

// controller para actualizar un registro de liquidos eliminados
class UpdateLiquidoEliminadoController extends AsyncNotifier<void> {
  late final FirebaseLiquidosEliminadosRepository _repository =
      ref.watch(liquidosEliminadosRepositoryProvider);

  @override
  FutureOr<void> build() {}

  // actualiza un liquido eliminado e invalida el provider para refrescar la lista
  Future<void> updateLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoEliminado,
    CreateLiquidoEliminadoDto dto,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.updateLiquidoEliminado(
          idIngreso,
          idRegistroDiario,
          idBalanceLiquidos,
          idLiquidoEliminado,
          dto,
        ));

    ref.invalidate(liquidosEliminadosProvider(LiquidosEliminadosParams(
      idIngreso: idIngreso,
      idRegistroDiario: idRegistroDiario,
      idBalanceLiquidos: idBalanceLiquidos,
    )));
  }
}

// provider del controller de actualizacion de liquidos eliminados
final updateLiquidoEliminadoControllerProvider =
    AsyncNotifierProvider<UpdateLiquidoEliminadoController, void>(
  () => UpdateLiquidoEliminadoController(),
);
