import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/firebase_observaciones_extras_repository.dart';
import '../../domain/models/observaciones_extras_data.dart';

final observacionesExtrasRepositoryProvider = Provider<ObservacionesExtrasRepository>((ref) {
  return ObservacionesExtrasRepository();
});

final observacionesExtrasDataProvider =
    FutureProvider.family<ObservacionesExtrasData, String>(
  (ref, idIngreso) async {
    final repo = ref.watch(observacionesExtrasRepositoryProvider);
    return repo.getOrCreate(idIngreso);
  },
);
