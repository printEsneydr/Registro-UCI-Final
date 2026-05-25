// proveedores para el repositorio y los datos de observaciones extras
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/firebase_observaciones_extras_repository.dart';
import '../../domain/models/observaciones_extras_data.dart';

// proveedor del repositorio de firebase para observaciones extras
final observacionesExtrasRepositoryProvider = Provider<ObservacionesExtrasRepository>((ref) {
  return ObservacionesExtrasRepository();
});

// proveedor que obtiene o crea los datos de observaciones extras para un ingreso
final observacionesExtrasDataProvider =
    FutureProvider.family<ObservacionesExtrasData, String>(
  (ref, idIngreso) async {
    final repo = ref.watch(observacionesExtrasRepositoryProvider);
    return repo.getOrCreate(idIngreso);
  },
);
