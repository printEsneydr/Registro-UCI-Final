// pagina principal de observaciones extras, solicitudes, gram, firmas
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers/observaciones_extras_provider.dart';
import '../../domain/models/observaciones_extras_data.dart';
import '../widgets/firma_pad_widget.dart';

class ObservacionesExtrasPage extends ConsumerStatefulWidget {
  // id del ingreso al que pertenecen estos datos
  final String idIngreso;

  const ObservacionesExtrasPage({
    super.key,
    required this.idIngreso,
  });

  @override
  ConsumerState<ObservacionesExtrasPage> createState() => _ObservacionesExtrasPageState();
}

class _ObservacionesExtrasPageState extends ConsumerState<ObservacionesExtrasPage> {
  late ObservacionesExtrasData _data;
  bool _saving = false;
  final _obsController = TextEditingController();

  @override
  void dispose() {
    _obsController.dispose();
    super.dispose();
  }

  // guarda los datos en firestore y refresca el provider
  Future<void> _save() async {
    setState(() => _saving = true);
    _data.observaciones = _obsController.text;
    await ref.read(observacionesExtrasRepositoryProvider).save(
          widget.idIngreso,
          _data,
        );
    ref.invalidate(observacionesExtrasDataProvider(widget.idIngreso));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observaciones Extras y Firmas'),
        centerTitle: true,
        actions: [
          _saving
              ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
              : IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _save,
                  tooltip: 'Guardar todo',
                ),
        ],
      ),
      body: FutureBuilder<ObservacionesExtrasData>(
        future: ref.read(observacionesExtrasDataProvider(widget.idIngreso).future),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          _data = snapshot.data ?? ObservacionesExtrasData();
          _obsController.text = _data.observaciones;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('SOLICITUD DE LABORATORIO Y RADIOLOGÍA'),
                _buildSolicitudesTable(),
                const SizedBox(height: 24),
                _buildSectionTitle('GRAM Y/O CULTIVOS - BK'),
                _buildGramsTable(),
                const SizedBox(height: 24),
                _buildSectionTitle('ORDEN MÉDICA DE COMPONENTE SANGUÍNEO PARA TRANSFUNDIR'),
                _buildOrdenesTable(),
                const SizedBox(height: 24),
                _buildSectionTitle('OBSERVACIONES'),
                _buildObservaciones(),
                const SizedBox(height: 24),
                _buildSectionTitle('FIRMAS DEL PERSONAL DE ENFERMERÍA'),
                _buildFirmasTable(),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar Todo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  // construye un titulo de seccion con fondo azul
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // tabla de solicitudes de laboratorio y radiologia
  Widget _buildSolicitudesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        columns: const [
          DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Solicitud de Laboratorio\ny Exámenes de Radiología', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Resultados y\nObservaciones', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: List.generate(_data.solicitudes.length, (i) {
          final s = _data.solicitudes[i];
          return DataRow(cells: [
            DataCell(_DateCell(
              date: s.fecha,
              onChanged: (d) => setState(() => _data.solicitudes[i].fecha = d),
            )),
            DataCell(_TextCell(
              value: s.solicitud,
              onChanged: (v) => _data.solicitudes[i].solicitud = v,
            )),
            DataCell(_TextCell(
              value: s.resultados,
              onChanged: (v) => _data.solicitudes[i].resultados = v,
            )),
          ]);
        }),
      ),
    );
  }

  // tabla de gram y cultivos
  Widget _buildGramsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        columns: const [
          DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('GRAM y/o Cultivos - BK', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Resultados y\nObservaciones', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: List.generate(_data.grams.length, (i) {
          final g = _data.grams[i];
          return DataRow(cells: [
            DataCell(_DateCell(
              date: g.fecha,
              onChanged: (d) => setState(() => _data.grams[i].fecha = d),
            )),
            DataCell(_TextCell(
              value: g.cultivo,
              onChanged: (v) => _data.grams[i].cultivo = v,
            )),
            DataCell(_TextCell(
              value: g.resultados,
              onChanged: (v) => _data.grams[i].resultados = v,
            )),
          ]);
        }),
      ),
    );
  }

  // tabla de ordenes de transfusion sanguinea
  Widget _buildOrdenesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        columns: const [
          DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Glóbulos\nRojos', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Plaquetas', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Plasma', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: List.generate(_data.ordenes.length, (i) {
          final o = _data.ordenes[i];
          return DataRow(cells: [
            DataCell(_DateCell(
              date: o.fecha,
              onChanged: (d) => setState(() => _data.ordenes[i].fecha = d),
            )),
            DataCell(_TimeCell(
              value: o.hora,
              onChanged: (v) => setState(() => _data.ordenes[i].hora = v),
            )),
            DataCell(_TextCell(
              value: o.globulosRojos,
              onChanged: (v) => _data.ordenes[i].globulosRojos = v,
            )),
            DataCell(_TextCell(
              value: o.plaquetas,
              onChanged: (v) => _data.ordenes[i].plaquetas = v,
            )),
            DataCell(_TextCell(
              value: o.plasma,
              onChanged: (v) => _data.ordenes[i].plasma = v,
            )),
          ]);
        }),
      ),
    );
  }

  // campo de texto para observaciones generales
  Widget _buildObservaciones() {
    return TextField(
      controller: _obsController,
      maxLines: 5,
      decoration: const InputDecoration(
        hintText: 'Escriba observaciones aquí...',
        border: OutlineInputBorder(),
      ),
      onChanged: (v) => _data.observaciones = v,
    );
  }

  // tabla de firmas del personal de enfermeria por turno
  Widget _buildFirmasTable() {
    final tipos = ['ENFERMERA JEFE', 'ENFERMERA'];
    final turnos = ['Mañana', 'Tarde', 'Noche'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 8,
        columns: [
          const DataColumn(label: Text('Personal de Enfermería', style: TextStyle(fontWeight: FontWeight.bold))),
          ...turnos.map((t) => DataColumn(label: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)))),
        ],
        rows: tipos.map((tipo) {
          return DataRow(cells: [
            DataCell(Text(tipo, style: const TextStyle(fontWeight: FontWeight.w600))),
            ...turnos.map((turno) {
              final firma = _data.firmas.firstWhere(
                (f) => f.tipoPersonal == tipo && f.turno == turno,
                orElse: () => FirmaPersonal(tipoPersonal: tipo, turno: turno),
              );
              return DataCell(_FirmaCellWidget(
                firmaBase64: firma.firmaBase64,
                fechaFirma: firma.fechaFirma,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (ctx) => FirmaPadWidget(
                      initialBase64: firma.firmaBase64,
                      onSave: (base64) {
                        setState(() {
                          firma.firmaBase64 = base64;
                          firma.fechaFirma = DateTime.now();
                        });
                      },
                    ),
                  );
                },
                onClear: () {
                  setState(() {
                    firma.firmaBase64 = '';
                    firma.fechaFirma = null;
                  });
                },
              ));
            }),
          ]);
        }).toList(),
      ),
    );
  }
}

