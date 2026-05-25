// repositorio de firestore para observaciones extras, solicitudes y firmas
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/constants/strings.dart';
import '../../domain/models/observaciones_extras_data.dart';

class ObservacionesExtrasRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // referencia al documento de observaciones_extras dentro del ingreso
  DocumentReference _ref(String idIngreso) =>
      _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection(Strings.collection)
          .doc(Strings.documentId);

  // guarda los datos combinando con lo existente en firestore
  Future<void> save(String idIngreso, ObservacionesExtrasData data) async {
    await _ref(idIngreso).set(data.toJson(), SetOptions(merge: true));
  }

  // obtiene los datos de firestore, retorna null si no existen
  Future<ObservacionesExtrasData?> get(String idIngreso) async {
    final doc = await _ref(idIngreso).get();
    if (!doc.exists) return null;
    return ObservacionesExtrasData.fromJson(doc.data()! as Map<String, dynamic>);
  }

  // obtiene los datos o retorna una instancia vacia si no existen
  Future<ObservacionesExtrasData> getOrCreate(String idIngreso) async {
    final existing = await get(idIngreso);
    return existing ?? ObservacionesExtrasData();
  }
}
