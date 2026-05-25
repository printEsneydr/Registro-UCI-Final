import 'package:flutter/material.dart';
import 'package:registro_uci/features/marcapasos/presentation/widgets/components/create_marcapaso_form.dart';

// pagina con el formulario para crear un nuevo marcapaso
class CreateMarcapasoPage extends StatelessWidget {
  // id del ingreso al que se asociara el marcapaso
  final String idIngreso;

  // constructor, requiere el id del ingreso
  const CreateMarcapasoPage({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Marcapaso"),
      ),
      // permite desplazar el contenido y oculta el teclado al arrastrar
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth:
                  600, // Evita desbordamiento horizontal en pantallas grandes
            ),
            // formulario de creacion de marcapaso
            child: CreateMarcapasoForm(idIngreso: idIngreso),
          ),
        ),
      ),
    );
  }
}
