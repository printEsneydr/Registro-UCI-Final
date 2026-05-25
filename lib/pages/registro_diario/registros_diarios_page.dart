import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/bed_widget.dart';
import 'package:registro_uci/features/registros_diarios/presentation/widgets/create_registro_diario_form.dart';
import 'package:registro_uci/features/registros_diarios/presentation/widgets/registros_diarios_list.dart';

// pagina que lista los registros diarios de un ingreso
class RegistrosDiariosPage extends StatelessWidget {
  // id del ingreso al que pertenecen los registros
  final String idIngreso;
  const RegistrosDiariosPage({
    super.key,
    required this.idIngreso,
  });

  // muestra la lista de registros y boton flotante para crear uno nuevo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text("Registros Diarios"),
            ),
            const SizedBox(width: 10),
            BedProviderWidget(
              idIngreso: idIngreso,
              redirectable: true,
            ),
          ],
        ),
      ),
      body: RegistrosDiariosList(idIngreso: idIngreso),
      // boton flotante que abre un dialogo para crear un nuevo registro diario
      floatingActionButton: IconButton.filled(
        padding: const EdgeInsets.all(15),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
        iconSize: 28,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: CreateRegistroDiarioForm(idIngreso: idIngreso),
              );
            },
          );
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
