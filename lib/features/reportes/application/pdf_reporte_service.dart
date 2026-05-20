import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:registro_uci/features/ingresos/domain/models/ingreso.dart';
import 'package:registro_uci/features/registros_diarios/domain/models/registro_diario.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/domain/models/monitoria_hemodinamica.dart';
import 'package:registro_uci/features/control_sedacion/domain/models/control_sedacion.dart';
import 'package:registro_uci/features/control_cambio_posicion/domain/models/cambio_posicion.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/domain/models/glasgow.dart';
import 'package:registro_uci/features/cateteres/domain/models/cateter.dart';
import 'package:registro_uci/features/marcapasos/domain/models/marcapaso.dart';
import 'package:registro_uci/features/sondas/domain/models/sonda.dart';
import 'package:registro_uci/features/lista_tratamientos/domain/models/lista_tratamientos.dart';
import 'package:registro_uci/features/control_riesgos/domain/models/control_de_riesgos.dart';
import 'package:registro_uci/features/procedimientos_especiales/domain/models/procedimientos_especiales.dart';
import 'package:registro_uci/features/nutricion/domain/models/registro_nutricional.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/domain/models/liquido_administrado.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/domain/models/liquido_eliminado.dart';
import 'package:registro_uci/features/antibioticos/domain/models/tratamiento_antibiotico.dart';
import 'package:registro_uci/features/firmas/domain/models/firma.dart';
import 'package:registro_uci/features/necesidades/domain/models/reporte_necesidades.dart';
import 'package:registro_uci/features/observaciones_extras/domain/models/observaciones_extras_data.dart';

class PdfReporteService {
  static const _hours = [8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,1,2,3,4,5,6,7];

  late pw.Font _regularFont;
  late pw.Font _boldFont;

