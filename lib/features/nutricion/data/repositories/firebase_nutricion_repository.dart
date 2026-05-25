import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/features/nutricion/data/abstract_repositories/nutricion_repository.dart';
import 'package:registro_uci/features/nutricion/data/dto/create_registro_nutricional_dto.dart';
import 'package:registro_uci/features/nutricion/domain/models/registro_nutricional.dart';

// implementacion en firestore del repositorio de registros nutricionales
class FirebaseNutricionRepository implements NutricionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  // crea un nuevo registro nutricional en firestore con id autogenerado
  Future<void> createRegistroNutricional(
    String idIngreso,
    CreateRegistroNutricionalDto dto,
  ) async {
    final nutricionRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('nutricion');

    final newDocRef = nutricionRef.doc();
    await newDocRef.set(dto.toMap());
  }

  @override
  // actualiza un registro nutricional existente en firestore
  Future<void> updateRegistroNutricional(
    String idIngreso,
    String idRegistroNutricional,
    CreateRegistroNutricionalDto dto,
  ) async {
    final registroNutricionalRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('nutricion')
        .doc(idRegistroNutricional);

    await registroNutricionalRef.update(dto.toMap());
  }

  @override
  // elimina un registro nutricional de firestore
  Future<void> deleteRegistroNutricional(
    String idIngreso,
    String idRegistroNutricional,
  ) async {
    final registroNutricionalRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('nutricion')
        .doc(idRegistroNutricional);

    await registroNutricionalRef.delete();
  }

  @override
  // obtiene todos los registros nutricionales ordenados por hora descendente
  Future<List<RegistroNutricional>> getRegistrosNutricionales(
    String idIngreso,
  ) async {
    final querySnapshot = await _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('nutricion')
        .orderBy('hora', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => RegistroNutricional.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  @override
  // obtiene el ultimo registro nutricional registrado (mas reciente)
  Future<RegistroNutricional?> getUltimoRegistroNutricional(
    String idIngreso,
  ) async {
    final querySnapshot = await _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('nutricion')
        .orderBy('hora', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    final doc = querySnapshot.docs.first;
    return RegistroNutricional.fromJson(doc.data(), id: doc.id);
  }
}
