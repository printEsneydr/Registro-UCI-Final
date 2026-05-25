// boton que genera y comparte el pdf de la sabana clinica del paciente
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'package:registro_uci/features/reportes/application/pdf_reporte_service.dart';
import 'package:registro_uci/features/reportes/application/reporte_data_collector.dart';

class GenerarReportePdfButton extends ConsumerWidget {
  // id del ingreso y nombre del paciente para el encabezado del pdf
  final String idIngreso;
  final String nombrePaciente;

  const GenerarReportePdfButton({
    super.key,
    required this.idIngreso,
    required this.nombrePaciente,
  });

  // construye el boton verde para generar el reporte
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _generarYPrevisualizar(context, ref),
          icon: const Icon(Icons.picture_as_pdf, size: 22),
          label: const Text(
            'Generar Reporte PDF (Sábana Clínica)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  // recopila todos los datos, genera el pdf y lo comparte
  Future<void> _generarYPrevisualizar(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final scaffold = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          margin: EdgeInsets.all(24),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Generando reporte PDF...\nRecopilando datos del paciente',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final collector = ReporteDataCollector(idIngreso: idIngreso);
      final data = await collector.collectAll();

      if (!context.mounted) return;
      navigator.pop();

      final service = PdfReporteService();
      final pdfBytes = await service.generateReporte(
        ingreso: data.ingreso,
        registrosDiarios: data.registrosDiarios,
        monitorias: data.monitorias,
        sedaciones: data.sedaciones,
        cambiosPosicion: data.cambiosPosicion,
        glasgowRegistros: data.glasgowRegistros,
        cateteres: data.cateteres,
        marcapasos: data.marcapasos,
        sondas: data.sondas,
        listaTratamientos: data.listaTratamientos,
        controlRiesgos: data.controlRiesgos,
        procedimientos: data.procedimientos,
        nutricion: data.nutricion,
        liquidosAdministrados: data.liquidosAdministrados,
        liquidosEliminados: data.liquidosEliminados,
        antibioticos: data.antibioticos,
        firmas: data.firmas,
        necesidades: data.necesidades,
        observacionesExtras: data.observacionesExtras,
      );

      if (!context.mounted) return;

      final nombreArchivo =
          'sabana_paciente_${idIngreso}_${nombrePaciente.replaceAll(RegExp(r'[^\w]'), '_')}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: nombreArchivo,
      );
    } catch (e) {
      if (context.mounted) {
        try {
          navigator.pop();
        } catch (_) {}
        String mensaje;
        if (e.toString().contains('unavailable')) {
          mensaje = 'Error de conexión con Firestore. Verifica tu conexión a internet y vuelve a intentarlo.';
        } else {
          mensaje = 'Error al generar el reporte: $e';
        }
        scaffold.showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
