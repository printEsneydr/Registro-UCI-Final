import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/domain/models/glasgow.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/glasgow/data/abstract_repositories/glasgow_repository.dart';

// implementacion en firestore del repositorio de glasgow
class FirebaseGlasgowRepository implements GlasgowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  // agrega un nuevo registro de glasgow a firestore
  Future<void> addGlasgow(
    String idIngreso,
    String idRegistroDiario,
    Glasgow glasgow,
  ) async {
    final ref = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('glasgow');

    await ref.add(glasgow.toJson());
  }

  @override
  // retorna un stream en tiempo real de los registros de glasgow
  Stream<List<Glasgow>> getGlasgow(
    String idIngreso,
    String idRegistroDiario,
  ) {
    final ref = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('glasgow');

    return ref.orderBy('horaRegistro', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Glasgow.fromJson(doc.data(), id: doc.id);
      }).toList();
    });
  }

  @override
  // actualiza un registro de glasgow existente en firestore
  Future<void> updateGlasgow(
    String idIngreso,
    String idRegistroDiario,
    String idGlasgow,
    Glasgow glasgow,
  ) async {
    final ref = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('glasgow')
        .doc(idGlasgow);

    await ref.update(glasgow.toJson());
  }

  @override
  // elimina un registro de glasgow de firestore
  Future<void> deleteGlasgow(
    String idIngreso,
    String idRegistroDiario,
    String idGlasgow,
  ) async {
    final ref = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('glasgow')
        .doc(idGlasgow);

    await ref.delete();
  }

  @override
  // obtiene un registro de glasgow por su id
  Future<Glasgow?> getGlasgowById(
    String idIngreso,
    String idRegistroDiario,
    String idGlasgow,
  ) async {
    final ref = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('glasgow')
        .doc(idGlasgow);

    final doc = await ref.get();
    if (doc.exists) {
      return Glasgow.fromJson(doc.data()!, id: doc.id);
    }
    return null;
  }
}
