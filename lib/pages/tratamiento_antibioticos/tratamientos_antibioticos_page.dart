import 'package:flutter/material.dart';
import 'package:registro_uci/features/antibioticos/presentation/widgets/components/buttons/create_tratamiento_antibiotico_floating_button.dart';
import 'package:registro_uci/features/antibioticos/presentation/widgets/tratamientos_antibioticos_list.dart';

// pagina que lista los tratamientos antibioticos de un ingreso
class TratamientosAntibioticosPage extends StatelessWidget {
  // id del ingreso al que pertenecen los tratamientos
  final String idIngreso;

  // constructor, requiere el id del ingreso
  const TratamientosAntibioticosPage({
    super.key,
    required this.idIngreso,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamientos Antibioticos'),
      ),
      body: TratamientosAntibioticosList(idIngreso: idIngreso),
      floatingActionButton: CreateTratamientoAntibioticoFAB(
        idIngreso: idIngreso,
      ),
    );
  }
}
