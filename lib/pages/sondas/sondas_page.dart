import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/sondas/presentation/widgets/components/create_sonda_floating_button.dart';
import 'package:registro_uci/features/sondas/data/providers/sonda_provider.dart';
import 'package:registro_uci/features/sondas/presentation/controllers/delete_sonda_controller.dart';

import '../sondas/update_sondas_page.dart';

class SondasPage extends ConsumerWidget {
  final String idIngreso;

  const SondasPage({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final isAdmin = role == UserRole.admin;
    final sondasAsync = ref.watch(sondasProvider(idIngreso));
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Sondas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: sondasAsync.when(
          data: (sondas) {
            if (sondas.isEmpty) {
              return const _NoSondasWidget();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sondas.length,
              itemBuilder: (context, index) {
                final sonda = sondas[index];
                final fechaColocacion = sonda.fechaColocacion;
                final fechaRetiro = sonda.fechaRetiro;
                final diasEnUso = fechaRetiro == null
                    ? DateTime.now().difference(fechaColocacion).inDays + 1
                    : fechaRetiro.difference(fechaColocacion).inDays + 1;
                final isActive = fechaRetiro == null;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.water_drop,
                        color: isActive
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                    title: Text(
                      sonda.tipo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isActive ? 'ACTIVA' : 'RETIRADA',
                            style: TextStyle(
                              color: isActive
                                  ? Colors.green.shade800
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$diasEnUso días',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isAdmin)
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue, size: 20),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateSondasPage(
                                    sonda: sonda,
                                    idIngreso: idIngreso,
                                  ),
                                ),
                              );
                            },
                          ),
                        if (isAdmin)
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 20),
                            onPressed: () => _showDeleteDialog(
                                context, ref, sonda.id, idIngreso),
                          ),
                      ],
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.category,
                            label: 'Región Anatómica',
                            value: sonda.regionAnatomica,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.calendar_today,
                            label: 'Fecha de Colocación',
                            value: dateFormat.format(fechaColocacion.toLocal()),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            icon: Icons.timelapse,
                            label: 'Días en Uso',
                            value: '$diasEnUso días',
                          ),
                          if (fechaRetiro != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              icon: Icons.event_busy,
                              label: 'Fecha de Retiro',
                              value: dateFormat.format(fechaRetiro.toLocal()),
                              valueColor: Colors.red,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error al cargar las sondas:\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: CreateSondaFloatingButton(idIngreso: idIngreso),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, String idSonda, String idIngreso) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Sonda"),
        content: const Text("¿Estás seguro de que deseas eliminar esta sonda?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((confirm) async {
      if (confirm == true) {
        try {
          await ref
              .read(deleteSondaControllerProvider.notifier)
              .deleteSonda(idSonda, idIngreso);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sonda eliminada correctamente")),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error al eliminar: $e")),
            );
          }
        }
      }
    });
  }
}

class _NoSondasWidget extends StatelessWidget {
  const _NoSondasWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 60, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            "No hay sondas registradas",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Presiona el botón + para agregar una nueva sonda",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
