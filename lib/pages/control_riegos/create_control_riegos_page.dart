import 'package:flutter/material.dart';
import '../../features/control_riesgos/presentation/widgets/create_control_riesgos_form.dart'; // Importamos el formulario

// pagina para crear un nuevo registro de control de riesgos
class CreateControlRiesgosPage extends StatelessWidget {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario asociado
  final String idRegistroDiario;

  // constructor requiere id de ingreso y registro diario
  const CreateControlRiesgosPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  // construye la pagina con el formulario para crear control de riesgos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control de Riesgos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateControlRiesgosForm(
          idIngreso: idIngreso,
          idRegistroDiario:
              idRegistroDiario, // Pasamos los parámetros necesarios
        ),
      ),
    );
  }
}
