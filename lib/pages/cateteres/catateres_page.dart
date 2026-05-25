import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/cateteres/presentation/widgets/components/buttons/create_cateter_floating_button.dart';
import 'package:registro_uci/features/cateteres/presentation/controllers/delete_cateter_controller.dart';
import 'package:registro_uci/features/cateteres/data/providers/cateteres_providers.dart';
import 'update_cateteres_page.dart';
import '../../features/cateteres/domain/models/cateter.dart';

// pagina que lista los cateteres registrados para un ingreso
class ListadoCateteresPage extends ConsumerWidget {
  // id del ingreso al que pertenecen los cateteres
  final String idIngreso;

  // constructor de la pagina, requiere el id del ingreso
  const ListadoCateteresPage({super.key, required this.idIngreso});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // obtiene el rol del usuario actual
    final role = ref.watch(roleProvider);
    // verifica si el usuario es admin
    final isAdmin = role == UserRole.admin;
    // obtiene la lista de cateteres desde el proveedor
    final cateteresAsync = ref.watch(cateteresByIngresoProvider(idIngreso));
    // formato para mostrar fechas
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catéteres"),
        centerTitle: true,
        elevation: 0,
      ),
      body: cateteresAsync.when(
        data: (cateteres) {
          if (cateteres.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services,
                      size: 60, color: Colors.blue.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No hay catéteres registrados",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Presiona el botón + para agregar uno nuevo",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cateteres.length,
            itemBuilder: (context, index) {
              final cateter = cateteres[index];
              final fechaInsercion = cateter.fechaInsercion;
              final fechaRetiro = cateter.fechaRetiro;
              final diasEnUso = fechaRetiro == null
                  ? DateTime.now().difference(fechaInsercion).inDays
                  : fechaRetiro.difference(fechaInsercion).inDays;
              final isActive = fechaRetiro == null;
              final tipoCateter = cateter.tipo.trim().toLowerCase();
              final isPeriferico = tipoCateter.contains("periférico");

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
                      Icons.medical_services,
                      color: isActive
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                    ),
                  ),
                  title: Text(
                    cateter.tipo,
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
                          isActive ? 'ACTIVO' : 'RETIRADO',
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
                          color:
                              diasEnUso > 7 ? Colors.red : Colors.grey.shade600,
                        ),
                      ),
                      if (isPeriferico && diasEnUso >= 5) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.warning,
                            color: Colors.orange, size: 18),
                      ],
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
                              builder: (context) => EditCateterPage(
                                idIngreso: idIngreso,
                                cateter: cateter,
                              ),
                            ),
                          ),
                        ),
                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 20),
                          onPressed: () => _confirmDelete(context, ref, cateter),
                        ),
                    ],
                  ),
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Fecha de Inserción',
                      value: dateFormat.format(fechaInsercion),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.route,
                      label: 'Vía',
                      value: cateter.via,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.info,
                      label: 'Características sitio',
                      value: cateter.caracteristicasSitioInsercion.isNotEmpty
                          ? cateter.caracteristicasSitioInsercion
                          : 'Sin especificar',
                    ),
                    if (cateter.fechaCuracionOCambio != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.calendar_month,
                        label: 'Fecha curación / cambio',
                        value: dateFormat.format(cateter.fechaCuracionOCambio!),
                      ),
                    ],
                    if (fechaRetiro != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.event_busy,
                        label: 'Fecha de Retiro',
                        value: dateFormat.format(fechaRetiro),
                        valueColor: Colors.red,
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
        // muestra un indicador de carga mientras se obtienen los datos
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar los catéteres',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(cateteresByIngresoProvider(idIngreso)),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CreateCateterFloatingButton(idIngreso: idIngreso),
    );
  }

  // construye una fila con icono, etiqueta y valor para mostrar informacion
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

  // muestra un dialogo de confirmacion y elimina el cateter si se confirma
  void _confirmDelete(BuildContext context, WidgetRef ref, Cateter cateter) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content:
            const Text("¿Estás seguro de que deseas eliminar este catéter?"),
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
              .read(deleteCateterControllerProvider.notifier)
              .deleteCateter(idIngreso, cateter.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Catéter eliminado correctamente")),
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
