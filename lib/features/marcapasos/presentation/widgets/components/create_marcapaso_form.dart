import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/components/buttons/primary_button.dart';
import 'package:registro_uci/features/marcapasos/data/dto/create_marcapaso_dto.dart';
import 'package:registro_uci/features/marcapasos/data/providers/marcapasos_provider.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/features/marcapasos/data/constants/constants.dart';

class CreateMarcapasoForm extends ConsumerStatefulWidget {
  final String idIngreso;

  const CreateMarcapasoForm({super.key, required this.idIngreso});

  @override
  ConsumerState<CreateMarcapasoForm> createState() =>
      _CreateMarcapasoFormState();
}

class _CreateMarcapasoFormState extends ConsumerState<CreateMarcapasoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  late TextEditingController _fechaController;
  String? _selectedModo;
  String? _selectedVia;
  int? _selectedFrecuencia;
  double? _selectedSensibilidad;
  double? _selectedSalida;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(
      text: _dateFormat.format(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _fechaController.text = _dateFormat.format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Registro de Marcapaso",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Fecha de colocación",
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _fechaController.text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedModo,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Modo",
                prefixIcon: Icon(Icons.settings),
              ),
              onChanged: (value) => setState(() => _selectedModo = value),
              items: modosMarcapaso.map((modo) {
                return DropdownMenuItem(value: modo, child: Text(modo));
              }).toList(),
              validator: (value) => value == null ? "Seleccione un modo" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedVia,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Vía",
                prefixIcon: Icon(Icons.route),
              ),
              onChanged: (value) => setState(() => _selectedVia = value),
              items: viasMarcapaso.map((via) {
                return DropdownMenuItem(value: via, child: Text(via));
              }).toList(),
              validator: (value) => value == null ? "Seleccione una vía" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedFrecuencia,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Frecuencia",
                prefixIcon: Icon(Icons.speed),
              ),
              onChanged: (value) => setState(() => _selectedFrecuencia = value),
              items: frecuenciasMarcapaso.map((freq) {
                return DropdownMenuItem(value: freq, child: Text("$freq"));
              }).toList(),
              validator: (value) =>
                  value == null ? "Seleccione una frecuencia" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              value: _selectedSensibilidad,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Sensibilidad",
                prefixIcon: Icon(Icons.sensors),
              ),
              onChanged: (value) =>
                  setState(() => _selectedSensibilidad = value),
              items: sensibilidadesMarcapaso.map((sens) {
                return DropdownMenuItem(value: sens, child: Text("$sens"));
              }).toList(),
              validator: (value) =>
                  value == null ? "Seleccione una sensibilidad" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<double>(
              value: _selectedSalida,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Salida",
                prefixIcon: Icon(Icons.electric_bolt),
              ),
              onChanged: (value) => setState(() => _selectedSalida = value),
              items: salidasMarcapaso.map((salida) {
                return DropdownMenuItem(value: salida, child: Text("$salida"));
              }).toList(),
              validator: (value) =>
                  value == null ? "Seleccione una salida" : null,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              onTap: _isLoading ? null : _registerMarcapaso,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("REGISTRAR MARCAPASO"),
            ),
          ],
        ),
      ),
    );
  }

  void _registerMarcapaso() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final dto = CreateMarcapasoDto(
        idIngreso: widget.idIngreso,
        fechaColocacion: _fechaController.text,
        modo: _selectedModo ?? "No definido",
        via: _selectedVia ?? "No definida",
        frecuencia: _selectedFrecuencia ?? 0,
        sensibilidad: _selectedSensibilidad ?? 0.0,
        salida: _selectedSalida ?? 0.0,
      );

      try {
        await ref.read(registrarMarcapasoProvider(dto).future);
        ref.invalidate(marcapasosByIngresoProvider(widget.idIngreso));

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Marcapaso registrado exitosamente")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al registrar: $e")),
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
