import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/cateter.dart';
import '../../data/dto/update_cateter_dto.dart';

// ✅ Definir el proveedor del repositorio
final cateteresRepositoryProvider = Provider<CateterRepository>((ref) {
  return CateterRepository();
});

// repositorio que maneja las operaciones con cateteres en firestore
class CateterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // agrega un nuevo cateter a la coleccion del ingreso
  Future<void> agregarCateter(String idIngreso, Cateter cateter) async {
    await _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('cateteres')
        .add(cateter.toJson());
  }

  // obtiene los cateteres de un ingreso en tiempo real
  Stream<List<Cateter>> obtenerCateteres(String idIngreso) {
    return _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('cateteres')
        .snapshots() // ✅ Ahora escucha cambios en Firestore
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Cateter.fromFirestore(doc))
          .toList();
    });
  }

  // actualiza los datos de un cateter existente
  Future<void> actualizarCateter(
      String idIngreso, String idCateter, UpdateCateterDto dto) async {
    try {
      await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('cateteres')
          .doc(idCateter)
          .update(dto.toJson());
    } catch (e) {
      throw Exception("❌ Error al actualizar el catéter: $e");
    }
  }

  // elimina un cateter de la coleccion del ingreso
  Future<void> eliminarCateter(String idIngreso, String idCateter) async {
    await _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('cateteres')
        .doc(idCateter)
        .delete();
  }
}

// ✅ Ahora el provider de catéteres usa Streams para tiempo real
final cateteresByIngresoProvider =
    StreamProvider.family<List<Cateter>, String>((ref, idIngreso) {
  final repository = ref.watch(cateteresRepositoryProvider);
  return repository.obtenerCateteres(idIngreso);
});

// actualiza un cateter y refresca la interfaz
final actualizarCateterProvider = FutureProvider.family<
    void,
    ({
      String idIngreso,
      String idCateter,
      UpdateCateterDto dto
    })>((ref, params) async {
  final repository = ref.read(cateteresRepositoryProvider);
  await repository.actualizarCateter(
      params.idIngreso, params.idCateter, params.dto);

  ref.invalidate(
      cateteresByIngresoProvider); // 🔥 Forzar actualización en tiempo real
});
