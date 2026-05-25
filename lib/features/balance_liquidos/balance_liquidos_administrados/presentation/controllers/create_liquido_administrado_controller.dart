import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/abstract_repositories/liquidos_administrados_repository.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/dto/create_liquido_administrado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/providers/liquidos_administrados_provider.dart';

// controller para crear un liquido administrado
class CreateLiquidoAdministradoController extends AsyncNotifier<void> {
  late final LiquidosAdministradosRepository _repository =
      ref.watch(liquidosAdministradosRepositoryProvider);

  @override
  FutureOr<void> build() {}

  // crea un liquido administrado e invalida el provider
  Future<void> createLiquidoAdministrado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    CreateLiquidoAdministradoDto dto,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.createLiquidoAdministrado(
          idIngreso,
          idRegistroDiario,
          idBalanceLiquidos,
          dto,
        ));

    ref.invalidate(liquidosAdministradosProvider(LiquidosAdministradosParams(
      idIngreso: idIngreso,
      idRegistroDiario: idRegistroDiario,
      idBalanceLiquidos: idBalanceLiquidos,
    )));
  }
}

// provider del controller de creacion de liquidos administrados
final createLiquidoAdministradoControllerProvider =
    AsyncNotifierProvider<CreateLiquidoAdministradoController, void>(
  () => CreateLiquidoAdministradoController(),
);
