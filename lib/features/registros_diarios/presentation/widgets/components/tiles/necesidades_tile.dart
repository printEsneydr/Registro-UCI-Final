import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/form_tile.dart';
import 'package:registro_uci/features/firmas/domain/models/firma.dart';
import 'package:registro_uci/pages/necesidades/necesidades_page.dart';

// tile que navega a la pagina de lista de necesidades del paciente
class NecesidadesTile extends StatelessWidget {
  const NecesidadesTile({
    super.key,
    required this.idIngreso,
    required this.idRegistro,
    required this.firma,
  });

  final String idIngreso;
  final String idRegistro;
  final Firma? firma;

  @override
  Widget build(BuildContext context) {
    // muestra el tile como completado si existe una firma
    return FormTile(
      completed: firma != null,
      title: "Lista de Necesidades",
      subtitle: "Necesidades, Objectivos e intervenciones de enfermería",
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NecesidadesPage(
              idIngreso: idIngreso,
              idRegistro: idRegistro,
              firma: firma,
            ),
          ),
        );
      },
    );
  }
}
