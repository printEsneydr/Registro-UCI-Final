import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/common/components/tile.dart';
import 'package:registro_uci/features/ingresos/presentation/controllers/terminar_ingreso_controller.dart';
import 'package:registro_uci/features/ingresos/data/providers/ingreso_by_id_provider.dart';

// tile que muestra el estado del ingreso y permite finalizarlo
class TerminarIngresoTile extends ConsumerWidget {
  final String idIngreso;

  const TerminarIngresoTile({
    super.key,
    required this.idIngreso,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingresoAsync = ref.watch(ingresoByIdProvider(idIngreso));

    return ingresoAsync.when(
      data: (ingreso) {
        final isTerminado = ingreso?.fechaFin != null;

        if (isTerminado) {
          return Tile(
            iconData: Icons.check_circle,
            title: "Ingreso Finalizado",
            subtitle: "Fecha de egreso: ${_formatDate(ingreso!.fechaFin!)}",
            onTap: null,
          );
        }

        return Tile(
          iconData: Icons.cancel_outlined,
          title: "Terminar Ingreso",
          subtitle: "Usar esta opción cuando el paciente sale de la U.C.I",
          onTap: () => _showTerminarIngresoDialog(context, ref),
        );
      },
      loading: () => const Tile(
        iconData: Icons.hourglass_empty,
        title: "Cargando...",
        subtitle: "",
        onTap: null,
      ),
      error: (_, __) => const Tile(
        iconData: Icons.error,
        title: "Error",
        subtitle: "No se pudo cargar el estado del ingreso",
        onTap: null,
      ),
    );
  }

  // formatea la fecha al formato dd/mm/yyyy hh:mm
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  // muestra un dialogo para confirmar y seleccionar la fecha de egreso
  void _showTerminarIngresoDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController motivoController = TextEditingController();
    DateTime fechaEgreso = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Terminar Ingreso"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Esta acción marcará el ingreso como finalizado.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                "Fecha de Egreso:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: fechaEgreso,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(fechaEgreso),
                    );
                    if (time != null) {
                      setState(() {
                        fechaEgreso = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(fechaEgreso.toLocal()),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: motivoController,
                decoration: const InputDecoration(
                  labelText: "Motivo de egreso (opcional)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                try {
                  await ref
                      .read(terminarIngresoControllerProvider.notifier)
                      .terminarIngreso(idIngreso, fechaEgreso);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Ingreso terminado correctamente"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error al terminar ingreso: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }
}
