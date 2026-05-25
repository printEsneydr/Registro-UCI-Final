import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/marcapasos/data/providers/marcapasos_provider.dart';
import 'package:registro_uci/features/marcapasos/presentation/controllers/delete_marcapaso_controller.dart';
import 'update_marcapasos_page.dart';
import '../../features/marcapasos/presentation/widgets/components/buttons/create_marcapasos_floating_button.dart';

// pagina que lista los marcapasos registrados para un ingreso
class ListadoMarcapasosPage extends ConsumerWidget {
  // id del ingreso al que pertenecen los marcapasos
  final String idIngreso;

  // constructor, requiere el id del ingreso
  const ListadoMarcapasosPage({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // obtiene el rol del usuario actual
    final role = ref.watch(roleProvider);
    // verifica si el usuario es admin
    final isAdmin = role == UserRole.admin;
    // obtiene la lista de marcapasos desde el proveedor
    final marcapasosAsync = ref.watch(marcapasosByIngresoProvider(idIngreso));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Marcapasos"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        iconTheme: IconThemeData(color: Colors.blue.shade800),
      ),
      body: marcapasosAsync.when(
        data: (marcapasos) {
          if (marcapasos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services,
                      size: 60, color: Colors.blue.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No hay marcapasos registrados",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: marcapasos.length,
            itemBuilder: (context, index) {
              final marcapaso = marcapasos[index];

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
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.monitor_heart,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  title: Text(
                    marcapaso.modo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        marcapaso.fechaColocacion,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${marcapaso.frecuencia} BPM',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
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
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMarcapasoPage(
                                idIngreso: idIngreso,
                                marcapaso: marcapaso,
                              ),
                            ),
                          ),
                        ),
                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 20),
                          onPressed: () =>
                              _confirmDelete(context, ref, marcapaso),
                        ),
                    ],
                  ),
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.schedule,
                      label: 'Modo',
                      value: marcapaso.modo,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.route,
                      label: 'Vía',
                      value: marcapaso.via,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.speed,
                      label: 'Frecuencia',
                      value: '${marcapaso.frecuencia} BPM',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.sensors,
                      label: 'Sensibilidad',
                      value: '${marcapaso.sensibilidad} mV',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.electric_bolt,
                      label: 'Salida',
                      value: '${marcapaso.salida} V',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Fecha de Colocación',
                      value: marcapaso.fechaColocacion,
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade800),
            strokeWidth: 3,
          ),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 50, color: Colors.red.shade700),
              const SizedBox(height: 16),
              Text(
                "Error al cargar los datos",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$err",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(marcapasosByIngresoProvider(idIngreso)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          CreateMarcapasosFloatingButton(idIngreso: idIngreso),
    );
  }

  // construye una fila con icono, etiqueta y valor para mostrar informacion
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // muestra un dialogo de confirmacion y elimina el marcapaso si se confirma
  void _confirmDelete(BuildContext context, WidgetRef ref, marcapaso) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content:
            const Text("¿Estás seguro de que deseas eliminar este marcapaso?"),
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
              .read(deleteMarcapasoControllerProvider.notifier)
              .deleteMarcapaso(idIngreso, marcapaso.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Marcapaso eliminado correctamente")),
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