  Future<Uint8List> generateReporte({
    required Ingreso ingreso,
    required List<RegistroDiario> registrosDiarios,
    required List<MonitoriaHemodinamica> monitorias,
    required List<ControlSedacion> sedaciones,
    required List<CambioDePosicion> cambiosPosicion,
    required List<Glasgow> glasgowRegistros,
    required List<Cateter> cateteres,
    required List<Marcapaso> marcapasos,
    required List<Sonda> sondas,
    required List<ListaTratamientos> listaTratamientos,
    required ControlDeRiesgos? controlRiesgos,
    required List<ProcedimientoEspecial> procedimientos,
    required List<RegistroNutricional> nutricion,
    required List<LiquidoAdministrado> liquidosAdministrados,
    required List<LiquidoEliminado> liquidosEliminados,
    required List<TratamientoAntibiotico> antibioticos,
    required List<Firma> firmas,
    ReporteNecesidades? necesidades,
    ObservacionesExtrasData? observacionesExtras,
  }) async {
    _regularFont = pw.Font.ttf(await rootBundle.load('fonts/Plus_Jakarta/PlusJakartaSans-Regular.ttf'));
    _boldFont = pw.Font.ttf(await rootBundle.load('fonts/Plus_Jakarta/PlusJakartaSans-Bold.ttf'));

    final pdf = pw.Document();

    final headerInfo = _buildHeaderInfo(ingreso);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildPagina1(context, ingreso, headerInfo, controlRiesgos, nutricion, procedimientos, antibioticos, listaTratamientos),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildPagina2(context, ingreso, monitorias, marcapasos, cateteres),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildPagina3(context, ingreso, liquidosAdministrados, sondas),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildPagina4(context, ingreso, liquidosEliminados, liquidosAdministrados),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildPagina5(context, ingreso, glasgowRegistros, cambiosPosicion, sedaciones),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
            _buildObservacionesExtras(context, ingreso, registrosDiarios, sedaciones, firmas, necesidades, observacionesExtras),
        ],
      ),
    );

    return pdf.save();
  }

  String _buildHeaderInfo(Ingreso ingreso) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final diasHospitalizado = DateTime.now().difference(ingreso.fechaIngreso).inDays;
    return 'Día: ${dateFormat.format(DateTime.now())}  '
        'Fecha Ingreso: ${dateFormat.format(ingreso.fechaIngreso)}  '
        'Días Hosp: $diasHospitalizado  '
        'Cama: ${ingreso.cama}  '
        'EPS: ${ingreso.epsOArl}  '
        'Carpeta: ${ingreso.carpeta}';
  }

  // ─────────────────────────────────────────────────────────────
  // PÁGINA 1 — INFORMACIÓN GENERAL DEL PACIENTE
  // ─────────────────────────────────────────────────────────────
  pw.Widget _buildPagina1(
    pw.Context context,
    Ingreso ingreso,
    String headerInfo,
    ControlDeRiesgos? cr,
    List<RegistroNutricional> nutricion,
    List<ProcedimientoEspecial> procedimientos,
    List<TratamientoAntibiotico> antibioticos,
    List<ListaTratamientos> tratamientos,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // ── ENCABEZADO ──
        _sectionTitle('SÁBANA DIGITAL DE ENFERMERÍA - UCI'),
        pw.SizedBox(height: 4),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Row(
            children: [
              _infoContent('Paciente', ingreso.nombrePaciente.toUpperCase()),
              _infoContent('Identificación', ingreso.identificacionPaciente),
              _infoContent('Edad', '${ingreso.fechaNacimientoPaciente != null ? DateTime.now().difference(ingreso.fechaNacimientoPaciente!).inDays ~/ 365 : '--'} años'),
            ],
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Row(
            children: [
              _infoContent('Cama', ingreso.cama),
              _infoContent('Carpeta', ingreso.carpeta),
              _infoContent('EPS/ARL', ingreso.epsOArl),
              _infoContent('Fecha Ingreso', dateFormat.format(ingreso.fechaIngreso)),
              _infoContent('Días Hosp', '${DateTime.now().difference(ingreso.fechaIngreso).inDays}'),
            ],
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Row(
            children: [
              _infoContent('Familiar', ingreso.nombreFamiliar),
              _infoContent('Parentesco', ingreso.parentescoFamiliar),
              _infoContent('Teléfono', ingreso.telefonoFamiliar),
              _infoContent('Alergias', ingreso.alergias ?? 'Ninguna'),
            ],
          ),
        ),
        pw.SizedBox(height: 2),

        // ── DIAGNÓSTICOS ──
        _sectionTitle('DIAGNÓSTICOS'),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(
            children: [
              _infoContent('Diagnóstico Ingreso', ingreso.diagnosticoIngreso),
              pw.SizedBox(height: 4),
              _infoContent('Diagnóstico Actual', ingreso.diagnosticoActual),
            ],
          ),
        ),
        pw.SizedBox(height: 4),

        // ── ANTROPOMETRÍA ──
        _sectionTitle('ANTROPOMETRÍA'),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Row(
            children: [
              _infoContent('Peso', '${ingreso.peso} kg'),
              _infoContent('Talla', '${ingreso.talla} cm'),
              _infoContent('IMC', '${(ingreso.peso / ((ingreso.talla / 100) * (ingreso.talla / 100))).toStringAsFixed(1)}'),
              _infoContent('Sala', ingreso.sala.salaToString()),
            ],
          ),
        ),
        pw.SizedBox(height: 4),

        // ── CONTROL DE RIESGOS ──
        _sectionTitle('CONTROL DE RIESGOS'),
        if (cr != null)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Column(
              children: [
                pw.Row(children: [
                  _infoContent('Riesgo UPP', cr.riesgoUPP),
                  _infoContent('Braden M/T/N', '${cr.controlUPPManana ?? "--"}/${cr.controlUPPTarde ?? "--"}/${cr.controlUPPNoche ?? "--"}'),
                  _infoContent('Riesgo Caída', cr.riesgoCaida),
                  _infoContent('Downton M/T/N', '${cr.controlCaidaManana ?? "--"}/${cr.controlCaidaTarde ?? "--"}/${cr.controlCaidaNoche ?? "--"}'),
                ]),
                pw.SizedBox(height: 2),
                pw.Row(children: [
                  _infoContent('Anticoagulación', cr.usaAnticoagulantes ? 'SÍ - ${cr.anticoagulanteSeleccionado ?? ""}' : 'NO'),
                  _infoContent('Alergia Medicamentos', cr.alergicoAMedicacion ? 'SÍ - ${cr.medicamentoAlergico ?? ""}' : 'NO'),
                  _infoContent('Aislamiento', cr.enAislamiento ? 'SÍ (${cr.tipoAislamiento ?? ""})' : 'NO'),
                  _infoContent('Días Aisl.', '${cr.diasDeAislamiento ?? 0}'),
                ]),
                if (cr.tieneUPP)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: _infoContent('UPP - Sitio', '${cr.sitioUPP ?? ""} - Reporte EA: ${cr.numeroReporteEA ?? ""}'),
                  ),
              ],
            ),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _infoContent('Sin registro', 'No hay control de riesgos registrado'),
          ),
        pw.SizedBox(height: 4),

        // ── NUTRICIÓN ──
        _sectionTitle('NUTRICIÓN'),
        if (nutricion.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Column(
              children: nutricion.take(3).map((n) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2),
                child: pw.Row(children: [
                  _infoContent('Hora', '${n.hora.hour.toString().padLeft(2, '0')}:${n.hora.minute.toString().padLeft(2, '0')}'),
                  _infoContent('Vía', n.via),
                  _infoContent('Total', '${n.total?.toStringAsFixed(0) ?? "--"} kcal'),
                  _infoContent('Prot/Lip/CHO', '${n.proteinas?.toStringAsFixed(0) ?? "--"}/${n.lipidos?.toStringAsFixed(0) ?? "--"}/${n.carbohidratos?.toStringAsFixed(0) ?? "--"}%'),
                ]),
              )).toList(),
            ),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _infoContent('Sin registro', 'No hay registros nutricionales'),
          ),
        pw.SizedBox(height: 4),

        // ── ANTIBIÓTICOS ──
        _sectionTitle('ANTIBIÓTICOS / DÍAS DE TRATAMIENTO'),
        if (antibioticos.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _buildAntibioticosTable(antibioticos),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _infoContent('Sin registro', 'No hay antibióticos registrados'),
          ),
        pw.SizedBox(height: 4),

        // ── LISTA DE TRATAMIENTOS ──
        _sectionTitle('LISTA DE TRATAMIENTOS'),
        if (tratamientos.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Column(
              children: tratamientos.map((t) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2),
                child: pw.Row(children: [
                  _infoContent('Medicamento', t.medicamento),
                  _infoContent('Dosis', '${t.cantidad} ${t.unidad}'),
                  _infoContent('Frec', 'C/${t.frecuencia}h'),
                  _infoContent('Inicio', dateFormat.format(t.fechaInicio)),
                  _infoContent('Obs', t.observaciones ?? ''),
                ]),
              )).toList(),
            ),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _infoContent('Sin registro', 'No hay tratamientos registrados'),
          ),
        pw.SizedBox(height: 4),

        // ── PROCEDIMIENTOS ESPECIALES ──
        _sectionTitle('PROCEDIMIENTOS ESPECIALES'),
        if (procedimientos.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontSize: 7, font: _boldFont),
              cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
              headers: ['Procedimiento', 'Medicamento en infusión', 'Dosis / Velocidad', 'Estado'],
              data: procedimientos.map((p) => [
                p.nombreProcedimiento,
                p.medicamentoInfusion ?? '-',
                p.dosisInfusion ?? '-',
                p.estado,
              ]).toList(),
              border: pw.TableBorder.all(),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PÁGINA 2 — MONITORÍA HEMODINÁMICA
  // ─────────────────────────────────────────────────────────────
  pw.Widget _buildPagina2(
    pw.Context context,
    Ingreso ingreso,
    List<MonitoriaHemodinamica> monitorias,
    List<Marcapaso> marcapasos,
    List<Cateter> cateteres,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('MONITORÍA HEMODINÁMICA'),
        pw.SizedBox(height: 2),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Row(children: [
            _infoContent('Peso', '${ingreso.peso} kg'),
            _infoContent('Talla', '${ingreso.talla} cm'),
            _infoContent('SC', '${(0.007184 * (ingreso.peso).toDouble().clamp(0, 200)).toStringAsFixed(2)} m²'),
            _infoContent('Fecha', dateFormat.format(DateTime.now())),
          ]),
        ),
        pw.SizedBox(height: 4),

        // ── TABLA DE MONITORÍA ──
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 6, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 6, font: _regularFont),
            headers: ['Hora', ..._hours.map((h) => h.toString())],
            data: [
              _monitoriaRow('PAS/PAD', monitorias, (m) => '${m.pas ?? ""}/${m.pad ?? ""}'),
              _monitoriaRow('PAM', monitorias, (m) => '${m.pam ?? ""}'),
              _monitoriaRow('FC', monitorias, (m) => '${m.fc ?? ""}'),
              _monitoriaRow('FR', monitorias, (m) => '${m.fr ?? ""}'),
              _monitoriaRow('T°', monitorias, (m) => m.t != null ? '${m.t!.toStringAsFixed(1)}' : ''),
              _monitoriaRow('PVC', monitorias, (m) => '${m.pvc ?? ""}'),
              _monitoriaRow('GC/IC', monitorias, (m) => '${m.gc ?? ""}/${m.ic ?? ""}'),
              _monitoriaRow('RVS/IRVS', monitorias, (m) => '${m.rvs ?? ""}/${m.irvs ?? ""}'),
              _monitoriaRow('FiO₂', monitorias, (m) => '${m.fio2 ?? ""}'),
              _monitoriaRow('PIA/PPA', monitorias, (m) => '${m.pia ?? ""}/${m.ppa ?? ""}'),
              _monitoriaRow('PIC/PPC', monitorias, (m) => '${m.pic ?? ""}/${m.ppc ?? ""}'),
              _monitoriaRow('Glucometría', monitorias, (m) => '${m.glucometria ?? ""}'),
              _monitoriaRow('Insulina', monitorias, (m) => '${m.insulina ?? ""}'),
              _monitoriaRow('Sat O₂', monitorias, (m) => '${m.saturacion ?? ""}'),
            ],
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            columnWidths: {
              0: const pw.FixedColumnWidth(40),
              for (int i = 1; i <= _hours.length; i++) i: const pw.FixedColumnWidth(25),
            },
          ),
        ),
        pw.SizedBox(height: 8),

        // ── MARCAPASOS ──
        _sectionTitle('MARCAPASOS'),
        if (marcapasos.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontSize: 7, font: _boldFont),
              cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
              headers: ['Modo', 'Vía', 'Frecuencia', 'Sensibilidad/Salida', 'Fecha Colocación'],
              data: marcapasos.map((m) => [m.modo, m.via, '${m.frecuencia} BPM', '${m.sensibilidad} mV / ${m.salida} V', m.fechaColocacion]).toList(),
              border: pw.TableBorder.all(),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            ),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _infoContent('Sin registro', 'No hay marcapasos registrados'),
          ),
        pw.SizedBox(height: 6),

        // ── CATÉTERES ──
        _sectionTitle('CATÉTER VENOSO Y/O ARTERIAL'),
        if (cateteres.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontSize: 7, font: _boldFont),
              cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
              headers: ['Tipo de catéter', 'Vía', 'Fecha inserción', 'Fecha curación/cambio', 'Características sitio'],
              data: cateteres.map((c) => [
                c.tipo,
                c.via,
                dateFormat.format(c.fechaInsercion),
                c.fechaCuracionOCambio != null ? dateFormat.format(c.fechaCuracionOCambio!) : '---',
                c.caracteristicasSitioInsercion.isNotEmpty ? c.caracteristicasSitioInsercion : '---',
              ]).toList(),
              border: pw.TableBorder.all(),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            ),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _infoContent('Sin registro', 'No hay catéteres registrados'),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PÁGINA 3 — BALANCE DE LÍQUIDOS PARTE 1 (ADMINISTRADOS)
  // ─────────────────────────────────────────────────────────────
  pw.Widget _buildPagina3(
    pw.Context context,
    Ingreso ingreso,
    List<LiquidoAdministrado> administrados,
    List<Sonda> sondas,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('BALANCE DE LÍQUIDOS - ADMINISTRADOS'),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Row(children: [
            _infoContent('Fecha', dateFormat.format(DateTime.now())),
            _infoContent('Paciente', ingreso.nombrePaciente),
            _infoContent('Cama', ingreso.cama),
          ]),
        ),
        pw.SizedBox(height: 4),

        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 6, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 6, font: _regularFont),
            headers: ['Hora', 'Nutrición Enteral', 'Nutrición Parenteral', 'Vía Oral', 'Total'],
            data: _hours.map((h) {
              final items = administrados.where((a) => a.hora.hour == h).toList();
              final enteral = items.where((a) => a.medicamento.toLowerCase().contains('enteral') || a.medicamento.toLowerCase().contains('nutrición')).fold<int>(0, (s, a) => s + a.cantidad);
              final parenteral = items.where((a) => a.medicamento.toLowerCase().contains('parenteral')).fold<int>(0, (s, a) => s + a.cantidad);
              final oral = items.where((a) => a.medicamento.toLowerCase().contains('oral') || a.esTratamiento == false).fold<int>(0, (s, a) => s + a.cantidad);
              final total = items.fold<int>(0, (s, a) => s + a.cantidad);
              return [
                '$h:00',
                enteral > 0 ? '$enteral ml' : '',
                parenteral > 0 ? '$parenteral ml' : '',
                oral > 0 ? '$oral ml' : '',
                total > 0 ? '$total ml' : '',
              ];
            }).toList(),
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          ),
        ),
        pw.SizedBox(height: 8),

        // ── SONDAS Y DRENES ──
        _sectionTitle('SONDAS Y DRENES'),
        if (sondas.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontSize: 7, font: _boldFont),
              cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
              headers: ['Tipo', 'Región Anatómica', 'Colocación', 'Retiro', 'Días'],
              data: sondas.map((s) {
                final dias = s.fechaRetiro != null
                    ? s.fechaRetiro!.difference(s.fechaColocacion).inDays + 1
                    : DateTime.now().difference(s.fechaColocacion).inDays + 1;
                return [
                  s.tipo,
                  s.regionAnatomica,
                  dateFormat.format(s.fechaColocacion),
                  s.fechaRetiro != null ? dateFormat.format(s.fechaRetiro!) : 'Activa',
                   '$dias',
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            ),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Text(
              'Sin registro - No hay sondas ni drenes registrados',
              style: pw.TextStyle(fontSize: 7, font: _regularFont, color: PdfColors.grey600),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PÁGINA 4 — BALANCE DE LÍQUIDOS PARTE 2 (ELIMINADOS + RESUMEN)
  // ─────────────────────────────────────────────────────────────
  pw.Widget _buildPagina4(
    pw.Context context,
    Ingreso ingreso,
    List<LiquidoEliminado> eliminados,
    List<LiquidoAdministrado> administrados,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final totalAdmin = administrados.fold<double>(0, (s, a) => s + a.cantidad);
    final totalElim = eliminados.fold<double>(0, (s, e) => s + e.orina + e.perdidasInsensibles + e.sondaGastrica + e.residuoGastrico + e.tuboTorax1 + e.tuboTorax2 + e.tuboMediastino + e.drenAbdominal + e.ileostomia + e.fistulaEnterocutanea + e.deposicion + e.dialisis + e.ventriculosTomaExterna + e.otros + e.campoLibre1 + e.campoLibre2);
    final balance = totalAdmin - totalElim;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('BALANCE DE LÍQUIDOS - ELIMINADOS'),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Row(children: [
            _infoContent('Fecha', dateFormat.format(DateTime.now())),
            _infoContent('Paciente', ingreso.nombrePaciente),
            _infoContent('Cama', ingreso.cama),
          ]),
        ),
        pw.SizedBox(height: 4),

        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 5, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 5, font: _regularFont),
            headers: ['Hora', 'Diuresis', 'P.Insens', 'S.Gástric', 'Res.Gást', 'T.Tórax1', 'T.Tórax2', 'T.Mediast', 'Dr.Abdom', 'Ileostom', 'Físt.EC', 'Deposic', 'Diálisis', 'Ventric', 'Otros', 'C.Libre1', 'C.Libre2', 'Total'],
            data: _hours.map((h) {
              final items = eliminados.where((e) => e.hora.hour == h).toList();
              double s(String field) => items.fold<double>(0, (s, e) {
                    switch (field) {
                      case 'orina': return s + e.orina;
                      case 'pi': return s + e.perdidasInsensibles;
                      case 'sg': return s + e.sondaGastrica;
                      case 'rg': return s + e.residuoGastrico;
                      case 'tt1': return s + e.tuboTorax1;
                      case 'tt2': return s + e.tuboTorax2;
                      case 'tm': return s + e.tuboMediastino;
                      case 'da': return s + e.drenAbdominal;
                      case 'il': return s + e.ileostomia;
                      case 'fe': return s + e.fistulaEnterocutanea;
                      case 'dp': return s + e.deposicion;
                      case 'dl': return s + e.dialisis;
                      case 'vt': return s + e.ventriculosTomaExterna;
                      case 'ot': return s + e.otros;
                      case 'c1': return s + e.campoLibre1;
                      case 'c2': return s + e.campoLibre2;
                      default: return s;
                    }
                  });
              final orina = s('orina');
              final pi = s('pi');
              final sg = s('sg');
              final rg = s('rg');
              final tt1 = s('tt1');
              final tt2 = s('tt2');
              final tm = s('tm');
              final da = s('da');
              final il = s('il');
              final fe = s('fe');
              final dp = s('dp');
              final dl = s('dl');
              final vt = s('vt');
              final ot = s('ot');
              final c1 = s('c1');
              final c2 = s('c2');
              final total = orina + pi + sg + rg + tt1 + tt2 + tm + da + il + fe + dp + dl + vt + ot + c1 + c2;
              String v(double val) => val > 0 ? val.toStringAsFixed(0) : '';
              return [
                '$h:00', v(orina), v(pi), v(sg), v(rg), v(tt1), v(tt2), v(tm), v(da), v(il), v(fe), v(dp), v(dl), v(vt), v(ot), v(c1), v(c2), v(total),
              ];
            }).toList(),
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          ),
        ),
        pw.SizedBox(height: 8),

        // ── RESUMEN ──
        _sectionTitle('RESUMEN DE BALANCE'),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(
            children: [
              pw.Row(children: [
                _infoContent('Total Administrado', '${totalAdmin.toStringAsFixed(0)} ml'),
                _infoContent('Total Eliminado', '${totalElim.toStringAsFixed(0)} ml'),
                _infoContent('Balance del día', '${balance.toStringAsFixed(0)} ml'),
              ]),
              pw.SizedBox(height: 4),
              pw.Row(children: [
                _infoContent('Gasto Urinario', eliminados.isNotEmpty
                    ? '${(eliminados.fold<double>(0, (s, e) => s + e.orina) / (ingreso.peso.clamp(1, 200) * 24)).toStringAsFixed(2)} cc/kg/h'
                    : '0 cc/kg/h'),
                _infoContent('Balance Acumulado', '---'),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PÁGINA 5 — CONTROL NEUROLÓGICO (GLASGOW + POSICIÓN + RASS)
  // ─────────────────────────────────────────────────────────────
  pw.Widget _buildPagina5(
    pw.Context context,
    Ingreso ingreso,
    List<Glasgow> glasgowRegistros,
    List<CambioDePosicion> cambiosPosicion,
    List<ControlSedacion> sedaciones,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('CONTROL NEUROLÓGICO - GLASGOW'),
        pw.SizedBox(height: 2),

        // ── TABLA GLASGOW ──
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 6, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 6, font: _regularFont),
            headers: ['Parámetro', ..._hours.map((h) => '$h')],
            data: [
              _glasgowRow('Apertura Ocular', glasgowRegistros, (g) => '${g.aperturaOcular}'),
              _glasgowRow('Respuesta Verbal', glasgowRegistros, (g) => '${g.respuestaVerbal}'),
              _glasgowRow('Respuesta Motora', glasgowRegistros, (g) => '${g.respuestaMotora}'),
              _glasgowRow('TOTAL', glasgowRegistros, (g) => '${g.puntajeTotal}', bold: true),
            ],
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            columnWidths: {
              0: const pw.FixedColumnWidth(80),
              for (int i = 1; i <= _hours.length; i++) i: const pw.FixedColumnWidth(25),
            },
          ),
        ),
        pw.SizedBox(height: 8),

        // ── ESCALA RASS ──
        _sectionTitle('ESCALA DE SEDACIÓN RICHMOND (RASS)'),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 6, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 6, font: _regularFont),
            headers: ['Puntuación', 'Descripción', ..._hours.map((h) => '$h')],
            data: [
              ..._rassRows(sedaciones),
            ],
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            columnWidths: {
              0: const pw.FixedColumnWidth(25),
              1: const pw.FixedColumnWidth(80),
              for (int i = 2; i <= _hours.length + 1; i++) i: const pw.FixedColumnWidth(22),
            },
          ),
        ),
        pw.SizedBox(height: 8),

        // ── CAMBIO DE POSICIÓN ──
        _sectionTitle('CONTROL DE CAMBIO DE POSICIÓN'),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 6, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 6, font: _regularFont),
            headers: ['Posición', ..._hours.map((h) => '$h')],
            data: [
              _posicionRow('Decúbito Dorsal', cambiosPosicion, 'Decúbito dorsal'),
              _posicionRow('Dec. Lat. Izquierdo', cambiosPosicion, 'Decúbito lateral izquierdo'),
              _posicionRow('Dec. Lat. Derecho', cambiosPosicion, 'Decúbito lateral derecho'),
              _posicionRow('Prono', cambiosPosicion, 'Prono'),
            ],
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            columnWidths: {
              0: const pw.FixedColumnWidth(90),
              for (int i = 1; i <= _hours.length; i++) i: const pw.FixedColumnWidth(25),
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // OBSERVACIONES EXTRAS — LABORATORIOS, OBSERVACIONES, FIRMAS
  // ─────────────────────────────────────────────────────────────
  pw.Widget _buildObservacionesExtras(
    pw.Context context,
    Ingreso ingreso,
    List<RegistroDiario> registrosDiarios,
    List<ControlSedacion> sedaciones,
    List<Firma> firmas,
    ReporteNecesidades? necesidades,
    ObservacionesExtrasData? observacionesExtras,
  ) {
    final p6 = observacionesExtras ?? ObservacionesExtrasData();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final observaciones = registrosDiarios
        .map((r) => r.observaciones)
        .where((o) => o.isNotEmpty)
        .join('\n');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('SOLICITUD DE LABORATORIO Y RADIOLOGÍA'),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 7, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
            headers: ['Fecha', 'Solicitud de Laboratorio y Exámenes de Radiología', 'Resultados y Observaciones'],
            data: p6.solicitudes.map((s) => [
              s.fecha != null ? dateFormat.format(s.fecha!) : '',
              s.solicitud,
              s.resultados,
            ]).toList(),
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            columnWidths: {
              0: const pw.FixedColumnWidth(60),
              1: const pw.FixedColumnWidth(200),
              2: const pw.FixedColumnWidth(120),
            },
          ),
        ),
        pw.SizedBox(height: 8),

        _sectionTitle('GRAM Y/O CULTIVOS - BK'),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 7, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
            headers: ['Fecha', 'Gram y/o Cultivos - BK', 'Resultados'],
            data: p6.grams.map((g) => [
              g.fecha != null ? dateFormat.format(g.fecha!) : '',
              g.cultivo,
              g.resultados,
            ]).toList(),
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            columnWidths: {
              0: const pw.FixedColumnWidth(60),
              1: const pw.FixedColumnWidth(200),
              2: const pw.FixedColumnWidth(120),
            },
          ),
        ),
        pw.SizedBox(height: 8),

        _sectionTitle('ORDEN MÉDICA DE COMPONENTE SANGUÍNEO PARA TRANSFUNDIR / CANTIDAD'),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 7, font: _boldFont),
            cellStyle: pw.TextStyle(fontSize: 7, font: _regularFont),
            headers: ['Fecha', 'Hora', 'Glóbulos Rojos', 'Plaquetas', 'Plasma'],
            data: p6.ordenes.map((o) => [
              o.fecha != null ? dateFormat.format(o.fecha!) : '',
              o.hora,
              o.globulosRojos,
              o.plaquetas,
              o.plasma,
            ]).toList(),
            border: pw.TableBorder.all(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            columnWidths: {
              0: const pw.FixedColumnWidth(50),
              1: const pw.FixedColumnWidth(40),
              2: const pw.FixedColumnWidth(80),
              3: const pw.FixedColumnWidth(80),
              4: const pw.FixedColumnWidth(80),
            },
          ),
        ),
        pw.SizedBox(height: 8),

        _sectionTitle('NECESIDADES / OBJETIVOS / INTERVENCIONES / REVISTA'),
        if (necesidades != null)
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoContent('Necesidades detectadas', necesidades.necesidadesDetectadas.isNotEmpty ? necesidades.necesidadesDetectadas : '---'),
                pw.SizedBox(height: 2),
                _infoContent('Objetivos de enfermería', necesidades.objetivosEnfermeria.isNotEmpty ? necesidades.objetivosEnfermeria : '---'),
                pw.SizedBox(height: 2),
                _infoContent('Intervenciones realizadas', necesidades.intervencionesRealizadas.isNotEmpty ? necesidades.intervencionesRealizadas : '---'),
                pw.SizedBox(height: 2),
                _infoContent('Revista médica', necesidades.revistaMedica.isNotEmpty ? necesidades.revistaMedica : '---'),
              ],
            ),
          )
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: _infoContent('Sin registro', 'No hay necesidades registradas'),
          ),
        pw.SizedBox(height: 8),

        _sectionTitle('OBSERVACIONES'),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(
              (() {
                final txt = [if (observaciones.isNotEmpty) observaciones, if (p6.observaciones.isNotEmpty) p6.observaciones].join('\n').trim();
                return txt.isNotEmpty ? txt : 'Sin observaciones registradas';
              })(),
              style: pw.TextStyle(fontSize: 7, font: _regularFont),
            ),
          ),
        ),
        pw.SizedBox(height: 8),

        _sectionTitle('FIRMAS'),
        pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FixedColumnWidth(100),
              2: const pw.FixedColumnWidth(100),
              3: const pw.FixedColumnWidth(100),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: ['Personal de Enfermería', 'Mañana', 'Tarde', 'Noche']
                    .map((h) => _firmaHeaderCell(h))
                    .toList(),
              ),
              for (final tipo in ['ENFERMERA JEFE', 'ENFERMERA'])
                pw.TableRow(
                  children: [
                    _firmaHeaderCell(tipo),
                    for (final turno in ['Mañana', 'Tarde', 'Noche'])
                      _buildFirmaImageCell(p6.firmas, tipo, turno),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ── HELPER METHODS ──

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(4),
      color: PdfColors.grey800,
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 8,
          font: _boldFont,
          color: PdfColors.white,
        ),
      ),
    );
  }

  pw.Widget _infoContent(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 6,
              font: _boldFont,
              color: PdfColors.grey700,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 7, font: _regularFont),
          ),
        ],
      ),
    );
  }


  List<String> _monitoriaRow(String label, List<MonitoriaHemodinamica> data, String Function(MonitoriaHemodinamica) extractor) {
    return [
      label,
      ..._hours.map((h) {
        final record = data.where((m) => m.hora == h).toList();
        return record.isNotEmpty ? extractor(record.first) : '';
      }),
    ];
  }

  List<String> _glasgowRow(String label, List<Glasgow> data, String Function(Glasgow) extractor, {bool bold = false}) {
    return [
      label,
      ..._hours.map((h) {
        final records = data.where((g) => g.horaRegistro != null && g.horaRegistro!.hour == h).toList();
        return records.isNotEmpty ? extractor(records.first) : '';
      }),
    ];
  }

  List<List<String>> _rassRows(List<ControlSedacion> sedaciones) {
    const rassValues = [
      (4, 'Combativo'),
      (3, 'Muy agitado'),
      (2, 'Agitado'),
      (1, 'Inquieto'),
      (0, 'Alerta y calmado'),
      (-1, 'Somnoliento'),
      (-2, 'Sedación leve'),
      (-3, 'Sedación moderada'),
      (-4, 'Sedación profunda'),
      (-5, 'Sin respuesta'),
    ];
    return rassValues.map((rv) {
      final (val, desc) = rv;
      return [
        '$val',
        desc,
        ..._hours.map((h) {
          final matched = sedaciones.where((s) => s.hora == h && s.rass == val).toList();
          return matched.isNotEmpty ? 'X' : '';
        }),
      ];
    }).toList();
  }

  List<String> _posicionRow(String label, List<CambioDePosicion> data, String posicion) {
    return [
      label,
      ..._hours.map((h) {
        final matched = data.where((c) => c.hora == h && c.posicion.toLowerCase() == posicion.toLowerCase()).toList();
        return matched.isNotEmpty ? 'X' : '';
      }),
    ];
  }

  pw.Widget _firmaHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(3),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 7, font: _boldFont),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildFirmaImageCell(List<FirmaPersonal> firmas, String tipoPersonal, String turno) {
    final match = firmas.where((f) =>
        f.tipoPersonal == tipoPersonal && f.turno == turno).toList();
    if (match.isEmpty) return pw.Container(height: 30);
    final f = match.first;
    if (f.firmaBase64.isEmpty) return pw.Container(height: 30);
    try {
      final bytes = base64Decode(f.firmaBase64);
      return pw.Container(
        height: 30,
        padding: const pw.EdgeInsets.all(2),
        child: pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.contain),
      );
    } catch (_) {
      return pw.Container(height: 30, child: pw.Text('Inválida', style: pw.TextStyle(fontSize: 6, font: _regularFont)));
    }
  }

  pw.Widget _buildAntibioticosTable(List<TratamientoAntibiotico> antibioticos) {
    if (antibioticos.isEmpty) {
      return _infoContent('Sin registro', 'No hay antibióticos registrados');
    }

    final earliest = antibioticos.map((a) => a.fechaInicio).reduce(
        (a, b) => a.isBefore(b) ? a : b);
    final latest = antibioticos
        .map((a) => a.fechaFin ?? DateTime.now())
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final totalDays = latest.difference(earliest).inDays + 1;

    final headers = [
      'Antibiótico',
      'Dosis',
      'Frec',
      ...List.generate(totalDays, (i) => 'D${i + 1}'),
    ];

    final columnWidths = <int, pw.TableColumnWidth>{
      0: const pw.FixedColumnWidth(60),
      1: const pw.FixedColumnWidth(40),
      2: const pw.FixedColumnWidth(25),
    };
    for (int i = 0; i < totalDays; i++) {
      columnWidths[i + 3] = const pw.FixedColumnWidth(14);
    }

    final data = antibioticos.map((a) {
      final startDay = a.fechaInicio.difference(earliest).inDays;
      final endDay = (a.fechaFin ?? DateTime.now()).difference(earliest).inDays;
      return [
        a.antibiotico,
        '${a.dosis} x${a.cantidad}',
        'C/${a.frecuenciaEn24h}h',
        ...List.generate(totalDays, (i) {
          if (i >= startDay && i <= endDay) return '✓';
          return '';
        }),
      ];
    }).toList();

    final cellStyle = pw.TextStyle(fontSize: 6, font: _regularFont);
    final headerStyle = pw.TextStyle(
        fontSize: 6,
        font: _boldFont);

    return pw.TableHelper.fromTextArray(
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      columnWidths: columnWidths,
    );
  }
}
