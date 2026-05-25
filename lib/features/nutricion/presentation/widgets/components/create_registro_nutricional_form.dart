import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/nutricion/data/dto/create_registro_nutricional_dto.dart';
import 'package:registro_uci/features/nutricion/data/providers/nutricion_provider.dart';
import 'package:registro_uci/features/nutricion/data/repositories/firebase_nutricion_repository.dart';

// formulario para crear un nuevo registro nutricional con antropometria y distribucion calorica
class CreateRegistroNutricionalForm extends ConsumerStatefulWidget {
  final String idIngreso;

  // constructor que recibe el id del ingreso
  const CreateRegistroNutricionalForm({
    super.key,
    required this.idIngreso,
  });

  @override
  ConsumerState<CreateRegistroNutricionalForm> createState() =>
      _CreateRegistroNutricionalFormState();
}

class _CreateRegistroNutricionalFormState
    extends ConsumerState<CreateRegistroNutricionalForm> {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _tallaController = TextEditingController();
  final _totalController = TextEditingController();
  final _proteinasController = TextEditingController();
  final _lipidosController = TextEditingController();
  final _carbohidratosController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _otraViaController = TextEditingController();

  String _via = 'Oral';
  TimeOfDay _hora = TimeOfDay.now();
  bool _isLoading = false;

  static const _opcionesVia = [
    'Oral',
    'Enteral',
    'Parenteral',
    'Mixta',
    'Ayuno',
  ];

  @override
  void dispose() {
    _pesoController.dispose();
    _tallaController.dispose();
    _totalController.dispose();
    _proteinasController.dispose();
    _lipidosController.dispose();
    _carbohidratosController.dispose();
    _observacionesController.dispose();
    _otraViaController.dispose();
    super.dispose();
  }

  // calcula el imc en tiempo real desde los controladores de peso y talla
  double get _imc {
    final peso = double.tryParse(_pesoController.text);
    final talla = double.tryParse(_tallaController.text);
    if (peso == null || talla == null || talla <= 0) return 0;
    return peso / ((talla / 100) * (talla / 100));
  }

  // calcula el requerimiento calorico estimado desde el peso
  double get _requerimientoCalorico {
    final peso = double.tryParse(_pesoController.text);
    if (peso == null || peso <= 0) return 0;
    return peso * 27.5;
  }

  // valida que el valor sea un numero positivo
  String? _validarNumeroPositivo(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    final numero = double.tryParse(value);
    if (numero == null) return 'Número inválido';
    if (numero <= 0) return 'Debe ser mayor a 0';
    return null;
  }

  // valida que el valor sea un porcentaje entre 0 y 100 (opcional)
  String? _validarPorcentaje(String? value) {
    if (value == null || value.isEmpty) return null;
    final numero = double.tryParse(value);
    if (numero == null) return 'Número inválido';
    if (numero < 0 || numero > 100) return 'Debe ser 0-100';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nuevo Registro Nutricional',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ── ANTROPOMETRÍA ──
              const Text(
                'ANTROPOMETRÍA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pesoController,
                      decoration: const InputDecoration(
                        labelText: 'Peso (kg)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      validator: _validarNumeroPositivo,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _tallaController,
                      decoration: const InputDecoration(
                        labelText: 'Talla (cm)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      validator: _validarNumeroPositivo,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_imc > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'IMC: ${_imc.toStringAsFixed(1)} | Requerimiento calórico: ${_requerimientoCalorico.toStringAsFixed(0)} kcal',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                ),
              const SizedBox(height: 20),

              // ── CÁLCULO GASTRO ENERGÉTICO ──
              const Text(
                'CÁLCULO GASTRO ENERGÉTICO',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: _hora);
                  if (time != null) setState(() => _hora = time);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Hora',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(_hora.format(context)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _opcionesVia.contains(_via) ? _via : 'Otro',
                decoration: const InputDecoration(
                  labelText: 'Vía',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                items: [
                  ..._opcionesVia.map((v) => DropdownMenuItem(value: v, child: Text(v))),
                  const DropdownMenuItem(value: 'Otro', child: Text('Otro...')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _via = value);
                },
              ),
              if (_via == 'Otro') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _otraViaController,
                  decoration: const InputDecoration(
                    labelText: 'Especifique la vía',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalController,
                decoration: const InputDecoration(
                  labelText: 'Total (kcal o ml)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                validator: _validarNumeroPositivo,
              ),
              const SizedBox(height: 20),

              // ── DISTRIBUCIÓN CALÓRICA ──
              const Text(
                'DISTRIBUCIÓN CALÓRICA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinasController,
                      decoration: const InputDecoration(
                        labelText: 'Proteínas (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      validator: _validarPorcentaje,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _lipidosController,
                      decoration: const InputDecoration(
                        labelText: 'Lípidos (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      validator: _validarPorcentaje,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _carbohidratosController,
                      decoration: const InputDecoration(
                        labelText: 'Carbohidratos (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      validator: _validarPorcentaje,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── OBSERVACIONES ──
              TextFormField(
                controller: _observacionesController,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // ── BOTONES ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _guardar,
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Guardar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // guarda el registro nutricional en firestore y refresca los providers
  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final peso = double.parse(_pesoController.text);
        final talla = double.parse(_tallaController.text);
        final via = _via == 'Otro' ? _otraViaController.text : _via;
        final now = DateTime.now();

        final dto = CreateRegistroNutricionalDto(
          peso: peso,
          talla: talla,
          imc: _imc,
          requerimientoCalorico: _requerimientoCalorico,
          hora: DateTime(now.year, now.month, now.day, _hora.hour, _hora.minute),
          via: via,
          total: double.tryParse(_totalController.text),
          proteinas: double.tryParse(_proteinasController.text),
          lipidos: double.tryParse(_lipidosController.text),
          carbohidratos: double.tryParse(_carbohidratosController.text),
          observaciones: _observacionesController.text.isEmpty ? null : _observacionesController.text,
        );

        final repository = FirebaseNutricionRepository();
        await repository.createRegistroNutricional(widget.idIngreso, dto);

        ref.invalidate(registrosNutricionalesProvider(widget.idIngreso));

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro guardado exitosamente'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