// widget interno para editar una fecha en una celda
class _DateCell extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  const _DateCell({this.date, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          date != null ? fmt.format(date!) : 'Seleccionar',
          style: TextStyle(fontSize: 12, color: date != null ? Colors.black : Colors.grey),
        ),
      ),
    );
  }
}

// widget interno para editar una hora en una celda
class _TimeCell extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _TimeCell({required this.value, required this.onChanged});

  @override
  State<_TimeCell> createState() => _TimeCellState();
}

class _TimeCellState extends State<_TimeCell> {
  late String _displayValue;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
  }

  @override
  void didUpdateWidget(_TimeCell old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value && widget.value != _displayValue) {
      _displayValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final initial = _displayValue.isNotEmpty
            ? TimeOfDay(
                hour: int.tryParse(_displayValue.split(':')[0]) ?? DateTime.now().hour,
                minute: int.tryParse(_displayValue.split(':')[1]) ?? DateTime.now().minute,
              )
            : TimeOfDay.now();
        final picked = await showTimePicker(
          context: context,
          initialTime: initial,
        );
        if (picked != null) {
          final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          setState(() => _displayValue = timeStr);
          widget.onChanged(timeStr);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          _displayValue.isNotEmpty ? _displayValue : 'Seleccionar',
          style: TextStyle(fontSize: 12, color: _displayValue.isNotEmpty ? Colors.black : Colors.grey),
        ),
      ),
    );
  }
}

// widget interno para editar texto en una celda
class _TextCell extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _TextCell({required this.value, required this.onChanged});

  @override
  State<_TextCell> createState() => _TextCellState();
}

class _TextCellState extends State<_TextCell> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_TextCell old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value && _ctrl.text != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: _ctrl,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(6),
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontSize: 12),
        onChanged: widget.onChanged,
      ),
    );
  }
}

// widget interno que muestra la firma capturada o un boton para firmar
class _FirmaCellWidget extends StatelessWidget {
  final String firmaBase64;
  final DateTime? fechaFirma;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _FirmaCellWidget({
    required this.firmaBase64,
    this.fechaFirma,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasFirma = firmaBase64.isNotEmpty;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
          color: hasFirma ? Colors.white : Colors.grey.shade50,
        ),
        child: hasFirma
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Image.memory(
                      base64Decode(firmaBase64),
                      width: 120,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        color: Colors.red.withOpacity(0.7),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                  if (fechaFirma != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          DateFormat('dd/MM HH:mm').format(fechaFirma!),
                          style: const TextStyle(fontSize: 8, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              )
            : const Center(
                child: Text(
                  'Tocar para\nfirmar',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ),
      ),
    );
  }
}
