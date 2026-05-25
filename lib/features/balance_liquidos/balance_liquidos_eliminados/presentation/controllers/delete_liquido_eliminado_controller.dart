import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/providers/liquidos_eliminados_provider.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/repositories/firebase_liquidos_eliminados_repository.dart';

// controller para eliminar un registro de liquidos eliminados
class DeleteLiquidoEliminadoController extends AsyncNotifier<void> {
  late final FirebaseLiquidosEliminadosRepository _repository =
      ref.watch(liquidosEliminadosRepositoryProvider);

  @override
  FutureOr<void> build() {}

  // elimina un liquido eliminado e invalida el provider para refrescar la lista
  Future<void> deleteLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoEliminado,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.deleteLiquidoEliminado(
          idIngreso,
          idRegistroDiario,
          idBalanceLiquidos,
          idLiquidoEliminado,
        ));

    ref.invalidate(liquidosEliminadosProvider(LiquidosEliminadosParams(
      idIngreso: idIngreso,
      idRegistroDiario: idRegistroDiario,
      idBalanceLiquidos: idBalanceLiquidos,
    )));
  }
}

// provider del controller de eliminacion de liquidos eliminados
final deleteLiquidoEliminadoControllerProvider =
    AsyncNotifierProvider<DeleteLiquidoEliminadoController, void>(
  () => DeleteLiquidoEliminadoController(),
);
