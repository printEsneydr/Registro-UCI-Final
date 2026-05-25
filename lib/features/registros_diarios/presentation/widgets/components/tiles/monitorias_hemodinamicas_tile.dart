import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/form_tile.dart';
import 'package:registro_uci/pages/monitoria_hemodinamica/monitoria_hemodinamica_page.dart';

// tile que navega a la pagina de monitoreo hemodinamico
class MonitoriasHemodinamicasTile extends StatelessWidget {
  const MonitoriasHemodinamicasTile({
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
      title: "Monitorías Hemodinámicas",
      subtitle: "Registro de parámetros hemodinámicos",
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return MonitoriaHemodinamicaPage(
                idIngreso: idIngreso, idRegistroDiario: idRegistro);
          },
        ));
      },
    );
  }
}
