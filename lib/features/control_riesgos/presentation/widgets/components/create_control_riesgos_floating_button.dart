import 'package:flutter/material.dart';
import '../../../../../pages/control_riegos/control_de_riesgos_page.dart';

// boton flotante que navega a la pagina de control de riesgos
class CreateControlRiegosFloatingButton extends StatelessWidget {
  final String idIngreso;

  const CreateControlRiegosFloatingButton({
    super.key,
    required this.idIngreso,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      elevation: 6.0,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ControlDeRiesgosPage(
            idIngreso: idIngreso,
            idRegistroDiario: '',
          ),
        ));
      },
      child: const Icon(Icons.add, size: 28),
    );
  }
}
