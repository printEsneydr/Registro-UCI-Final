import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/necesidades/domain/models/reporte_necesidades.dart';

// provider que obtiene el reporte de necesidades desde firestore
final reporteNecesidadesProvider =
    FutureProvider.family<ReporteNecesidades?, ReporteNecesidadesParams>(
  (ref, params) async {
    final doc = await FirebaseFirestore.instance
        .collection('ingresos')
        .doc(params.idIngreso)
        .collection('registrosDiarios')
        .doc(params.idRegistro)
        .collection('necesidades')
        .doc('reporte')
        .get();
    if (!doc.exists) return null;
    return ReporteNecesidades.fromJson(doc.data()!, id: doc.id);
  },
);

// parametros de entrada para el provider del reporte de necesidades
class ReporteNecesidadesParams {
  final String idIngreso;
  final String idRegistro;

  const ReporteNecesidadesParams({
    required this.idIngreso,
    required this.idRegistro,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReporteNecesidadesParams &&
          idIngreso == other.idIngreso &&
          idRegistro == other.idRegistro;

  @override
  int get hashCode => Object.hash(idIngreso, idRegistro);
}

// funcion global para guardar el reporte de necesidades en firestore
Future<void> guardarReporteNecesidades({
  required String idIngreso,
  required String idRegistro,
  required ReporteNecesidades reporte,
}) async {
  await FirebaseFirestore.instance
      .collection('ingresos')
      .doc(idIngreso)
      .collection('registrosDiarios')
      .doc(idRegistro)
      .collection('necesidades')
      .doc('reporte')
      .set(reporte.toMap());
}
