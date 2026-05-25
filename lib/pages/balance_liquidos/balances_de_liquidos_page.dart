import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/bed_widget.dart';
import 'package:registro_uci/features/balance_liquidos/presentation/widgets/balances_de_liquidos_list.dart';
import 'package:registro_uci/pages/balance_liquidos/ui.dart';

// pagina que muestra el balance de liquidos y la lista de balances
class BalancesDeLiquidosPage extends StatelessWidget {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario asociado
  final String idRegistroDiario;

  // constructor requiere id de ingreso y registro diario
  const BalancesDeLiquidosPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  // construye la pagina con el card de balance y la lista de balances
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text("Balances de Liquidos"),
            ),
            const SizedBox(width: 10),
            BedProviderWidget(
              idIngreso: idIngreso,
              redirectable: true,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          BalanceCard(idIngreso: idIngreso, idRegistroDiario: idRegistroDiario),
          BalancesDeLiquidosList(
            idIngreso: idIngreso,
            idRegistroDiario: idRegistroDiario,
          ),
        ],
      ),
    );
  }
}
