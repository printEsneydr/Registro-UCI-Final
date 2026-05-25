// implementacion concreta del repositorio de procedimientos usando firestore
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dto/create_procedimiento_dto.dart';
import '../dto/update_procedimiento_dto.dart';
import '../../domain/models/procedimientos_especiales.dart';
import '../abstract_repositories/procedimientos_repository.dart';

class FirebaseProcedimientosRepository implements ProcedimientosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // retorna un stream de procedimientos que se actualiza en tiempo real
  @override
  Stream<List<ProcedimientoEspecial>> getProcedimientosDeRegistro(
      String idIngreso) {
    return _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('procedimientosEspeciales')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ProcedimientoEspecial.fromJson(data,
            id: doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addProcedimientoToRegistro(
      String idIngreso, CreateProcedimientoDto dto) async {
    try {
      await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('procedimientosEspeciales')
          .add(dto.toJson());
    } catch (e) {
      log('Error al agregar el procedimiento: $e');
      throw Exception('Error al agregar el procedimiento');
    }
  }

  @override
  Future<void> updateProcedimientoDeRegistro(String idIngreso,
      String idProcedimiento, UpdateProcedimientoDto dto) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('procedimientosEspeciales')
          .doc(idProcedimiento);

      await docRef.update(dto.toJson());
    } catch (e) {
      log('Error al actualizar el procedimiento: $e');
      throw Exception('Error al actualizar el procedimiento');
    }
  }

  // elimina un procedimiento de la coleccion
  @override
  Future<void> deleteProcedimientoDeRegistro(
      String idIngreso, String idProcedimiento) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('procedimientosEspeciales')
          .doc(idProcedimiento);

      await docRef.delete();
    } catch (e) {
      log('Error al eliminar el procedimiento: $e');
      throw Exception('Error al eliminar el procedimiento');
    }
  }

  // edita el nombre de un procedimiento en firestore
  @override
  Future<void> editProcedimientoNombre(
    String idIngreso,
    String idProcedimiento,
    String nuevoNombre,
  ) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('procedimientosEspeciales')
          .doc(idProcedimiento);

      await docRef.update({
        'nombreProcedimiento': nuevoNombre,
      });
    } catch (e) {
      log('Error al editar el nombre del procedimiento: $e');
      throw Exception('Error al editar el nombre del procedimiento');
    }
  }

  // actualiza campos arbitrarios de un procedimiento
  Future<void> updateProcedimientoFields(
    String idIngreso,
    String idProcedimiento,
    Map<String, dynamic> fields,
  ) async {
    try {
      await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('procedimientosEspeciales')
          .doc(idProcedimiento)
          .update(fields);
    } catch (e) {
      log('Error al actualizar campos del procedimiento: $e');
      throw Exception('Error al actualizar campos del procedimiento');
    }
  }

  // actualiza solo el campo estado de un procedimiento
  @override
  Future<void> updateProcedimientoEstado(
    String idIngreso,
    String idProcedimiento,
    String nuevoEstado,
  ) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('procedimientosEspeciales')
          .doc(idProcedimiento);

      await docRef.update({
        'estado': nuevoEstado,
      });
    } catch (e) {
      log('Error al actualizar el estado del procedimiento: $e');
      throw Exception('Error al actualizar el estado del procedimiento');
    }
  }
}
