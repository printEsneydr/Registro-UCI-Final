import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/dto/update_sonda_dto.dart';
import '../../../domain/models/sonda.dart';
import '../../controllers/update_sonda_controller.dart';
import '../../../data/constants/constants.dart';

// formulario para actualizar una sonda existente
class UpdateSondaForm extends ConsumerStatefulWidget {
  final Sonda sonda;
  final String idIngreso; // ✅ Nuevo parámetro

  const UpdateSondaForm({
    super.key,
    required this.sonda,
    required this.idIngreso,
  });

  @override
  ConsumerState<UpdateSondaForm> createState() => _UpdateSondaFormState();
}

// estado del formulario con los valores actuales de la sonda
class _UpdateSondaFormState extends ConsumerState<UpdateSondaForm> {
  final _formKey = GlobalKey<FormState>();
  late String tipo;
  late String regionAnatomica;
  late DateTime fechaColocacion;
  DateTime? fechaRetiro;
  late String _otroTipo;
  bool get _esOtro => tipo == 'Otro' || _esOtroGuardado;
  late bool _esOtroGuardado;

  @override
  // inicializa los valores del formulario con los datos de la sonda
  void initState() {
    super.initState();

    regionAnatomica =
        sondasPorRegion.keys.contains(widget.sonda.regionAnatomica)
            ? widget.sonda.regionAnatomica
            : sondasPorRegion.keys.first;

    final enLista = sondasPorRegion[regionAnatomica]
            ?.contains(widget.sonda.tipo) ??
        false;
    if (enLista) {
      tipo = widget.sonda.tipo;
      _otroTipo = '';
      _esOtroGuardado = false;
    } else {
      tipo = 'Otro';
      _otroTipo = widget.sonda.tipo;
      _esOtroGuardado = true;
    }

    fechaColocacion = widget.sonda.fechaColocacion;
    fechaRetiro = widget.sonda.fechaRetiro;
  }

  @override
  Widget build(BuildContext context) {
    final updateSondaState = ref.watch(updateSondaControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ✅ DROPDOWN REGIÓN ANATÓMICA
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Región Anatómica"),
            initialValue: regionAnatomica.isNotEmpty ? regionAnatomica : null,
            isExpanded: true,
            items: sondasPorRegion.keys.map((region) {
              return DropdownMenuItem(
                value: region,
                child:
                    Text(region, overflow: TextOverflow.ellipsis, maxLines: 1),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                regionAnatomica = value!;
                tipo = sondasPorRegion[regionAnatomica]?.first ?? "";
              });
            },
          ),

          const SizedBox(height: 10),

          // ✅ DROPDOWN TIPO DE SONDA
          if (regionAnatomica.isNotEmpty &&
              sondasPorRegion[regionAnatomica] != null)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Tipo de Sonda"),
              initialValue: _esOtro ? 'Otro' : tipo,
              isExpanded: true,
              items: [
                ...sondasPorRegion[regionAnatomica]!
                    .map((sonda) => DropdownMenuItem(
                          value: sonda,
                          child: Text(sonda,
                              overflow: TextOverflow.ellipsis, maxLines: 1),
                        )),
                const DropdownMenuItem(
                  value: 'Otro',
                  child: Text('Otro...'),
                ),
              ],
              onChanged: (value) => setState(() {
                tipo = value!;
                if (!_esOtro) _otroTipo = '';
              }),
            ),
          if (_esOtro) ...[
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Especifique el tipo de sonda",
                prefixIcon: Icon(Icons.edit),
              ),
              initialValue: _otroTipo,
              onChanged: (v) => _otroTipo = v,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Ingrese el tipo de sonda'
                  : null,
            ),
          ],

          const SizedBox(height: 10),

          // ✅ FECHA DE COLOCACIÓN (Solo lectura)
          TextFormField(
            decoration: const InputDecoration(labelText: "Fecha de colocación"),
            initialValue: "${fechaColocacion.toLocal()}".split(' ')[0],
            readOnly: true,
          ),

          const SizedBox(height: 10),

          // ✅ FECHA DE RETIRO (Seleccionable)
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Fecha de retiro (Opcional)",
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            controller: TextEditingController(
                text: fechaRetiro != null
                    ? "${fechaRetiro!.toLocal()}".split(' ')[0]
                    : ""),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: fechaRetiro ?? DateTime.now(),
                firstDate:
                    fechaColocacion, // ✅ No se puede seleccionar antes de la colocación
                lastDate: DateTime(
                    2101), // ✅ Permite seleccionar cualquier fecha futura
              );
              if (pickedDate != fechaRetiro) {
                setState(() {
                  fechaRetiro = pickedDate;
                });
              }
            },
          ),

          const SizedBox(height: 16),

          // ✅ BOTÓN DE ACTUALIZACIÓN
          ElevatedButton(
            onPressed: updateSondaState.isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      final dto = UpdateSondaDto(
                        tipo: _esOtro ? _otroTipo.trim() : tipo,
                        regionAnatomica: regionAnatomica,
                        fechaRetiro:
                            fechaRetiro, // ✅ Se actualiza la fecha de retiro
                      );
                      try {
                        await ref
                            .read(updateSondaControllerProvider.notifier)
                            .updateSonda(
                                widget.sonda.id, widget.idIngreso, dto);
                        Navigator.pop(
                            context); // ✅ Cierra la pantalla después de actualizar
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Error al actualizar la sonda: $error")),
                        );
                      }
                    }
                  },
            child: updateSondaState.isLoading
                ? const CircularProgressIndicator()
                : const Text('Actualizar Sonda'),
          ),
        ],
      ),
    );
  }
}
