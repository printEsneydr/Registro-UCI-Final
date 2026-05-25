import 'package:flutter/material.dart';
import '../../features/sondas/presentation/widgets/components/create_sonda_form.dart';

// pagina con el formulario para crear una nueva sonda
class CreateSondasPage extends StatelessWidget {
  // id del ingreso al que se asociara la sonda
  final String idIngreso;

  // constructor, requiere el id del ingreso
  const CreateSondasPage({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Sonda')),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // titulo de la pagina
                    const Text(
                      "Formulario para crear una nueva Sonda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // formulario de creacion de sonda
                    CreateSondaForm(idIngreso: idIngreso),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
