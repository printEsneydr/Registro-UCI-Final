import 'package:flutter/material.dart';
import 'package:registro_uci/features/registros_diarios/presentation/widgets/create_registro_diario_form.dart';

// pagina con formulario para crear un nuevo registro diario
class CreateRegistroDiarioPage extends StatelessWidget {
  // id del ingreso al que pertenece el nuevo registro
  final String idIngreso;
  const CreateRegistroDiarioPage({
    super.key,
    required this.idIngreso,
  });

  // muestra el formulario de creacion de registro diario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Registro Diario",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          CreateRegistroDiarioForm(
            idIngreso: idIngreso,
          ),
        ],
      ),
    );
  }
}
