import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/form_tile.dart';
import 'package:registro_uci/pages/glasgow/glasgow_page.dart';

// tile que navega a la pagina de evaluacion de la escala de glasgow
class GlasgowTile extends StatelessWidget {
  const GlasgowTile({
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
      title: "Escala de Glasgow",
      subtitle: "Evaluación neurológica",
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GlasgowPage(
              idIngreso: idIngreso,
              idRegistroDiario: idRegistro,
            ),
          ),
        );
      },
    );
  }
}
