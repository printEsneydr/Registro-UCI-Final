import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/tile.dart';
import 'package:registro_uci/features/observaciones_extras/presentation/pages/observaciones_extras_page.dart';

class ObservacionesExtrasTile extends StatelessWidget {
  final String idIngreso;

  const ObservacionesExtrasTile({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context) {
    return Tile(
      iconData: Icons.assignment,
      title: 'Observaciones Extras y Firmas',
      subtitle: 'Laboratorios, Cultivos, Órdenes, Firmas',
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ObservacionesExtrasPage(idIngreso: idIngreso),
          ),
        );
      },
    );
  }
}
