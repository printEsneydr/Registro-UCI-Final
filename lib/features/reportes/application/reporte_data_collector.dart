import 'package:cloud_firestore/cloud_firestore.dart';

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

class ReporteData {
  final Ingreso ingreso;
  final List<RegistroDiario> registrosDiarios;
  final List<MonitoriaHemodinamica> monitorias;
  final List<ControlSedacion> sedaciones;
  final List<CambioDePosicion> cambiosPosicion;
  final List<Glasgow> glasgowRegistros;
  final List<Cateter> cateteres;
  final List<Marcapaso> marcapasos;
  final List<Sonda> sondas;
  final List<ListaTratamientos> listaTratamientos;
  final ControlDeRiesgos? controlRiesgos;
  final List<ProcedimientoEspecial> procedimientos;
  final List<RegistroNutricional> nutricion;
  final List<LiquidoAdministrado> liquidosAdministrados;
  final List<LiquidoEliminado> liquidosEliminados;
  final List<TratamientoAntibiotico> antibioticos;
  final List<Firma> firmas;
  final ReporteNecesidades? necesidades;
  final ObservacionesExtrasData? observacionesExtras;

  ReporteData({
    required this.ingreso,
    required this.registrosDiarios,
    required this.monitorias,
    required this.sedaciones,
    required this.cambiosPosicion,
    required this.glasgowRegistros,
    required this.cateteres,
    required this.marcapasos,
    required this.sondas,
    required this.listaTratamientos,
    this.controlRiesgos,
    required this.procedimientos,
    required this.nutricion,
    required this.liquidosAdministrados,
    required this.liquidosEliminados,
    required this.antibioticos,
    required this.firmas,
    this.necesidades,
    this.observacionesExtras,
  });
}

class ReporteDataCollector {
  final String idIngreso;
  final _firestore = FirebaseFirestore.instance;

  ReporteDataCollector({required this.idIngreso});

  static const _maxRetries = 3;

