import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/features/cateteres/data/constants/constants.dart';
import 'package:registro_uci/features/cateteres/data/dto/update_cateter_dto.dart';
import 'package:registro_uci/features/cateteres/data/providers/cateteres_providers.dart';
import 'package:registro_uci/features/cateteres/domain/models/cateter.dart';

// pagina para editar los datos de un cateter existente
class EditCateterPage extends ConsumerStatefulWidget {
  // id del ingreso al que pertenece el cateter
  final String idIngreso;
  // cateter que se va a editar
  final Cateter cateter;

  // constructor, requiere el id del ingreso y el cateter a editar
  const EditCateterPage({
    super.key,
    required this.idIngreso,
    required this.cateter,
  });

  @override
  _EditCateterPageState createState() => _EditCateterPageState();
}

// estado del formulario de edicion de cateter
class _EditCateterPageState extends ConsumerState<EditCateterPage> {
  // clave global para validar el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // controladores para los campos de texto
  late TextEditingController fechaInsercionController;
  late TextEditingController fechaRetiroController;
  late TextEditingController fechaCuracionController;
  late TextEditingController caracteristicasController;
  // valores seleccionados en los dropdowns
  String? selectedTipo;
  String? selectedVia;

  // inicializa los controladores con los valores actuales del cateter
  @override
  void initState() {
    super.initState();
    final df = DateFormat('dd/MM/yyyy');
    fechaInsercionController = TextEditingController(
        text: df.format(widget.cateter.fechaInsercion));
    fechaRetiroController = TextEditingController(
        text: widget.cateter.fechaRetiro != null
            ? df.format(widget.cateter.fechaRetiro!)
            : "");
    fechaCuracionController = TextEditingController(
        text: widget.cateter.fechaCuracionOCambio != null
            ? df.format(widget.cateter.fechaCuracionOCambio!)
            : "");
    caracteristicasController = TextEditingController(
        text: widget.cateter.caracteristicasSitioInsercion);

    selectedTipo =
        tiposCateter.contains(widget.cateter.tipo) ? widget.cateter.tipo : null;
    selectedVia = viasCateter.contains(widget.cateter.via)
        ? widget.cateter.via
        : null;
  }

  // libera los controladores al salir de la pantalla
  @override
  void dispose() {
    fechaInsercionController.dispose();
    fechaRetiroController.dispose();
    fechaCuracionController.dispose();
    caracteristicasController.dispose();
    super.dispose();
  }

  // abre el selector de fecha yactualiza el controlador correspondiente
  Future<void> _seleccionarFecha(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Catéter")),
      // formulario con campos para editar los datos del cateter
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedTipo,
                onChanged: (value) => setState(() => selectedTipo = value),
                items: tiposCateter.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo));
                }).toList(),
                decoration: const InputDecoration(labelText: "Tipo de Catéter"),
                validator: (value) =>
                    value == null ? "Seleccione un tipo de catéter" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: selectedVia,
                onChanged: (value) => setState(() => selectedVia = value),
                items: viasCateter.map((via) {
                  return DropdownMenuItem(value: via, child: Text(via));
                }).toList(),
                decoration: const InputDecoration(labelText: "Vía"),
                validator: (value) =>
                    value == null ? "Seleccione una vía" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: fechaInsercionController,
                decoration: const InputDecoration(labelText: "Fecha de Inserción"),
                readOnly: true,
                onTap: () => _seleccionarFecha(fechaInsercionController),
                validator: (value) =>
                    value!.isEmpty ? "Seleccione una fecha de inserción" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: fechaCuracionController,
                decoration: const InputDecoration(labelText: "Fecha de curación / cambio (opcional)"),
                readOnly: true,
                onTap: () => _seleccionarFecha(fechaCuracionController),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: caracteristicasController,
                decoration: const InputDecoration(
                  labelText: "Características sitio de inserción",
                  hintText: "Ej: limpio, enrojecido, secreción",
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: fechaRetiroController,
                decoration: const InputDecoration(labelText: "Fecha de Retiro (opcional)"),
                readOnly: true,
                onTap: () => _seleccionarFecha(fechaRetiroController),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final dto = UpdateCateterDto(
                      tipo: selectedTipo,
                      via: selectedVia,
                      fechaInsercion: fechaInsercionController.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy').parse(fechaInsercionController.text)
                          : null,
                      fechaCuracionOCambio: fechaCuracionController.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy').parse(fechaCuracionController.text)
                          : null,
                      caracteristicasSitioInsercion: caracteristicasController.text.isNotEmpty
                          ? caracteristicasController.text
                          : null,
                      fechaRetiro: fechaRetiroController.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy').parse(fechaRetiroController.text)
                          : null,
                    );

                    await ref.read(actualizarCateterProvider((
                      idIngreso: widget.idIngreso,
                      idCateter: widget.cateter.id,
                      dto: dto,
                    )).future);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Catéter actualizado exitosamente."),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text("Guardar Cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
