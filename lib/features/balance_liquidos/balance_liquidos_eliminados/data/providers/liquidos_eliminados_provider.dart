import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/repositories/firebase_liquidos_eliminados_repository.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/domain/models/liquido_eliminado.dart';

// Parámetros para el provider
// parametros para identificar el contexto del balance de liquidos
class LiquidosEliminadosParams {
  final String idIngreso;
  final String idRegistroDiario;
  final String idBalanceLiquidos;

  LiquidosEliminadosParams({
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.idBalanceLiquidos,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiquidosEliminadosParams &&
        other.idIngreso == idIngreso &&
        other.idRegistroDiario == idRegistroDiario &&
        other.idBalanceLiquidos == idBalanceLiquidos;
  }

  @override
  int get hashCode =>
      idIngreso.hashCode ^
      idRegistroDiario.hashCode ^
      idBalanceLiquidos.hashCode;
}

// Provider del repositorio
// provider del repositorio de liquidos eliminados
final liquidosEliminadosRepositoryProvider =
    Provider<FirebaseLiquidosEliminadosRepository>((ref) {
  return FirebaseLiquidosEliminadosRepository();
});

// Provider de lista de líquidos eliminados
// provider que obtiene la lista de liquidos eliminados para un balance dado
final liquidosEliminadosProvider =
    FutureProvider.family<List<LiquidoEliminado>, LiquidosEliminadosParams>(
        (ref, params) async {
  final repository = ref.watch(liquidosEliminadosRepositoryProvider);
  return repository.getLiquidosEliminados(
    params.idIngreso,
    params.idRegistroDiario,
    params.idBalanceLiquidos,
  );
});
