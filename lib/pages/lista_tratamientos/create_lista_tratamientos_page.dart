import 'package:flutter/material.dart';
import '../../features/lista_tratamientos/presentation/widgets/create_lista_tratamientos_form.dart';

// pagina con el formulario para crear un nuevo tratamiento
class CreateListaTratamientosPage extends StatelessWidget {
  // id del ingreso al que pertenece el tratamiento
  final String idIngreso;
  // id del registro diario
  final String idRegistroDiario;

  // constructor, requiere el id del ingreso y del registro diario
  const CreateListaTratamientosPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Tratamiento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateListaTratamientosForm(
          idIngreso: idIngreso,
          idRegistroDiario: idRegistroDiario,
        ),
      ),
    );
  }
}
