import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/cateter.dart';
import '../abstract_repositories/cateteres_repository.dart';
import '../dto/create_cateter_dto.dart';
import '../dto/update_cateter_dto.dart';

// repositorio que implementa las operaciones de cateteres en firebase
class FirebaseCateterRepository implements CateteresRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // obtiene todos los cateteres de todos los ingresos en tiempo real
  @override
  Stream<List<Cateter>> getAllCateteres() {
    return _firestore.collectionGroup('cateteres').snapshots().map((snapshot) {
      print(
          "📡 Actualización en tiempo real: ${snapshot.docs.length} catéteres");
      return snapshot.docs.map((doc) => Cateter.fromFirestore(doc)).toList();
    });
  }

  // crea un nuevo cateter vinculado a un ingreso
  @override
  Future<void> createCateter(CreateCateterDto dto) async {
    try {
      await _firestore
          .collection('ingresos')
          .doc(dto.idIngreso)
          .collection('cateteres')
          .add({
        "tipo": dto.tipo,
        "via": dto.via,
        "fechaInsercion": Timestamp.fromDate(dto.fechaInsercion),
        "fechaRetiro": dto.fechaRetiro != null
            ? Timestamp.fromDate(dto.fechaRetiro!)
            : null,
        "fechaCuracionOCambio": dto.fechaCuracionOCambio != null
            ? Timestamp.fromDate(dto.fechaCuracionOCambio!)
            : null,
        "caracteristicasSitioInsercion": dto.caracteristicasSitioInsercion,
      });

      log("✅ Catéter agregado correctamente");
    } catch (e) {
      log("❌ Error al agregar catéter: $e");
      throw Exception("Error al agregar catéter");
    }
  }

  // obtiene los cateteres de un ingreso especifico en tiempo real
  @override
  Stream<List<Cateter>> getCateteresByIngreso(String idIngreso) {
    return _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('cateteres')
        .orderBy('fechaInsercion', descending: true)
        .snapshots()
        .map((snapshot) {
      log("📡 Actualización en tiempo real recibida: ${snapshot.docs.length} catéteres");
      return snapshot.docs.map((doc) => Cateter.fromFirestore(doc)).toList();
    });
  }

  // obtiene un cateter especifico por su id
  @override
  Future<Cateter?> getCateterById(String idIngreso, String idCateter) async {
    try {
      final docSnapshot = await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('cateteres')
          .doc(idCateter)
          .get();

      if (docSnapshot.exists) {
        return Cateter.fromFirestore(docSnapshot);
      } else {
        log("⚠️ No se encontró el catéter con ID: $idCateter");
        return null;
      }
    } catch (e) {
      log("❌ Error al obtener el catéter: $e");
      throw Exception("Error al obtener el catéter");
    }
  }

  // actualiza los datos de un cateter existente
  @override
  Future<void> updateCateter(
      String idIngreso, String idCateter, UpdateCateterDto dto) async {
    try {
      await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('cateteres')
          .doc(idCateter)
          .update(dto.toJson());

      log("✅ Catéter $idCateter actualizado correctamente");
    } catch (e) {
      log("❌ Error al actualizar el catéter $idCateter: $e");
      throw Exception("Error al actualizar el catéter");
    }
  }

  // elimina un cateter de firebase
  @override
  Future<void> deleteCateter(String idIngreso, String idCateter) async {
    try {
      await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('cateteres')
          .doc(idCateter)
          .delete();

      log("✅ Catéter $idCateter eliminado correctamente");
    } catch (e) {
      log("❌ Error al eliminar el catéter $idCateter: $e");
      throw Exception("Error al eliminar el catéter");
    }
  }
}
