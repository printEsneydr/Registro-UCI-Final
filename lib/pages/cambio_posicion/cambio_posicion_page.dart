import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/bed_widget.dart';

import 'package:registro_uci/pages/cambio_posicion/cambios_card.dart';

// pagina que muestra los cambios de posicion del paciente
class CambioPosicionPage extends StatelessWidget {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario asociado
  final String idRegistroDiario;

  // constructor requiere id de ingreso y registro diario
  const CambioPosicionPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  // construye la pagina con la tarjeta de cambios de posicion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text("Cambio de Posición"),
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
          CambioPosicionCard(
            idIngreso: idIngreso,
            idRegistroDiario: idRegistroDiario,
          ),
        ],
      ),
    );
  }
}
