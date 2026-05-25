import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/nutricion/data/providers/nutricion_provider.dart';
import 'package:registro_uci/features/nutricion/domain/models/registro_nutricional.dart';
import 'package:registro_uci/features/nutricion/presentation/controllers/delete_registro_nutricional_controller.dart';
import 'package:registro_uci/features/nutricion/presentation/widgets/components/create_registro_nutricional_form.dart';
import 'package:registro_uci/features/nutricion/presentation/widgets/components/registro_nutricional_tile.dart';

// pagina que muestra los registros nutricionales de un ingreso
class NutricionPage extends ConsumerWidget {
  // id del ingreso al que pertenecen los registros
  final String idIngreso;

  // constructor, requiere el id del ingreso
  const NutricionPage({
    super.key,
    required this.idIngreso,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // obtiene los registros nutricionales desde el proveedor
    final registrosAsync = ref.watch(registrosNutricionalesProvider(idIngreso));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrición'),
      ),
      body: registrosAsync.when(
        data: (registros) {
          if (registros.isEmpty) {
            return const Center(
              child: Text('No hay registros nutricionales'),
            );
          }
          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final registro = registros[index];
              return RegistroNutricionalTile(
                registro: registro,
                onDeleteTap: () => _confirmDelete(context, ref, registro),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: CreateRegistroNutricionalForm(
                  idIngreso: idIngreso,
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // muestra un dialogo de confirmacion y elimina el registro si se confirma
  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RegistroNutricional registro,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Está seguro de eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final controller = ref.read(
                  deleteRegistroNutricionalControllerProvider.notifier,
                );
                await controller.deleteRegistroNutricional(
                  idIngreso,
                  registro.idRegistroNutricional,
                );
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
