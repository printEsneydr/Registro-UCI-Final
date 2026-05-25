import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/form_fields/dropdown_button_form_field.dart';
import 'package:registro_uci/common/components/form_fields/text_form_field.dart';
import 'package:registro_uci/common/validators/default_validator.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/providers/liquidos_administrados_provider.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/widgets/components/buttons/create_liquido_administrado_form_button.dart';

// categorias disponibles para clasificar los liquidos administrados
const categoriasLiquidos = [
  'Medicamentos',
  'Líquidos Endovenosos',
  'Nutrición Enteral / Vía Oral',
  'Irrigación',
  'Otros'
];

// lista de medicamentos predefinidos
const medicamentos = [
  'Paracetamol',
  'Ibuprofeno',
  'Ranitidina',
  'Amoxicilina',
  'Ceftriaxona',
  'Metronidazol',
  'Vancomicina',
  'Meropenem',
  'Potasio',
  'Otros'
];

// lista de liquidos endovenosos predefinidos
const liquidosEndovenosos = [
  'Solución Salina 0.9%',
  'Solución Salina 0.45%',
  'Dextrosa 5%',
  'Dextrosa 10%',
  'Bicarbonato de Sodio',
  'Albumina',
  'Plasma',
  'Otros'
];

// opciones de nutricion enteral y via oral predefinidas
const nutricionEnteral = [
  'Fórmula Polimérica',
  'Fórmula Elemental',
  'Fórmula Hipercalórica',
  'Agua de Sonda',
  'Dieta oral líquida',
  'Otros'
];

// widget con formulario para crear un nuevo liquido administrado
class CreateLiquidoAdministradoForm extends StatefulWidget {
  // parametros con ids del contexto del balance
  final LiquidosAdministradosParams params;

  const CreateLiquidoAdministradoForm({super.key, required this.params});

  @override
  State<CreateLiquidoAdministradoForm> createState() =>
      _CreateLiquidoAdministradoFormState();
}

// estado del formulario con controladores y logica de seleccion de categoria
class _CreateLiquidoAdministradoFormState
    extends State<CreateLiquidoAdministradoForm> {
  late TextEditingController _cantidadController;
  late TextEditingController _comentarioController;
  late TextEditingController _dosisController;
  late TextEditingController _otroController;
  String? _selectedCategoria;
  String? _selectedLiquido;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // retorna la lista de opciones segun la categoria seleccionada
  List<String> _getLiquidosForCategoria(String categoria) {
    switch (categoria) {
      case 'Medicamentos':
        return medicamentos;
      case 'Líquidos Endovenosos':
        return liquidosEndovenosos;
      case 'Nutrición Enteral / Vía Oral':
        return nutricionEnteral;
      default:
        return ['Otros'];
    }
  }

  @override
  void initState() {
    super.initState();
    _cantidadController = TextEditingController();
    _comentarioController = TextEditingController();
    _dosisController = TextEditingController();
    _otroController = TextEditingController();
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _comentarioController.dispose();
    _dosisController.dispose();
    _otroController.dispose();
    super.dispose();
  }

  // construye el formulario con dropdowns de categoria, liquido y campos de texto
  @override
  Widget build(BuildContext context) {
    final dateString = widget.params.idRegistroDiario;
    final hourString = widget.params.idBalanceLiquidos;

    final dateParts = dateString.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);
    final hour = int.parse(hourString);
    final dateTime = DateTime(year, month, day, hour);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 15),
            EnumDropdownButtonFormField(
              value: _selectedCategoria,
              label: "Categoría",
              values: categoriasLiquidos,
              onSelected: (newValue) {
                setState(() {
                  _selectedCategoria = newValue;
                  _selectedLiquido = null;
                });
              },
              validator: (value) =>
                  value == null ? 'Seleccione una categoría' : null,
            ),
            const SizedBox(height: 15),
            if (_selectedCategoria != null) ...[
              EnumDropdownButtonFormField(
                value: _selectedLiquido,
                label: _selectedCategoria == 'Medicamentos'
                    ? 'Medicamento'
                    : _selectedCategoria == 'Líquidos Endovenosos'
                        ? 'Líquido Endovenoso'
                        : _selectedCategoria == 'Nutrición Enteral / Vía Oral'
                            ? 'Nutrición'
                            : 'Tipo',
                values: _getLiquidosForCategoria(_selectedCategoria!),
                onSelected: (newValue) {
                  setState(() {
                    _selectedLiquido = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 15),
            ],
            Visibility(
              visible: _selectedLiquido == 'Otros',
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: OutlinedTextFormField(
                  controller: _otroController,
                  label: "Especificar",
                  prefixIcon: const Icon(Icons.edit_outlined),
                  validator: (value) =>
                      value != null && value.isEmpty ? 'Especifique' : null,
                ),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedTextFormField(
              controller: _cantidadController,
              label: "Cantidad (ml)",
              prefixIcon: const Icon(Icons.local_drink_outlined, size: 25),
              textInputType: TextInputType.number,
              validator: defaultValidator,
            ),
            const SizedBox(height: 15),
            OutlinedTextFormField(
              controller: _dosisController,
              label: _selectedCategoria == 'Medicamentos'
                  ? "Dosis"
                  : "Concentración",
              prefixIcon: const Icon(Icons.medication_outlined, size: 25),
            ),
            const SizedBox(height: 15),
            OutlinedTextFormField(
              controller: _comentarioController,
              label: "Comentario",
              prefixIcon: const Icon(Icons.comment_outlined, size: 25),
            ),
            const SizedBox(height: 30),
            CreateLiquidoAdministradoFormButton(
              formKey: _formKey,
              selectedMedicamento: _selectedLiquido,
              otherMedicamentoController: _otroController,
              cantidadController: _cantidadController,
              comentarioController: _comentarioController,
              dosisController: _dosisController,
              params: widget.params,
              hora: dateTime,
            ),
          ],
        ),
      ),
    );
  }
}
