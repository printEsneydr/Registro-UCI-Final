import 'package:flutter/material.dart';
import '../../features/sondas/domain/models/sonda.dart';
import '../../features/sondas/presentation/widgets/components/update_sonda_form.dart';

// pagina para actualizar los datos de una sonda existente
class UpdateSondasPage extends StatelessWidget {
  // sonda que se va a actualizar
  final Sonda sonda;
  // id del ingreso al que pertenece la sonda
  final String idIngreso;

  // constructor, requiere la sonda y el id del ingreso
  const UpdateSondasPage(
      {super.key, required this.sonda, required this.idIngreso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualizar Sonda')),
      body: SafeArea(
        child: SingleChildScrollView(
          // mejora la experiencia de desplazamiento
          physics: const BouncingScrollPhysics(),
          // oculta el teclado al arrastrar
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              // limita el ancho maximo en pantallas grandes
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                // formulario de actualizacion de sonda
                child: UpdateSondaForm(sonda: sonda, idIngreso: idIngreso),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
