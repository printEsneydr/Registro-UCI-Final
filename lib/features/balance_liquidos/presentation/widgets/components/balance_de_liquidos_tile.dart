import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/lite_tile.dart';
import 'package:registro_uci/features/balance_liquidos/data/providers/balances_de_liquidos_provider.dart';
import 'package:registro_uci/features/balance_liquidos/domain/models/balance_de_liquidos.dart';
import 'package:registro_uci/pages/balance_liquidos/choose_balance_liquidos_page.dart';

// widget que muestra un balance de liquidos individual como un tile
class BalanceDeLiquidosTile extends StatelessWidget {
  // modelo del balance y parametros para navegar a la pagina de detalle
  final BalanceDeLiquidos balance;
  final BalancesDeLiquidosParams params;
  const BalanceDeLiquidosTile({
    super.key,
    required this.balance,
    required this.params,
  });

  // navega a la pagina de detalle del balance al hacer tap
  @override
  Widget build(BuildContext context) {
    return LiteTile(
      title: "Hora: ${balance.hora}:00:00",
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ChooseBalanceLiquidosPage(
              params: params,
              balance: balance,
            );
          },
        ));
      },
    );
  }
}
