import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/registros_diarios/data/providers/registros_diarios_de_ingreso_provider.dart';
import 'package:registro_uci/features/registros_diarios/presentation/widgets/components/registro_diario_tile.dart';
import 'package:registro_uci/features/registros_diarios/presentation/widgets/create_registro_diario_form.dart';

// widget que muestra la lista de registros diarios de un ingreso
class RegistrosDiariosList extends ConsumerWidget {
  final String idIngreso;
  const RegistrosDiariosList({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // observa el provider que obtiene los registros diarios del ingreso
    final registrosDiarios =
        ref.watch(registrosDiariosDeIngresoProvider(idIngreso));
    return registrosDiarios.when(
      data: (data) {
        // muestra pantalla vacia con boton de crear si no hay registros
        if (data.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No hay registros diarios para este ingreso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: CreateRegistroDiarioForm(idIngreso: idIngreso),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Registro Diario'),
                ),
              ],
            ),
          );
        }
        // lista los registros diarios existentes
        return ListView.separated(
          itemCount: data.length,
          itemBuilder: (context, index) => RegistroDiarioTile(
            registroDiario: data.elementAt(index),
            idIngreso: idIngreso,
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          padding: const EdgeInsets.all(15),
        );
      },
      // muestra error si falla la carga
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Error al cargar registros: $error',
            style: TextStyle(color: Colors.red.shade700, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // indicador de carga mientras se obtienen los datos
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
