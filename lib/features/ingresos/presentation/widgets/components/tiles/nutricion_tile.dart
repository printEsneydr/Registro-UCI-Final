import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/tile.dart';
import 'package:registro_uci/pages/nutricion/nutricion_page.dart';

// tile que navega a la pagina de registro nutricional
class NutricionTile extends StatelessWidget {
  final String idIngreso;

  const NutricionTile({
    super.key,
    required this.idIngreso,
  });

  @override
  Widget build(BuildContext context) {
    return Tile(
      iconData: Icons.restaurant_menu,
      title: "Nutrición",
      subtitle: "Registro nutricional y balance calórico",
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NutricionPage(
                idIngreso: idIngreso,
              );
            },
          ),
        );
      },
    );
  }
}
