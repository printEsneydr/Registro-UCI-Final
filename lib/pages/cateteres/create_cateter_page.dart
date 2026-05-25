import 'package:flutter/material.dart';
import '../../features/cateteres/presentation/widgets/components/create_cateter_form.dart';

// pagina con el formulario para crear un nuevo cateter
class CreateCateterPage extends StatelessWidget {
  // id del ingreso al que se asociara el cateter
  final String idIngreso;

  // constructor, requiere el id del ingreso
  const CreateCateterPage({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Catéter"),
      ),
      // permite desplazar el contenido si el teclado aparece
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
            .onDrag, // Mejora la experiencia de usuario
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding de 16px para espaciado
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context)
                  .size
                  .width, // Limita el ancho para pantallas grandes
              maxHeight: MediaQuery.of(context)
                  .size
                  .height, // Limita la altura para evitar desbordamiento
            ),
            child: CreateCateterForm(
                idIngreso: idIngreso), // Formulario de creación
          ),
        ),
      ),
    );
  }
}
