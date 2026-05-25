import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/tile.dart';
import '../../../../../../pages/cateteres/catateres_page.dart'; // ✅ Importa la página correcta

// tile que navega a la pagina de listado de cateteres
class CateteresTile extends StatelessWidget {
  final String idIngreso; // 🔥 Se añade el idIngreso como parámetro

  const CateteresTile({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context) {
    return Tile(
      iconData: Icons.vaccines_outlined,
      title: "Catéteres",
      subtitle: "Lista de catéteres registrados",
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ListadoCateteresPage(
                // ✅ Página de lista de catéteres
                idIngreso: idIngreso,
              );
            },
          ),
        );
      },
    );
  }
}
