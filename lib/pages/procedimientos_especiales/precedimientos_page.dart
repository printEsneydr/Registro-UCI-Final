import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import '../../features/procedimientos_especiales/data/providers/procedimiento_provider.dart';
import '../../features/procedimientos_especiales/domain/models/procedimientos_especiales.dart';

// pagina que lista los procedimientos especiales de un ingreso
class ProcedimientosPage extends ConsumerWidget {
  // id del ingreso al que pertenecen los procedimientos
  final String idIngreso;

  // constructor, requiere el id del ingreso
  const ProcedimientosPage({
    super.key,
    required this.idIngreso,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // obtiene la lista de procedimientos desde el proveedor
    final procedimientosAsync =
        ref.watch(procedimientoStreamProvider(idIngreso));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Procedimientos Especiales"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8),
        child: procedimientosAsync.when(
          data: (procedimientos) => procedimientos.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: procedimientos.length,
                  itemBuilder: (context, index) {
                    final procedimiento = procedimientos[index];
                    return _buildProcedimientoCard(context, ref, procedimiento);
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  "Error al cargar los procedimientos",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$error",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(procedimientoStreamProvider(idIngreso)),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoAgregar(context, ref),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // widget que se muestra cuando no hay procedimientos registrados
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services_outlined,
              size: 60, color: Colors.blue.shade300),
          const SizedBox(height: 16),
          Text(
            "No hay procedimientos registrados",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Presiona el botón + para agregar uno",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // construye una tarjeta expandible con la informacion del procedimiento
  Widget _buildProcedimientoCard(
    BuildContext context,
    WidgetRef ref,
    ProcedimientoEspecial procedimiento,
  ) {
    final role = ref.watch(roleProvider);
    final isAdmin = role == UserRole.admin;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getEstadoColor(procedimiento.estado).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getEstadoIcon(procedimiento.estado),
            color: _getEstadoColor(procedimiento.estado),
          ),
        ),
        title: Text(
          procedimiento.nombreProcedimiento,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getEstadoColor(procedimiento.estado).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getEstadoColor(procedimiento.estado),
                ),
              ),
              child: Text(
                procedimiento.estado,
                style: TextStyle(
                  color: _getEstadoColor(procedimiento.estado),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                onPressed: () => _editarNombre(context, ref, procedimiento),
                tooltip: 'Editar nombre',
              ),
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: () =>
                    _mostrarConfirmacionEliminar(context, ref, procedimiento),
                tooltip: 'Eliminar',
              ),
          ],
        ),
        children: [
          const Divider(),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.medical_services,
            label: 'Procedimiento',
            value: procedimiento.nombreProcedimiento,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Estado Actual',
            value: procedimiento.estado,
          ),
          if (procedimiento.medicamentoInfusion != null &&
              procedimiento.medicamentoInfusion!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.medication,
              label: 'Medicamento en infusión',
              value: procedimiento.medicamentoInfusion!,
            ),
          ],
          if (procedimiento.dosisInfusion != null &&
              procedimiento.dosisInfusion!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.speed,
              label: 'Dosis / Velocidad',
              value: procedimiento.dosisInfusion!,
            ),
          ],
          const SizedBox(height: 12),
          if (isAdmin)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _actualizarEstado(context, ref, procedimiento),
                icon: const Icon(Icons.update),
                label: const Text("Cambiar Estado"),
              ),
            ),
        ],
      ),
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

  // devuelve el color segun el estado del procedimiento
  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Por realizar':
        return Colors.orange;
      case 'Realizado':
        return Colors.green;
      case 'Reportado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // devuelve el icono segun el estado del procedimiento
  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case 'Por realizar':
        return Icons.access_time;
      case 'Realizado':
        return Icons.check_circle;
      case 'Reportado':
        return Icons.description;
      default:
        return Icons.help;
    }
  }

  // muestra un dialogo con formulario para agregar un nuevo procedimiento
  void _mostrarDialogoAgregar(BuildContext context, WidgetRef ref) {
    final nombreCtrl = TextEditingController();
    final medicamentoCtrl = TextEditingController();
    final dosisCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String estadoSeleccionado = "Por realizar";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar Procedimiento"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nombre del Procedimiento",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medical_services),
                  ),
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingrese el nombre'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: medicamentoCtrl,
                  decoration: const InputDecoration(
                    labelText: "Medicamento en infusión (opcional)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medication),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: dosisCtrl,
                  decoration: const InputDecoration(
                    labelText: "Dosis / Velocidad de infusión (opcional)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.speed),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: estadoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: "Estado",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Por realizar", child: Text("Por realizar")),
                    DropdownMenuItem(value: "Realizado", child: Text("Realizado")),
                    DropdownMenuItem(value: "Reportado", child: Text("Reportado")),
                  ],
                  onChanged: (v) {
                    estadoSeleccionado = v!;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final medicamento = medicamentoCtrl.text.trim();
                  final dosis = dosisCtrl.text.trim();
                  await ref
                      .read(procedimientoActionProvider)
                      .addProcedimiento(
                        idIngreso,
                        nombreCtrl.text.trim(),
                        medicamentoInfusion:
                            medicamento.isNotEmpty ? medicamento : null,
                        dosisInfusion: dosis.isNotEmpty ? dosis : null,
                        estado: estadoSeleccionado,
                      );
                  ref.invalidate(procedimientoStreamProvider(idIngreso));
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Procedimiento agregado correctamente"),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al agregar: $e")),
                    );
                  }
                }
              }
            },
            child: const Text("Agregar"),
          ),
        ],
      ),
    );
  }

  // muestra un dialogo para editar el nombre del procedimiento
  void _editarNombre(
    BuildContext context,
    WidgetRef ref,
    ProcedimientoEspecial procedimiento,
  ) {
    final TextEditingController controller =
        TextEditingController(text: procedimiento.nombreProcedimiento);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Nombre"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Nuevo Nombre",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.edit),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await ref
                      .read(procedimientoActionProvider)
                      .editProcedimientoNombre(
                        idIngreso,
                        procedimiento.idProcedimiento,
                        controller.text,
                      );
                  ref.invalidate(procedimientoStreamProvider(idIngreso));
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Nombre actualizado correctamente")),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al actualizar: $e")),
                    );
                  }
                }
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  // muestra un dialogo de confirmacion para eliminar un procedimiento
  void _mostrarConfirmacionEliminar(
    BuildContext context,
    WidgetRef ref,
    ProcedimientoEspecial procedimiento,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Eliminación"),
        content: const Text(
            "¿Estás seguro de que deseas eliminar este procedimiento?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                await ref.read(procedimientoActionProvider).deleteProcedimiento(
                      idIngreso,
                      procedimiento.idProcedimiento,
                    );
                ref.invalidate(procedimientoStreamProvider(idIngreso));
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Procedimiento eliminado correctamente")),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al eliminar: $e")),
                  );
                }
              }
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  // muestra un dialogo para cambiar el estado del procedimiento
  void _actualizarEstado(
    BuildContext context,
    WidgetRef ref,
    ProcedimientoEspecial procedimiento,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Actualizar Estado",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            _buildEstadoOption(
              context,
              ref,
              procedimiento,
              "Por realizar",
              Colors.orange,
              Icons.access_time,
            ),
            _buildEstadoOption(
              context,
              ref,
              procedimiento,
              "Realizado",
              Colors.green,
              Icons.check_circle,
            ),
            _buildEstadoOption(
              context,
              ref,
              procedimiento,
              "Reportado",
              Colors.blue,
              Icons.description,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
          ],
        ),
      ),
    );
  }

  // construye una opcion de estado para el dialogo de actualizar estado
  Widget _buildEstadoOption(
    BuildContext context,
    WidgetRef ref,
    ProcedimientoEspecial procedimiento,
    String estado,
    Color color,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        estado,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: () async {
        try {
          await ref.read(procedimientoActionProvider).updateProcedimientoEstado(
                idIngreso,
                procedimiento.idProcedimiento,
                estado,
              );
          ref.invalidate(procedimientoStreamProvider(idIngreso));
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Estado actualizado a $estado")),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error al actualizar: $e")),
            );
          }
        }
      },
    );
  }
}
