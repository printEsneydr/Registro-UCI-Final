import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/constants/strings.dart';
import '../../domain/models/observaciones_extras_data.dart';

class ObservacionesExtrasRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference _ref(String idIngreso) =>
      _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection(Strings.collection)
          .doc(Strings.documentId);

  Future<void> save(String idIngreso, ObservacionesExtrasData data) async {
    await _ref(idIngreso).set(data.toJson(), SetOptions(merge: true));
  }

  Future<ObservacionesExtrasData?> get(String idIngreso) async {
    final doc = await _ref(idIngreso).get();
    if (!doc.exists) return null;
    return ObservacionesExtrasData.fromJson(doc.data()! as Map<String, dynamic>);
  }

  Future<ObservacionesExtrasData> getOrCreate(String idIngreso) async {
    final existing = await get(idIngreso);
    return existing ?? ObservacionesExtrasData();
  }
}
