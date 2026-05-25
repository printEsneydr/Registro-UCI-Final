import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/domain/models/glasgow.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/presentation/controllers/glasgow_controller.dart';

// formulario para actualizar un registro existente de glasgow
class UpdateGlasgowForm extends ConsumerStatefulWidget {
  final String idIngreso;
  final String idRegistroDiario;
  final Glasgow glasgow;

  // constructor que recibe los ids y el objeto glasgow a editar
  const UpdateGlasgowForm({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.glasgow,
  });

  @override
  ConsumerState<UpdateGlasgowForm> createState() => _UpdateGlasgowFormState();
}

class _UpdateGlasgowFormState extends ConsumerState<UpdateGlasgowForm> {
  late int _aperturaOcular;
  late int _respuestaVerbal;
  late int _respuestaMotora;
  late TimeOfDay _horaRegistro;
  late TextEditingController _observacionesController;

  final List<Map<String, dynamic>> _opcionesOculares = [
    {'valor': 4, 'texto': 'Espontáneamente'},
    {'valor': 3, 'texto': 'Al hablarle'},
    {'valor': 2, 'texto': 'Al dolor'},
    {'valor': 1, 'texto': 'No responde'},
  ];

  final List<Map<String, dynamic>> _opcionesVerbales = [
    {'valor': 5, 'texto': 'Orientado y conversa'},
    {'valor': 4, 'texto': 'Desorientado y conversa'},
    {'valor': 3, 'texto': 'Palabras inapropiadas'},
    {'valor': 2, 'texto': 'Sonidos incomprensibles'},
    {'valor': 1, 'texto': 'No responde'},
  ];

  final List<Map<String, dynamic>> _opcionesMotoras = [
    {'valor': 6, 'texto': 'Obedece órdenes verbales'},
    {'valor': 5, 'texto': 'Localiza estímulos dolorosos'},
    {'valor': 4, 'texto': 'Retiro'},
    {'valor': 3, 'texto': 'Flexión anormal'},
    {'valor': 2, 'texto': 'Extensión anormal'},
    {'valor': 1, 'texto': 'No responde'},
  ];

  // calcula el puntaje total sumando las tres subescalas
  int get _puntajeTotal =>
      _aperturaOcular + _respuestaVerbal + _respuestaMotora;

  // clasifica el puntaje en leve, moderado o grave
  String get _clasificacion {
    if (_puntajeTotal >= 13) return 'Leve';
    if (_puntajeTotal >= 9) return 'Moderado';
    return 'Grave';
  }

  // retorna el color segun la severidad (verde, naranja, rojo)
  Color get _colorClasificacion {
    if (_puntajeTotal >= 13) return Colors.green;
    if (_puntajeTotal >= 9) return Colors.orange;
    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
    _aperturaOcular = widget.glasgow.aperturaOcular;
    _respuestaVerbal = widget.glasgow.respuestaVerbal;
    _respuestaMotora = widget.glasgow.respuestaMotora;
    _horaRegistro = widget.glasgow.horaRegistro != null
        ? TimeOfDay.fromDateTime(widget.glasgow.horaRegistro!)
        : TimeOfDay.now();
    _observacionesController =
        TextEditingController(text: widget.glasgow.observaciones ?? '');
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildPuntajeCard(),
        const SizedBox(height: 16),
        _buildSection('APERTURA OCULAR', _opcionesOculares, _aperturaOcular,
            (val) => setState(() => _aperturaOcular = val)),
        const SizedBox(height: 16),
        _buildSection('RESPUESTA VERBAL', _opcionesVerbales, _respuestaVerbal,
            (val) => setState(() => _respuestaVerbal = val)),
        const SizedBox(height: 16),
        _buildSection('RESPUESTA MOTORA', _opcionesMotoras, _respuestaMotora,
            (val) => setState(() => _respuestaMotora = val)),
        const SizedBox(height: 16),
        ListTile(
          title: const Text('Hora de Registro'),
          subtitle: Text(_horaRegistro.format(context)),
          trailing: const Icon(Icons.access_time),
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: _horaRegistro,
            );
            if (picked != null && mounted) {
              setState(() => _horaRegistro = picked);
            }
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _observacionesController,
          decoration: const InputDecoration(
            labelText: 'Observaciones',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _actualizarGlasgow,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Actualizar Glasgow',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // construye la tarjeta que muestra el puntaje total y su clasificacion
  Widget _buildPuntajeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_puntajeTotal',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _colorClasificacion,
                  ),
                ),
              ],
            ),
            Text(
              'Puntaje Total',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _colorClasificacion.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _clasificacion,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _colorClasificacion,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // construye una seccion con opciones de radio para una subescala
  Widget _buildSection(
      String title, List<Map<String, dynamic>> opciones, int valorActual, Function(int) onChanged) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...opciones.map((opcion) => InkWell(
                  onTap: () => onChanged(opcion['valor']),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Radio<int>(
                          value: opcion['valor'],
                          groupValue: valorActual,
                          onChanged: (val) => onChanged(val!),
                        ),
                        Expanded(
                          child: Text(
                            '${opcion['valor']} - ${opcion['texto']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // guarda los cambios del glasgow en firestore y cierra el dialogo
  void _actualizarGlasgow() async {
    try {
      final now = DateTime.now();
      final horaRegistro = DateTime(
          now.year, now.month, now.day, _horaRegistro.hour, _horaRegistro.minute);

      final glasgowActualizado = Glasgow(
        idGlasgow: widget.glasgow.idGlasgow,
        idIngreso: widget.idIngreso,
        idRegistroDiario: widget.idRegistroDiario,
        aperturaOcular: _aperturaOcular,
        respuestaVerbal: _respuestaVerbal,
        respuestaMotora: _respuestaMotora,
        puntajeTotal: _puntajeTotal,
        horaRegistro: horaRegistro,
        observaciones: _observacionesController.text.isNotEmpty
            ? _observacionesController.text
            : null,
        fechaCreacion: widget.glasgow.fechaCreacion,
      );

      await ref.read(glasgowControllerProvider.notifier).updateGlasgow(
            widget.idIngreso,
            widget.idRegistroDiario,
            widget.glasgow.idGlasgow,
            glasgowActualizado,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Glasgow actualizado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
