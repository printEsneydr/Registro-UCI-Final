// formulario para crear un nuevo tratamiento en la lista
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/features/lista_tratamientos/domain/models/lista_tratamientos.dart';
import 'package:registro_uci/features/lista_tratamientos/presentation/controllers/create_lista_tratamientos_controller.dart';

class CreateListaTratamientosForm extends ConsumerStatefulWidget {
  // id del ingreso y del registro diario donde se agregara el tratamiento
  final String idIngreso;
  final String idRegistroDiario;

  const CreateListaTratamientosForm({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  @override
  ConsumerState<CreateListaTratamientosForm> createState() =>
      _CreateListaTratamientosFormState();
}

class _CreateListaTratamientosFormState
    extends ConsumerState<CreateListaTratamientosForm> {
  final _formKey = GlobalKey<FormState>();
  final _medicamentoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _unidadController = TextEditingController();
  final _frecuenciaController = TextEditingController();
  DateTime _fechaInicio = DateTime.now();
  DateTime? _fechaFin;
  final _observacionesController = TextEditingController();

  // libera los controladores de texto
  @override
  void dispose() {
    _medicamentoController.dispose();
    _cantidadController.dispose();
    _unidadController.dispose();
    _frecuenciaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  // muestra un date picker para seleccionar fecha de inicio o fin
  Future<void> _selectDate(BuildContext context, bool isFechaFin) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFechaFin ? _fechaFin ?? DateTime.now() : _fechaInicio,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFechaFin) {
          _fechaFin = picked;
        } else {
          _fechaInicio = picked;
        }
      });
    }
  }

  // construye el formulario con los campos para crear un tratamiento
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _medicamentoController,
            decoration: const InputDecoration(
              labelText: 'Medicamento *',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cantidadController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _unidadController,
                  decoration: const InputDecoration(
                    labelText: 'Unidad *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _frecuenciaController,
            decoration: const InputDecoration(
              labelText: 'Frecuencia (horas) *',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            validator: (value) =>
                value!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Fecha Inicio'),
            subtitle: Text(dateFormat.format(_fechaInicio)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context, false),
          ),
          ListTile(
            title: const Text('Fecha Fin (opcional)'),
            subtitle: Text(_fechaFin != null
                ? dateFormat.format(_fechaFin!)
                : 'No definida'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context, true),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _observacionesController,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _guardarTratamiento,
            child: const Text('Guardar Tratamiento'),
          ),
        ],
      ),
    );
  }

  // guarda el tratamiento en firestore usando el controlador
  void _guardarTratamiento() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(createListaTratamientosControllerProvider.notifier)
            .addListaTratamientos(
              widget.idIngreso,
              widget.idRegistroDiario,
              ListaTratamientos(
                idListaTratamientos: '',
                medicamento: _medicamentoController.text,
                cantidad: int.parse(_cantidadController.text),
                unidad: _unidadController.text,
                frecuencia: int.parse(_frecuenciaController.text),
                fechaInicio: _fechaInicio,
                fechaFin: _fechaFin,
                observaciones: _observacionesController.text.isNotEmpty
                    ? _observacionesController.text
                    : null,
                usuarioRegistro: null,
                fechaRegistro: DateTime.now(),
              ),
            );

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tratamiento guardado correctamente')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
