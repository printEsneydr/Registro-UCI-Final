import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/features/lista_tratamientos/data/providers/lista_tratamientos_provider.dart';
import 'package:registro_uci/features/lista_tratamientos/domain/models/lista_tratamientos.dart';
import 'package:registro_uci/features/lista_tratamientos/presentation/widgets/update_lista_tratamientos_form.dart';

// pagina para editar un tratamiento existente
class UpdateListaTratamientosPage extends ConsumerWidget {
  // id del ingreso al que pertenece el tratamiento
  final String idIngreso;
  // id del registro diario
  final String idRegistroDiario;
  // id del tratamiento a editar
  final String listaTratamientosId;

  // constructor, requiere los ids del ingreso, registro diario y tratamiento
  const UpdateListaTratamientosPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.listaTratamientosId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tratamientoAsync = ref.watch(listaTratamientosByIdProvider((
      idIngreso: idIngreso,
      idRegistroDiario: idRegistroDiario,
      idListaTratamientos: listaTratamientosId,
    )));

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Tratamiento')),
      body: tratamientoAsync.when(
        data: (tratamiento) {
          if (tratamiento == null) {
            return const Center(child: Text('Tratamiento no encontrado'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: UpdateListaTratamientosForm(
              idIngreso: idIngreso,
              idRegistroDiario: idRegistroDiario,
              tratamiento: tratamiento,
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