  Future<T> _retryOnUnavailable<T>(Future<T> Function() fn) async {
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        return await fn();
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable' && attempt < _maxRetries - 1) {
          await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
          continue;
        }
        rethrow;
      }
    }
    throw FirebaseException(
      plugin: 'firestore',
      code: 'unavailable',
      message: 'Service unavailable after $_maxRetries retries',
    );
  }

  Future<ReporteData> collectAll() => _retryOnUnavailable(() => _collectAll());

  Future<ReporteData> _collectAll() async {
    final ingreso = await _fetchIngreso();
    final registrosDiarios = await _fetchRegistrosDiarios();
    final rdIds = registrosDiarios.map((r) => r.idRegistroDiario).toList();

    final results = await Future.wait([
      _fetchMonitorias(rdIds),
      _fetchSedaciones(rdIds),
      _fetchCambiosPosicion(rdIds),
      _fetchGlasgow(rdIds),
      _fetchCateteres(),
      _fetchMarcapasos(),
      _fetchSondas(),
      _fetchListaTratamientos(rdIds),
      _fetchControlRiesgos(rdIds),
      _fetchProcedimientos(),
      _fetchNutricion(),
      _fetchAntibioticos(),
    ]);

    final (admin, elim) = await _fetchLiquidos(rdIds);
    final necesidades = await _fetchNecesidades(rdIds);
    final observacionesExtras = await _fetchObservacionesExtras();

    return ReporteData(
      ingreso: ingreso,
      registrosDiarios: registrosDiarios,
      monitorias: results[0] as List<MonitoriaHemodinamica>,
      sedaciones: results[1] as List<ControlSedacion>,
      cambiosPosicion: results[2] as List<CambioDePosicion>,
      glasgowRegistros: results[3] as List<Glasgow>,
      cateteres: results[4] as List<Cateter>,
      marcapasos: results[5] as List<Marcapaso>,
      sondas: results[6] as List<Sonda>,
      listaTratamientos: results[7] as List<ListaTratamientos>,
      controlRiesgos: results[8] as ControlDeRiesgos?,
      procedimientos: results[9] as List<ProcedimientoEspecial>,
      nutricion: results[10] as List<RegistroNutricional>,
      antibioticos: results[11] as List<TratamientoAntibiotico>,
      liquidosAdministrados: admin,
      liquidosEliminados: elim,
      firmas: await _fetchFirmas(rdIds),
      necesidades: necesidades,
      observacionesExtras: observacionesExtras,
    );
  }

  Future<Ingreso> _fetchIngreso() async {
    final doc = await _firestore.collection('ingresos').doc(idIngreso).get();
    return Ingreso.fromJson(doc.data()!, id: doc.id);
  }

  Future<List<RegistroDiario>> _fetchRegistrosDiarios() async {
    final snap = await _firestore
        .collection('ingresos').doc(idIngreso)
        .collection('registrosDiarios')
        .get();
    return snap.docs.map((doc) => RegistroDiario.fromJson(doc.data(), id: doc.id)).toList();
  }

  DocumentReference<Map<String, dynamic>> _rdRef(String rdId) =>
      _firestore.collection('ingresos').doc(idIngreso).collection('registrosDiarios').doc(rdId);

  Future<List<MonitoriaHemodinamica>> _fetchMonitorias(List<String> rdIds) async {
    final results = await Future.wait(rdIds.map((id) =>
      _rdRef(id).collection('monitoriasHemodinamicas').get()
    ));
    return results.expand((s) => s.docs.map((doc) => MonitoriaHemodinamica.fromJson(doc.data(), id: doc.id))).toList();
  }

  Future<List<ControlSedacion>> _fetchSedaciones(List<String> rdIds) async {
    final results = await Future.wait(rdIds.map((id) =>
      _rdRef(id).collection('controlesSedacion').get()
    ));
    return results.expand((s) => s.docs.map((doc) => ControlSedacion.fromJson(doc.data(), id: doc.id))).toList();
  }

  Future<List<CambioDePosicion>> _fetchCambiosPosicion(List<String> rdIds) async {
    final results = await Future.wait(rdIds.map((id) =>
      _rdRef(id).collection('cambiosPosicion').get()
    ));
    return results.expand((s) => s.docs.map((doc) => CambioDePosicion.fromJson(doc.data(), id: doc.id))).toList();
  }

  Future<List<Glasgow>> _fetchGlasgow(List<String> rdIds) async {
    final results = await Future.wait(rdIds.map((id) =>
      _rdRef(id).collection('glasgow').get()
    ));
    return results.expand((s) => s.docs.map((doc) => Glasgow.fromJson(doc.data(), id: doc.id))).toList();
  }

  Future<List<Cateter>> _fetchCateteres() async {
    final snap = await _firestore
        .collection('ingresos').doc(idIngreso)
        .collection('cateteres')
        .get();
    return snap.docs.map((doc) => Cateter.fromFirestore(doc)).toList();
  }

  Future<List<Marcapaso>> _fetchMarcapasos() async {
    final snap = await _firestore
        .collection('ingresos').doc(idIngreso)
        .collection('marcapasos')
        .get();
    return snap.docs.map((doc) => Marcapaso.fromJson(doc.data())).toList();
  }

  Future<List<Sonda>> _fetchSondas() async {
    final snap = await _firestore
        .collection('ingresos').doc(idIngreso)
        .collection('sondas')
        .get();
    return snap.docs.map((doc) => Sonda.fromJson(doc.data())).toList();
  }

  Future<List<ListaTratamientos>> _fetchListaTratamientos(List<String> rdIds) async {
    final results = await Future.wait(rdIds.map((id) =>
      _rdRef(id).collection('listaTratamientos').get()
    ));
    return results.expand((s) => s.docs.map((doc) => ListaTratamientos.fromJson(doc.data(), id: doc.id))).toList();
  }

  Future<ControlDeRiesgos?> _fetchControlRiesgos(List<String> rdIds) async {
    for (final id in rdIds.reversed) {
      final snap = await _rdRef(id).collection('controlDeRiesgos').get();
      if (snap.docs.isNotEmpty) {
        return ControlDeRiesgos.fromJson(snap.docs.first.data(), id: snap.docs.first.id);
      }
    }
    return null;
  }

  Future<List<ProcedimientoEspecial>> _fetchProcedimientos() async {
    final snap = await _firestore
        .collection('ingresos').doc(idIngreso)
        .collection('procedimientosEspeciales')
        .get();
    return snap.docs.map((doc) => ProcedimientoEspecial.fromJson(doc.data(), id: doc.id)).toList();
  }

  Future<List<RegistroNutricional>> _fetchNutricion() async {
    final snap = await _firestore
        .collection('ingresos').doc(idIngreso)
        .collection('nutricion')
        .get();
    return snap.docs.map((doc) => RegistroNutricional.fromJson(doc.data(), id: doc.id)).toList();
  }

  Future<(List<LiquidoAdministrado>, List<LiquidoEliminado>)> _fetchLiquidos(List<String> rdIds) async {
    final path = _firestore.collection('ingresos').doc(idIngreso);
    List<LiquidoAdministrado> admin = [];
    List<LiquidoEliminado> elim = [];
    for (final rdId in rdIds) {
      final balancesSnap = await path.collection('registrosDiarios').doc(rdId).collection('balancesDeLiquidos').get();
      for (final balanceDoc in balancesSnap.docs) {
        final ref = balanceDoc.reference;
        final adminSnap = await ref.collection('administrados').get();
        admin.addAll(adminSnap.docs.map((d) => LiquidoAdministrado.fromJson(d.data(), id: d.id)));
        final elimSnap = await ref.collection('eliminados').get();
        elim.addAll(elimSnap.docs.map((d) => LiquidoEliminado.fromJson(d.data(), id: d.id)));
      }
    }
    return (admin, elim);
  }

  Future<List<TratamientoAntibiotico>> _fetchAntibioticos() async {
    final snap = await _firestore
        .collection('ingresos').doc(idIngreso)
        .collection('tratamientosAntibioticos')
        .get();
    return snap.docs.map((doc) => TratamientoAntibiotico.fromJson(doc.data(), id: doc.id)).toList();
  }

  Future<ReporteNecesidades?> _fetchNecesidades(List<String> rdIds) async {
    for (final rdId in rdIds.reversed) {
      final doc = await _rdRef(rdId).collection('necesidades').doc('reporte').get();
      if (doc.exists) {
        return ReporteNecesidades.fromJson(doc.data()!, id: doc.id);
      }
    }
    return null;
  }

  Future<List<Firma>> _fetchFirmas(List<String> rdIds) async {
    List<Firma> firmas = [];
    for (final rdId in rdIds) {
      final doc = await _rdRef(rdId).get();
      final map = doc.data();
      if (map != null) {
        final firmaNec = map['firmaNecesidades'];
        if (firmaNec != null) {
          firmas.add(Firma.fromJson(firmaNec as Map<String, dynamic>));
        }
        final firmaInt = map['firmaIntervenciones'];
        if (firmaInt != null) {
          firmas.add(Firma.fromJson(firmaInt as Map<String, dynamic>));
        }
      }
    }
    return firmas;
  }

  Future<ObservacionesExtrasData?> _fetchObservacionesExtras() async {
    try {
      final doc = await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('observaciones_extras')
          .doc('data')
          .get();
      if (!doc.exists) return null;
      return ObservacionesExtrasData.fromJson(doc.data()!);
    } catch (_) {
      return null;
    }
  }
}
