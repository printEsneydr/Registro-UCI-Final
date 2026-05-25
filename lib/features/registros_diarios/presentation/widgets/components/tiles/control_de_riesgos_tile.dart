import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/form_tile.dart';
import 'package:registro_uci/pages/control_riegos/control_de_riesgos_page.dart';

// tile que navega a la pagina de control de riesgos del paciente
class ControlDeRiesgosTile extends StatelessWidget {
  const ControlDeRiesgosTile({
    super.key,
    required this.idIngreso,
    required this.idRegistro,
    required this.completed,
  });

  final String idIngreso;
  final String idRegistro;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return FormTile(
      completed: completed,
      title: "Control de Riesgos",
      subtitle: "Gestión de riesgos y medidas preventivas",
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ControlDeRiesgosPage(
              idIngreso: idIngreso,
              idRegistroDiario: idRegistro,
            );
          },
        ));
      },
    );
  }
}
