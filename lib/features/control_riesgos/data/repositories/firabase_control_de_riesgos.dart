import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/features/control_riesgos/domain/models/control_de_riesgos.dart';
import 'package:registro_uci/features/control_riesgos/data/abstract_repositories/control_de_riesgos_repository.dart';

// implementacion firebase del repositorio de control de riesgos
class FirebaseControlDeRiesgosRepository implements ControlDeRiesgosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
    ControlDeRiesgos controlDeRiesgos,
  ) async {
    final controlDeRiesgosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('controlDeRiesgos');

    // convierte a mapa y guarda en firestore
    final controlDeRiesgosMap = controlDeRiesgos.toJson();
    await controlDeRiesgosRef.add(controlDeRiesgosMap);
  }

  @override
  Stream<List<ControlDeRiesgos>> getControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
  ) {
    final controlDeRiesgosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('controlDeRiesgos');

    // stream en tiempo real de los controles de riesgos
    return controlDeRiesgosRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ControlDeRiesgos.fromJson(doc.data(), id: doc.id);
      }).toList();
    });
  }

  @override
  Future<void> updateControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
    String idControlDeRiesgos,
    ControlDeRiesgos controlDeRiesgos,
  ) async {
    final controlDeRiesgosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('controlDeRiesgos')
        .doc(idControlDeRiesgos);

    await controlDeRiesgosRef.update(controlDeRiesgos.toJson());
  }

  Future<ControlDeRiesgos> getControlDeRiesgosById(
    String idIngreso,
    String idRegistroDiario,
    String idControlDeRiesgos,
  ) async {
    final controlDeRiesgosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('controlDeRiesgos')
        .doc(idControlDeRiesgos);

    final doc = await controlDeRiesgosRef.get();
    if (doc.exists) {
      return ControlDeRiesgos.fromJson(doc.data()!, id: doc.id);
    } else {
      throw Exception('Control de riesgos no encontrado');
    }
  }

  @override
  Future<void> deleteControlDeRiesgos(
    String idIngreso,
    String idRegistroDiario,
    String idControlDeRiesgos,
  ) async {
    final controlDeRiesgosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('controlDeRiesgos')
        .doc(idControlDeRiesgos);

    await controlDeRiesgosRef.delete();
  }
}
