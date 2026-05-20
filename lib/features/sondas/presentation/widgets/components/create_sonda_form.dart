import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/dto/create_sonda_dto.dart';
import '../../../data/providers/sonda_provider.dart';
import '../../controllers/create_sonda_controller.dart';
import '../../../data/constants/constants.dart';

class CreateSondaForm extends ConsumerStatefulWidget {
  final String idIngreso;

  const CreateSondaForm({super.key, required this.idIngreso});

  @override
  ConsumerState<CreateSondaForm> createState() => _CreateSondaFormState();
}

class _CreateSondaFormState extends ConsumerState<CreateSondaForm> {
  final _formKey = GlobalKey<FormState>();
  String? _regionSeleccionada;
  String? _tipoSondaSeleccionado;
  String _otroTipo = '';
  bool get _esOtro => _tipoSondaSeleccionado == 'Otro';
  DateTime _fechaColocacion = DateTime.now();
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final createSondaState = ref.watch(createSondaControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Región Anatómica",
              prefixIcon: Icon(Icons.category),
            ),
            value: _regionSeleccionada,
            isExpanded: true,
            items: sondasPorRegion.keys.map((region) {
              return DropdownMenuItem(
                value: region,
                child: Text(
                  region,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _regionSeleccionada = value;
                _tipoSondaSeleccionado = null;
              });
            },
            validator: (value) =>
                value == null ? 'Seleccione una región anatómica' : null,
          ),
          const SizedBox(height: 16),
          if (_regionSeleccionada != null)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Tipo de Sonda",
                prefixIcon: Icon(Icons.water_drop),
              ),
              value: _tipoSondaSeleccionado,
              isExpanded: true,
              items: [
                ...(sondasPorRegion[_regionSeleccionada] ?? [])
                    .map((sonda) => DropdownMenuItem(
                          value: sonda,
                          child: Text(
                            sonda,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )),
                const DropdownMenuItem(
                  value: 'Otro',
                  child: Text('Otro...'),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _tipoSondaSeleccionado = value),
              validator: (value) =>
                  value == null ? 'Seleccione un tipo de sonda' : null,
            ),
          if (_esOtro) ...[
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Especifique el tipo de sonda",
                prefixIcon: Icon(Icons.edit),
              ),
              onChanged: (v) => _otroTipo = v,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Ingrese el tipo de sonda'
                  : null,
            ),
          ],
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "Fecha de Colocación",
                prefixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _dateFormat.format(_fechaColocacion.toLocal()),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: createSondaState.isLoading
                ? null
                : () => _createSonda(createSondaState),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: createSondaState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Crear Sonda"),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaColocacion,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_fechaColocacion),
      );

      if (pickedTime != null) {
        setState(() {
          _fechaColocacion = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _createSonda(AsyncValue<void> createSondaState) {
    if (_formKey.currentState!.validate()) {
      final dto = CreateSondaDto(
        tipo: _esOtro ? _otroTipo.trim() : _tipoSondaSeleccionado!,
        regionAnatomica: _regionSeleccionada!,
        fechaColocacion: _fechaColocacion,
        idIngreso: widget.idIngreso,
      );

      ref
          .read(createSondaControllerProvider.notifier)
          .createSonda(dto)
          .then((_) {
        ref.invalidate(sondasProvider(widget.idIngreso));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al crear sonda: $error")),
        );
      });
    }
  }
}
