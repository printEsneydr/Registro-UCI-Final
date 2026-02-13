import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/features/control_riesgos/data/providers/control_de_riesgos_provider.dart';
import 'package:registro_uci/features/control_riesgos/domain/models/control_de_riesgos.dart';
import 'package:registro_uci/features/control_riesgos/presentation/controllers/create_control_riesgos_controller.dart';
import '../../pages/control_riegos/create_control_riegos_page.dart';
import '../../pages/control_riegos/update_control_riegos_page.dart';

class ControlDeRiesgosPage extends ConsumerWidget {
  final String idIngreso;
  final String idRegistroDiario;

  const ControlDeRiesgosPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlDeRiesgosAsync = ref.watch(
      controlDeRiesgosByIngresoProvider(
        (idIngreso: idIngreso, idRegistroDiario: idRegistroDiario),
      ),
    );
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Riesgos'),
        centerTitle: true,
        elevation: 0,
      ),
      body: controlDeRiesgosAsync.when(
        data: (registros) {
          if (registros.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.health_and_safety,
                      size: 60, color: Colors.blue.shade300),
                  const SizedBox(height: 16),
                  Text(
                    "No hay registros de control de riesgos",
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
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final registro = registros[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _mostrarDetallesRegistro(context, registro),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                registro.numeroReporteEA != null
                                    ? "Reporte EA: ${registro.numeroReporteEA}"
                                    : "Registro sin número",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue, size: 20),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateControlRiesgosPage(
                                          idIngreso: idIngreso,
                                          idRegistroDiario: idRegistroDiario,
                                          controlRiesgosId:
                                              registro.idControlDeRiesgos,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  onPressed: () => _confirmDelete(
                                      context, ref, registro),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          registro.fechaRegistro != null
                              ? dateFormat.format(registro.fechaRegistro!)
                              : 'Sin fecha',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildRiskChip(
                                'UPP', registro.riesgoUPP ?? 'Sin riesgo'),
                            const SizedBox(width: 8),
                            _buildRiskChip(
                                'Caída', registro.riesgoCaida ?? 'Sin riesgo'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              size: 16,
                              color: registro.enAislamiento
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Aislamiento: ${registro.enAislamiento ? 'Sí (${registro.diasDeAislamiento ?? 0} días)' : 'No'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: registro.enAislamiento
                                    ? Colors.orange
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
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
                  'Error al cargar los registros',
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
                  onPressed: () => ref.invalidate(
                    controlDeRiesgosByIngresoProvider(
                      (idIngreso: idIngreso, idRegistroDiario: idRegistroDiario),
                    ),
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateControlRiesgosPage(
                idIngreso: idIngreso,
                idRegistroDiario: idRegistroDiario,
              ),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskChip(String label, String risk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getRiskColor(risk).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getRiskColor(risk).withOpacity(0.5)),
      ),
      child: Text(
        '$label: $risk',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _getRiskColor(risk),
        ),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'alto':
        return Colors.red;
      case 'moderado':
      case 'medio':
        return Colors.orange;
      case 'bajo':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _mostrarDetallesRegistro(
      BuildContext context, ControlDeRiesgos registro) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final dateOnlyFormat = DateFormat('dd/MM/yyyy');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Detalles del Registro - ${registro.numeroReporteEA ?? 'Sin número'}"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionTitle('Información General'),
                _buildDetailRow(
                    'Fecha de registro',
                    registro.fechaRegistro != null
                        ? dateFormat.format(registro.fechaRegistro!)
                        : 'No disponible'),
                _buildSectionTitle('Úlceras por Presión (UPP)'),
                _buildDetailRow('Tiene UPP', registro.tieneUPP ? 'Sí' : 'No'),
                if (registro.tieneUPP) ...[
                  _buildDetailRow(
                      'Fecha registro UPP',
                      registro.fechaRegistroUlcera != null
                          ? dateOnlyFormat.format(registro.fechaRegistroUlcera!)
                          : 'No disponible'),
                  _buildDetailRow('Número reporte EA',
                      registro.numeroReporteEA ?? 'No disponible'),
                  _buildDetailRow(
                      'Sitio UPP', registro.sitioUPP ?? 'No especificado'),
                  _buildDetailRow(
                      'UPP resuelta', registro.uppResuelta ? 'Sí' : 'No'),
                  if (registro.uppResuelta)
                    _buildDetailRow(
                        'Fecha resolución',
                        registro.fechaResolucion != null
                            ? dateOnlyFormat.format(registro.fechaResolucion!)
                            : 'No disponible'),
                  _buildDetailRow('Días con úlceras',
                      registro.diasConUlceras?.toString() ?? '0'),
                ],
                _buildSectionTitle('Control Diario UPP'),
                _buildDetailRow('Mañana',
                    registro.controlUPPManana?.toString() ?? 'No registrado'),
                _buildDetailRow('Tarde',
                    registro.controlUPPTarde?.toString() ?? 'No registrado'),
                _buildDetailRow('Noche',
                    registro.controlUPPNoche?.toString() ?? 'No registrado'),
                _buildSectionTitle('Riesgo de Caídas'),
                _buildDetailRow('Nivel de riesgo', registro.riesgoCaida),
                _buildDetailRow('Número reporte caída',
                    registro.numeroReporteCaida ?? 'No disponible'),
                _buildSectionTitle('Control Diario Caídas'),
                _buildDetailRow('Mañana',
                    registro.controlCaidaManana?.toString() ?? 'No registrado'),
                _buildDetailRow('Tarde',
                    registro.controlCaidaTarde?.toString() ?? 'No registrado'),
                _buildDetailRow('Noche',
                    registro.controlCaidaNoche?.toString() ?? 'No registrado'),
                _buildSectionTitle('Anticoagulantes'),
                _buildDetailRow('Usa anticoagulantes',
                    registro.usaAnticoagulantes ? 'Sí' : 'No'),
                if (registro.usaAnticoagulantes)
                  _buildDetailRow('Tipo',
                      registro.anticoagulanteSeleccionado ?? 'No especificado'),
                _buildSectionTitle('Aislamiento'),
                _buildDetailRow(
                    'En aislamiento', registro.enAislamiento ? 'Sí' : 'No'),
                if (registro.enAislamiento) ...[
                  _buildDetailRow(
                      'Tipo', registro.tipoAislamiento ?? 'No especificado'),
                  _buildDetailRow('Agente',
                      registro.agenteAislamiento ?? 'No especificado'),
                  _buildDetailRow(
                      'Fecha inicio',
                      registro.fechaInicioAislamiento != null
                          ? dateOnlyFormat.format(registro.fechaInicioAislamiento!)
                          : 'No disponible'),
                  _buildDetailRow(
                      'Fecha fin',
                      registro.fechaFinAislamiento != null
                          ? dateOnlyFormat.format(registro.fechaFinAislamiento!)
                          : 'No disponible'),
                  _buildDetailRow('Días de aislamiento',
                      registro.diasDeAislamiento?.toString() ?? '0'),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar', style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, ControlDeRiesgos registro) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((confirm) async {
      if (confirm == true) {
        try {
          await ref
              .read(createControlRiesgosControllerProvider.notifier)
              .deleteControlDeRiesgos(
                idIngreso,
                idRegistroDiario,
                registro.idControlDeRiesgos,
              );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Registro eliminado correctamente')),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al eliminar: $e')),
            );
          }
        }
      }
    });
  }
}
