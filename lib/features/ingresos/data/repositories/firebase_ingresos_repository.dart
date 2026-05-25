import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/common/constants/firebase_collection_names.dart';
import 'package:registro_uci/features/ingresos/data/abstract_repositories/ingresos_repository.dart';
import 'package:registro_uci/features/ingresos/data/dto/create_ingreso_dto.dart';
import 'package:registro_uci/features/ingresos/data/dto/update_ingreso_dto.dart';
import 'package:registro_uci/features/ingresos/domain/models/ingreso.dart';
import 'package:registro_uci/features/ingresos/data/constants/strings.dart';

// implementacion en firebase del repositorio de ingresos
class FirebaseIngresosRepository implements IngresosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // obtiene todos los ingresos ordenados por fecha de ingreso descendente
  @override
  Future<List<Ingreso>> getAllIngresos() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollectionNames.ingresos)
          .orderBy(
            Strings.fechaIngreso,
            descending: true,
          )
          .get();

      return querySnapshot.docs
          .map((doc) => Ingreso.fromJson(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      log(e.toString());
      throw Exception('Error al obtener los ingresos');
    }
  }

  // agrega un nuevo documento de ingreso a la coleccion
  @override
  Future<void> createIngreso(CreateIngresoDto dto) async {
    try {
      await _firestore.collection(FirebaseCollectionNames.ingresos).add(dto);
    } catch (e) {
      throw Exception('Error al crear el ingreso: $e');
    }
  }

  // actualiza los campos de un ingreso existente por su id
  @override
  Future<void> updateIngreso(String idIngreso, UpdateIngresoDto dto) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollectionNames.ingresos)
          .doc(idIngreso);

      await docRef.update(dto);
    } catch (e) {
      log('Error updating ingreso: $e');
      throw Exception('Error al actualizar el ingreso');
    }
  }

  // obtiene un ingreso por su id, retorna null si no existe
  @override
  Future<Ingreso?> getIngresoById(String idIngreso) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollectionNames.ingresos)
          .doc(idIngreso);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        return Ingreso.fromJson(docSnapshot.data()!, id: docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      log('Error retrieving ingreso: $e');
      throw Exception('Error al consultar el ingreso');
    }
  }

  // obtiene los ingresos filtrados por el campo sala
  @override
  Future<List<Ingreso>> getIngresosBySala(Sala sala) async {
    // Query Firestore for documents where the 'sala' field matches the provided Sala
    final querySnapshot = await _firestore
        .collection(FirebaseCollectionNames.ingresos) // Your collection name
        .where('sala', isEqualTo: sala.name) // Use the enum name as a string
        .get();

    // Map the Firestore documents to your Ingreso model
    return querySnapshot.docs
        .map((doc) => Ingreso.fromJson(doc.data(),
            id: doc.id)) // Assuming you have a fromJson method
        .toList();
  }

  // marca un ingreso como finalizado asignandole la fecha de egreso
  @override
  Future<void> terminarIngreso(String idIngreso, DateTime fechaFin) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollectionNames.ingresos)
          .doc(idIngreso);

      await docRef.update({
        Strings.fechaFin: fechaFin,
      });
    } catch (e) {
      log('Error terminating ingreso: $e');
      throw Exception('Error al terminar el ingreso');
    }
  }
}
