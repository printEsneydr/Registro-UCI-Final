import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/bed_widget.dart';

import 'package:registro_uci/pages/monitoria_hemodinamica/monitoria_hemodinamica_card.dart';

// pagina principal de monitoria hemodinamica que muestra la card
class MonitoriaHemodinamicaPage extends StatelessWidget {
  // id del ingreso
  final String idIngreso;
  // id del registro diario
  final String idRegistroDiario;
  const MonitoriaHemodinamicaPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  // muestra la pantalla con la card de monitoria hemodinamica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text("Monitoria Hemodinámica"),
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
          MonitoriaHemodinamicaCard(
            idIngreso: idIngreso,
            idRegistroDiario: idRegistroDiario,
          ),
        ],
      ),
    );
  }
}
