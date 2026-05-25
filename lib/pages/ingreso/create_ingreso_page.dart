import 'package:flutter/material.dart';
import 'package:registro_uci/features/ingresos/presentation/widgets/create_ingreso_form.dart';

// pagina con el formulario para crear un nuevo ingreso
class CreateIngresoPage extends StatelessWidget {
  const CreateIngresoPage({super.key});

  // muestra el formulario de creacion de ingreso en un scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Ingreso"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: const [
          CreateIngresoForm(),
        ],
      ),
    );
  }
}
