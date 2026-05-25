import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/data/providers/balances_de_liquidos_provider.dart';
import 'package:registro_uci/features/balance_liquidos/presentation/widgets/components/balance_de_liquidos_tile.dart';

// widget que lista todos los balances de liquidos de un registro diario
class BalancesDeLiquidosList extends ConsumerWidget {
  // ids del ingreso y registro diario para obtener los balances
  final String idIngreso;
  final String idRegistroDiario;

  const BalancesDeLiquidosList(
      {super.key, required this.idIngreso, required this.idRegistroDiario});

  // construye la lista obteniendo los balances desde el provider
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = BalancesDeLiquidosParams(
      idIngreso: idIngreso,
      idRegistroDiario: idRegistroDiario,
    );

    final balances = ref.watch(balancesDeLiquidosProvider(params));
    return balances.when(
      data: (data) {
        return ListView.separated(
          itemCount: data.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => BalanceDeLiquidosTile(
            balance: data.elementAt(index),
            params: params,
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          padding: const EdgeInsets.all(15),
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
