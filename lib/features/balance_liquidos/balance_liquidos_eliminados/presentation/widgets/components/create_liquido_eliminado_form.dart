import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/dto/create_liquido_eliminado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/providers/liquidos_eliminados_provider.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/repositories/firebase_liquidos_eliminados_repository.dart';

// widget con formulario para crear un nuevo registro de liquidos eliminados
class CreateLiquidoEliminadoForm extends ConsumerStatefulWidget {
  // parametros con ids de ingreso, registro diario y balance de liquidos
  final LiquidosEliminadosParams params;

  const CreateLiquidoEliminadoForm({super.key, required this.params});

  @override
  ConsumerState<CreateLiquidoEliminadoForm> createState() =>
      _CreateLiquidoEliminadoFormState();
}

// estado interno del formulario con controladores y logica de guardado
class _CreateLiquidoEliminadoFormState
    extends ConsumerState<CreateLiquidoEliminadoForm> {
  final _formKey = GlobalKey<FormState>();
  final _orinaController = TextEditingController(text: '0');
  final _perdidasInsensiblesController = TextEditingController(text: '0');
  final _sondaGastricaController = TextEditingController(text: '0');
  final _residuoGastricoController = TextEditingController(text: '0');
  final _tuboTorax1Controller = TextEditingController(text: '0');
  final _tuboTorax2Controller = TextEditingController(text: '0');
  final _tuboMediastinoController = TextEditingController(text: '0');
  final _drenAbdominalController = TextEditingController(text: '0');
  final _ileostomiaController = TextEditingController(text: '0');
  final _fistulaEnterocutaneaController = TextEditingController(text: '0');
  final _deposicionController = TextEditingController(text: '0');
  final _dialisisController = TextEditingController(text: '0');
  final _ventriculosTomaExternaController = TextEditingController(text: '0');
  final _otrosController = TextEditingController(text: '0');
  final _campoLibre1Controller = TextEditingController(text: '0');
  final _campoLibre2Controller = TextEditingController(text: '0');
  final _comentarioController = TextEditingController();
  TimeOfDay _hora = TimeOfDay.now();
  bool _isLoading = false;

  // libera todos los controladores al destruir el widget
  @override
  void dispose() {
    _orinaController.dispose();
    _perdidasInsensiblesController.dispose();
    _sondaGastricaController.dispose();
    _residuoGastricoController.dispose();
    _tuboTorax1Controller.dispose();
    _tuboTorax2Controller.dispose();
    _tuboMediastinoController.dispose();
    _drenAbdominalController.dispose();
    _ileostomiaController.dispose();
    _fistulaEnterocutaneaController.dispose();
    _deposicionController.dispose();
    _dialisisController.dispose();
    _ventriculosTomaExternaController.dispose();
    _otrosController.dispose();
    _campoLibre1Controller.dispose();
    _campoLibre2Controller.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  // valida que el valor ingresado sea un numero valido no negativo
  String? _validarNumero(String? value) {
    if (value == null || value.isEmpty) return 'Requerido';
    if (double.tryParse(value) == null) return 'Número inválido';
    if (double.parse(value) < 0) return 'No puede ser negativo';
    return null;
  }

  // construye un campo de texto numerico con icono y validacion
  Widget _buildField(String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        validator: _validarNumero,
      ),
    );
  }

  // construye el formulario completo con todos los campos de liquidos eliminados
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nuevo Registro de Líquidos Eliminados',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildField('Diuresis / Orina (ml)', Icons.water_drop, _orinaController),
              _buildField('Pérdidas Insensibles (ml)', Icons.opacity, _perdidasInsensiblesController),
              _buildField('Sonda Gástrica (ml)', Icons.biotech, _sondaGastricaController),
              _buildField('Residuo Gástrico (ml)', Icons.science, _residuoGastricoController),
              _buildField('Tubo Tórax 1 (ml)', Icons.air, _tuboTorax1Controller),
              _buildField('Tubo Tórax 2 (ml)', Icons.air, _tuboTorax2Controller),
              _buildField('Tubo Mediastino (ml)', Icons.medical_services, _tuboMediastinoController),
              _buildField('Dren Abdominal (ml)', Icons.plumbing, _drenAbdominalController),
              _buildField('Ileostomía (ml)', Icons.healing, _ileostomiaController),
              _buildField('Fístula Enterocutánea (ml)', Icons.call_split, _fistulaEnterocutaneaController),
              _buildField('Deposición (ml)', Icons.sick, _deposicionController),
              _buildField('Diálisis (ml)', Icons.bloodtype, _dialisisController),
              _buildField('Ventrículos Toma Externa (ml)', Icons.psychology, _ventriculosTomaExternaController),
              _buildField('Otros (ml)', Icons.more_horiz, _otrosController),
              _buildField('Campo Libre 1 (ml)', Icons.edit_note, _campoLibre1Controller),
              _buildField('Campo Libre 2 (ml)', Icons.edit_note, _campoLibre2Controller),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _hora,
                  );
                  if (time != null) {
                    setState(() => _hora = time);
                  }
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
              TextFormField(
                controller: _comentarioController,
                decoration: const InputDecoration(
                  labelText: 'Comentario (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
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
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
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

  // guarda el registro en firebase e invalida el provider para refrescar la lista
  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final dto = CreateLiquidoEliminadoDto(
          orina: double.parse(_orinaController.text),
          perdidasInsensibles: double.parse(_perdidasInsensiblesController.text),
          sondaGastrica: double.parse(_sondaGastricaController.text),
          residuoGastrico: double.parse(_residuoGastricoController.text),
          tuboTorax1: double.parse(_tuboTorax1Controller.text),
          tuboTorax2: double.parse(_tuboTorax2Controller.text),
          tuboMediastino: double.parse(_tuboMediastinoController.text),
          drenAbdominal: double.parse(_drenAbdominalController.text),
          ileostomia: double.parse(_ileostomiaController.text),
          fistulaEnterocutanea: double.parse(_fistulaEnterocutaneaController.text),
          deposicion: double.parse(_deposicionController.text),
          dialisis: double.parse(_dialisisController.text),
          ventriculosTomaExterna: double.parse(_ventriculosTomaExternaController.text),
          otros: double.parse(_otrosController.text),
          campoLibre1: double.parse(_campoLibre1Controller.text),
          campoLibre2: double.parse(_campoLibre2Controller.text),
          hora: DateTime(2024, 1, 1, _hora.hour, _hora.minute),
          comentario: _comentarioController.text.isEmpty
              ? null
              : _comentarioController.text,
        );

        final repository = FirebaseLiquidosEliminadosRepository();
        await repository.createLiquidoEliminado(
          widget.params.idIngreso,
          widget.params.idRegistroDiario,
          widget.params.idBalanceLiquidos,
          dto,
        );

        ref.invalidate(liquidosEliminadosProvider(widget.params));

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro guardado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
