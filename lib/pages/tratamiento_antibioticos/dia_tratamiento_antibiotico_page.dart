import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/bed_widget.dart';
import 'package:registro_uci/features/antibioticos/presentation/widgets/components/dias_tratamiento_list.dart';

// pagina que lista los dias de un tratamiento antibiotico
class DiasTratamientoAntibioticoPage extends StatelessWidget {
  // id del ingreso al que pertenece el tratamiento
  final String idIngreso;
  // id del tratamiento antibiotico
  final String idTratamientoAntibiotico;
  // constructor, requiere el id del ingreso y del tratamiento
  const DiasTratamientoAntibioticoPage(
      {super.key,
      required this.idIngreso,
      required this.idTratamientoAntibiotico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text("Dias de tratamiento"),
            ),
            const SizedBox(width: 10),
            BedProviderWidget(
              idIngreso: idIngreso,
              redirectable: true,
            ),
          ],
        ),
      ),
      body: DiasTratamientoList(
        idIngreso: idIngreso,
        idTratamientoAntibiotico: idTratamientoAntibiotico,
      ),
    );
  }
}
