import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/dto/create_cateter_dto.dart';
import '../../controllers/create_cateter_controller.dart';
import '../../../data/providers/cateteres_providers.dart';
import '../../../data/constants/constants.dart';

// formulario para crear un nuevo cateter
class CreateCateterForm extends ConsumerStatefulWidget {
  final String idIngreso;
  const CreateCateterForm({super.key, required this.idIngreso});

  @override
  ConsumerState<CreateCateterForm> createState() => _CreateCateterFormState();
}

// estado del formulario con los campos y controladores
class _CreateCateterFormState extends ConsumerState<CreateCateterForm> {
  final _formKey = GlobalKey<FormState>();
  String? _tipo;
  String? _via;
  DateTime _fechaInsercion = DateTime.now();
  DateTime? _fechaCuracion;
  final _caracteristicasController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  late TextEditingController _fechaController;
  late TextEditingController _fechaCuracionController;

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(
      text: _dateFormat.format(_fechaInsercion),
    );
    _fechaCuracionController = TextEditingController();
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _fechaCuracionController.dispose();
    _caracteristicasController.dispose();
    super.dispose();
  }

  // abre el date picker para seleccionar la fecha de insercion
  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInsercion,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _fechaInsercion = picked;
        _fechaController.text = _dateFormat.format(picked);
      });
    }
  }

  // abre el date picker para seleccionar la fecha de curacion o cambio
  Future<void> _seleccionarFechaCuracion() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaCuracion ?? DateTime.now(),
      firstDate: _fechaInsercion,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _fechaCuracion = picked;
        _fechaCuracionController.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(createCateterControllerProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              InkWell(
                onTap: _seleccionarFecha,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Fecha de inserción",
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
              InkWell(
                onTap: _seleccionarFechaCuracion,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Fecha de curación o cambio (opcional)",
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _fechaCuracionController.text.isEmpty
                        ? 'Seleccionar fecha'
                        : _fechaCuracionController.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: _fechaCuracionController.text.isEmpty
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipo,
                items: tiposCateter
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _tipo = value),
                decoration: const InputDecoration(
                  labelText: "Tipo de Catéter",
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) =>
                    value == null ? 'Seleccione un tipo' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _via,
                items: viasCateter
                    .map((via) => DropdownMenuItem(
                          value: via,
                          child: Text(via),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _via = value),
                decoration: const InputDecoration(
                  labelText: "Vía",
                  prefixIcon: Icon(Icons.route),
                ),
                validator: (value) =>
                    value == null ? 'Seleccione una vía' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caracteristicasController,
                decoration: const InputDecoration(
                  labelText: "Características sitio de inserción",
                  hintText: "Ej: limpio, enrojecido, secreción, etc.",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: estado.isLoading ? null : _guardarCateter,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: estado.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // guarda el cateter en firebase usando el controlador
  void _guardarCateter() {
    if (_formKey.currentState!.validate()) {
      final nuevoCateter = CreateCateterDto(
        idIngreso: widget.idIngreso,
        tipo: _tipo!,
        via: _via!,
        fechaInsercion: _fechaInsercion,
        fechaCuracionOCambio: _fechaCuracion,
        caracteristicasSitioInsercion: _caracteristicasController.text,
      );

      ref
          .read(createCateterControllerProvider.notifier)
          .createCateter(nuevoCateter)
          .then((_) {
        ref.invalidate(cateteresByIngresoProvider(widget.idIngreso));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Catéter creado correctamente")),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al crear catéter: $error")),
        );
      });
    }
  }
}
