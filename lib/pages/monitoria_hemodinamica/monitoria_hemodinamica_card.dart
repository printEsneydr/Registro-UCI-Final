import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/data/providers/monitoria_hemodinamica_provider.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/domain/models/monitoria_hemodinamica.dart';
import 'package:registro_uci/pages/monitoria_hemodinamica/monitoria_hemodinamica_form_page.dart';
import 'package:registro_uci/pages/monitoria_hemodinamica/monitoria_hemodinamica_edit_page.dart';
import 'package:registro_uci/pages/monitoria_hemodinamica/monitoria_hemodinamica_graphics_page.dart';

// card que muestra las monitorias hemodinamicas por hora con opciones
class MonitoriaHemodinamicaCard extends ConsumerWidget {
  // id del ingreso
  final String idIngreso;
  // id del registro diario
  final String idRegistroDiario;

  const MonitoriaHemodinamicaCard({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  // construye la card con encabezado, boton de graficos y lista de horas
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // parametros para consultar las monitorias
    final params = ParametrosMonitoriaHemodinamica(
      idIngreso: idIngreso,
      idRegistroDiario: idRegistroDiario,
    );
    // stream de datos de monitorias hemodinamicas
    final monitoriasData =
        ref.watch(monitoriasHemodinamicasStreamProvider(params));

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GraphicsPage(
                        idIngreso: idIngreso,
                        idRegistroDiario: idRegistroDiario,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.2),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(Icons.bar_chart_rounded, size: 24),
                label: const Text('Ver Gráficos'),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildContent(monitoriasData, context, ref),
          ],
        ),
      ),
    );
  }

  // construye el titulo del card
  Widget _buildHeader(BuildContext context) {
    return Text(
      'Monitoría Hemodinámica',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  // construye el contenido segun el estado de los datos (cargando, error, datos)
  Widget _buildContent(
    AsyncValue<List<MonitoriaHemodinamica>> monitoriasData,
    BuildContext context,
    WidgetRef ref,
  ) {
    return monitoriasData.when(
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLastParameters(data),
          const SizedBox(height: 16.0),
          ..._buildTimeList(data, context, ref),
        ],
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => _buildErrorWidget(context, ref, error),
    );
  }

  // widget que se muestra cuando hay un error al cargar los datos
  Widget _buildErrorWidget(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'Error al cargar los datos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              error.toString(),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(monitoriasHemodinamicasStreamProvider(
                  ParametrosMonitoriaHemodinamica(
                    idIngreso: idIngreso,
                    idRegistroDiario: idRegistroDiario,
                  ),
                ));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  // muestra el ultimo registro de monitoria registrado
  Widget _buildLastParameters(List<MonitoriaHemodinamica> data) {
    final lastRecord = data.isNotEmpty ? data.last : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Última hora registrada:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8.0),
        if (lastRecord != null)
          Text(
            'Hora: ${_formatHour(lastRecord.hora)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )
        else
          const Text(
            'No hay registros disponibles',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  // construye la lista de cards para cada hora del dia (8am a 7am)
  List<Widget> _buildTimeList(
    List<MonitoriaHemodinamica> monitorias,
    BuildContext context,
    WidgetRef ref,
  ) {
    const hours = [
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7
    ];

    return hours.map((hour) {
      final record = monitorias.firstWhere(
        (m) => m.hora == hour,
        orElse: () => const MonitoriaHemodinamica(
          idMonitoria: '',
          hora: 0,
          orden: 0,
        ),
      );
      final hasRecord = record.idMonitoria.isNotEmpty;

      return _buildTimeCard(context, ref,
          hour: hour, hasRecord: hasRecord, record: record);
    }).toList();
  }

  // construye un card individual para una hora especifica con acciones
  Widget _buildTimeCard(
    BuildContext context,
    WidgetRef ref, {
    required int hour,
    required bool hasRecord,
    required MonitoriaHemodinamica record,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showDetails(context, record),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildStatusIcon(hasRecord),
              const SizedBox(width: 12),
              _buildTimeLabel(hour, hasRecord),
              const Spacer(),
              _buildActionButtons(
                  context, ref, hour, hasRecord, record.idMonitoria),
            ],
          ),
        ),
      ),
    );
  }

  // icono que indica si hay un registro en esa hora
  Widget _buildStatusIcon(bool hasRecord) {
    return Icon(
      hasRecord ? Icons.check_circle : Icons.access_time,
      color: hasRecord ? Colors.green : Colors.grey,
    );
  }

  // texto que muestra la hora formateada
  Widget _buildTimeLabel(int hour, bool hasRecord) {
    return Flexible(
      child: Text(
        _formatHour(hour),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: hasRecord ? Colors.green : Colors.grey[700],
          fontSize: 13,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // botones de accion: agregar, editar y eliminar segun el rol
  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    int hour,
    bool hasRecord,
    String idMonitoria,
  ) {
    final role = ref.watch(roleProvider);
    final isAdmin = role == UserRole.admin;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: !hasRecord ? Colors.green : Colors.grey,
          ),
          onPressed: !hasRecord ? () => _createForm(context, hour: hour) : null,
          tooltip: 'Agregar registro',
          iconSize: 22,
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
        if (isAdmin) const SizedBox(width: 4),
        if (isAdmin)
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: hasRecord ? Colors.blue : Colors.grey,
            ),
            onPressed: hasRecord
                ? () => _editForm(context, hour: hour, idMonitoria: idMonitoria)
                : null,
            tooltip: 'Editar registro',
            iconSize: 22,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        if (isAdmin) const SizedBox(width: 4),
        if (isAdmin)
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: hasRecord ? Colors.red : Colors.grey,
            ),
            onPressed: hasRecord
                ? () => _confirmDelete(context, ref, idMonitoria, hour)
                : null,
            tooltip: 'Eliminar registro',
            iconSize: 22,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  // convierte una hora en formato 24h a formato 12h con AM/PM
  String _formatHour(int hour) {
    final hourFormatted = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = hour < 12 ? 'AM' : 'PM';
    return '${hourFormatted.toString().padLeft(2, '0')}:00 $period';
  }

  // muestra un dialogo con los detalles de la monitoria seleccionada
  void _showDetails(BuildContext context, MonitoriaHemodinamica record) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalles de Monitoría Hemodinámica'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Hora', _formatHour(record.hora)),
              _buildDetailItem('PA', '${record.pas}/${record.pad} mmHg'),
              if (record.pam != null)
                _buildDetailItem('PAM', '${record.pam} mmHg'),
              _buildDetailItem('FC', '${record.fc} ppm'),
              _buildDetailItem('FR', '${record.fr} rpm'),
              _buildDetailItem('Temperatura', '${record.t}°C'),
              if (record.pvc != null)
                _buildDetailItem('PVC', '${record.pvc} mmHg'),
              if (record.gc != null)
                _buildDetailItem('GC', '${record.gc} L/min'),
              if (record.ic != null)
                _buildDetailItem('IC', '${record.ic} L/min/m²'),
              if (record.rvs != null)
                _buildDetailItem('RVS', '${record.rvs} dyn·s/cm⁵'),
              if (record.irvs != null)
                _buildDetailItem('IRVS', '${record.irvs} dyn·s/cm⁵/m²'),
              if (record.fio2 != null)
                _buildDetailItem('FiO₂', '${record.fio2}%'),
              if (record.saturacion != null)
                _buildDetailItem('Sat O₂', '${record.saturacion}%'),
              if (record.glucometria != null)
                _buildDetailItem('Glucemia', '${record.glucometria} mg/dL'),
              if (record.insulina != null)
                _buildDetailItem('Insulina', '${record.insulina} U'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // construye una fila con etiqueta y valor para los detalles
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  // navega al formulario para crear un nuevo registro en la hora indicada
  void _createForm(BuildContext context, {required int hour}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioMonitoriaScreen(
          idIngreso: idIngreso,
          idRegistroDiario: idRegistroDiario,
          horaInicial: hour,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  // navega al formulario para editar un registro existente
  void _editForm(BuildContext context,
      {required int hour, required String idMonitoria}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMonitoriaScreen(
          idIngreso: idIngreso,
          idRegistroDiario: idRegistroDiario,
          horaInicial: hour,
          idMonitoriaExistente: idMonitoria,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  // muestra un dialogo de confirmacion y elimina el registro si se confirma
  void _confirmDelete(
      BuildContext context, WidgetRef ref, String idMonitoria, int hour) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar el registro de las ${_formatHour(hour)}?'),
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
          await ref.read(eliminarMonitoriaHemodinamicaProvider(
            ParametrosMonitoriaHemodinamica(
              idIngreso: idIngreso,
              idRegistroDiario: idRegistroDiario,
              idMonitoria: idMonitoria,
            ),
          ).future);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro eliminado correctamente')),
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
