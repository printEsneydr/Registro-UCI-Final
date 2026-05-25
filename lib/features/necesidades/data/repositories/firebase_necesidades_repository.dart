import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/features/necesidades/data/dto/create_necesidad_dto.dart';
import 'package:registro_uci/features/necesidades/data/dto/update_necesidad_dto.dart';
import 'package:registro_uci/features/necesidades/domain/models/necesidad.dart';
import 'package:registro_uci/features/necesidades/data/abstract_repositories/necesidades_repository.dart';

// implementacion en firestore del repositorio de necesidades
class FirebaseNecesidadesRepository implements NecesidadesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  // obtiene todas las necesidades de un registro desde firestore
  Future<List<Necesidad>> getNecesidadesDeRegistro(
    String idIngreso,
    String idRegistro,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('registrosDiarios')
          .doc(idRegistro)
          .collection('necesidades')
          .get();

      return querySnapshot.docs
          .map((doc) => Necesidad.fromJson(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      log(e.toString());
      throw Exception('Error al obtener las necesidades del registro');
    }
  }

  @override
  // agrega una nueva necesidad al registro en firestore
  Future<void> addNecesidadToRegistro(
    String idIngreso,
    String idRegistro,
    CreateNecesidadDto dto,
  ) async {
    try {
      final necesidadesCollectionRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('registrosDiarios')
          .doc(idRegistro)
          .collection('necesidades');

      // Add a new necesidad with an auto-generated ID
      await necesidadesCollectionRef.add(dto);
    } catch (e) {
      log('Error al agregar la necesidad: $e');
      throw Exception('Error al agregar la necesidad');
    }
  }

  @override
  // actualiza los datos de una necesidad existente en firestore
  Future<void> updateNecesidadDeRegistro(
    String idIngreso,
    String idRegistro,
    String idNecesidad,
    UpdateNecesidadDto dto,
  ) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('registrosDiarios')
          .doc(idRegistro)
          .collection('necesidades')
          .doc(idNecesidad);

      // Update the necesidad with the data from dto
      await docRef.update(dto);
    } catch (e) {
      log('Error al actualizar la necesidad: $e');
      throw Exception('Error al actualizar la necesidad');
    }
  }

  @override
  // elimina una necesidad del registro en firestore
  Future<void> deleteNecesidadDeRegistro(
    String idIngreso,
    String idRegistro,
    String idNecesidad,
  ) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('registrosDiarios')
          .doc(idRegistro)
          .collection('necesidades')
          .doc(idNecesidad);

      await docRef.delete();
    } catch (e) {
      log('Error al eliminar la necesidad: $e');
      throw Exception('Error al eliminar la necesidad');
    }
  }
}
