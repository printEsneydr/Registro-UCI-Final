import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/necesidades/data/providers/reporte_necesidades_provider.dart';
import 'package:registro_uci/features/necesidades/domain/models/reporte_necesidades.dart';

class NecesidadesList extends ConsumerStatefulWidget {
  final String idIngreso;
  final String idRegistro;
  final bool readOnly;

  const NecesidadesList({
    super.key,
    required this.idIngreso,
    required this.idRegistro,
    this.readOnly = false,
  });

  @override
  ConsumerState<NecesidadesList> createState() => _NecesidadesListState();
}

class _NecesidadesListState extends ConsumerState<NecesidadesList> {
  final _necesidadesController = TextEditingController();
  final _objetivosController = TextEditingController();
  final _intervencionesController = TextEditingController();
  final _revistaController = TextEditingController();
  bool _isSaving = false;
  bool _loaded = false;

  @override
  void dispose() {
    _necesidadesController.dispose();
    _objetivosController.dispose();
    _intervencionesController.dispose();
    _revistaController.dispose();
    super.dispose();
  }

  void _loadData(ReporteNecesidades? reporte) {
    if (_loaded || reporte == null) return;
    _necesidadesController.text = reporte.necesidadesDetectadas;
    _objetivosController.text = reporte.objetivosEnfermeria;
    _intervencionesController.text = reporte.intervencionesRealizadas;
    _revistaController.text = reporte.revistaMedica;
    _loaded = true;
  }

  Future<void> _guardar() async {
    setState(() => _isSaving = true);
    try {
      final reporte = ReporteNecesidades(
        id: 'reporte',
        necesidadesDetectadas: _necesidadesController.text,
        objetivosEnfermeria: _objetivosController.text,
        intervencionesRealizadas: _intervencionesController.text,
        revistaMedica: _revistaController.text,
      );
      await guardarReporteNecesidades(
        idIngreso: widget.idIngreso,
        idRegistro: widget.idRegistro,
        reporte: reporte,
      );
      ref.invalidate(reporteNecesidadesProvider(
        ReporteNecesidadesParams(
          idIngreso: widget.idIngreso,
          idRegistro: widget.idRegistro,
        ),
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado exitosamente'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = ReporteNecesidadesParams(
      idIngreso: widget.idIngreso,
      idRegistro: widget.idRegistro,
    );
    final reporteAsync = ref.watch(reporteNecesidadesProvider(params));

    return reporteAsync.when(
      data: (reporte) {
        _loadData(reporte);
        return _buildForm();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Necesidades detectadas',
              hint: 'Ej: "Deterioro del intercambio gaseoso", "Riesgo de infección", "Déficit de movilidad"',
              controller: _necesidadesController,
              readOnly: widget.readOnly,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Objetivos de enfermería',
              hint: 'Ej: "Mantener SpO2 > 92%", "Prevenir úlceras por presión", "Lograr tolerancia a la vía oral"',
              controller: _objetivosController,
              readOnly: widget.readOnly,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Intervenciones realizadas',
              hint: 'Ej: "Administración de O2 por cánula", "Cambio de posición cada 2h", "Valoración de glucemia"',
              controller: _intervencionesController,
              readOnly: widget.readOnly,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Revista médica',
              hint: 'Notas del médico sobre la evolución del paciente',
              controller: _revistaController,
              readOnly: widget.readOnly,
            ),
            if (!widget.readOnly) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _guardar,
                  icon: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: const Text('Guardar', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool readOnly,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(12),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
