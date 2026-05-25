import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/bed_widget.dart';

import 'package:registro_uci/pages/control_sedacion/control_sadacion_card.dart';

// pagina que muestra el control de sedacion (nota: nombre incorrecto, deberia ser ControlSedacionPage)
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

  // construye la pagina con la tarjeta de control de sedacion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text("Control sedacion"),
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
          ControlSedacionCard(
            idIngreso: idIngreso,
            idRegistroDiario: idRegistroDiario,
          ),
        ],
      ),
    );
  }
}
