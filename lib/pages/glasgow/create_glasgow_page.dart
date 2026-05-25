import 'package:flutter/material.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/presentation/widgets/create_glasgow_form.dart';

// pagina para crear un nuevo registro de la escala de glasgow
class CreateGlasgowPage extends StatelessWidget {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario asociado
  final String idRegistroDiario;

  // constructor requiere id de ingreso y registro diario
  const CreateGlasgowPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  // construye la pagina con el formulario para crear glasgow
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Registro Glasgow')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateGlasgowForm(
          idIngreso: idIngreso,
          idRegistroDiario: idRegistroDiario,
        ),
      ),
    );
  }
}
