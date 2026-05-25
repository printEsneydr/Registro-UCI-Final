import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/nutricion/data/repositories/firebase_nutricion_repository.dart';
import 'package:registro_uci/features/nutricion/domain/models/registro_nutricional.dart';

// provider del repositorio de nutricion
final nutricionRepositoryProvider =
    Provider<FirebaseNutricionRepository>((ref) {
  return FirebaseNutricionRepository();
});

// provider que obtiene todos los registros nutricionales de un ingreso
final registrosNutricionalesProvider =
    FutureProvider.family<List<RegistroNutricional>, String>(
        (ref, idIngreso) async {
  final repository = ref.watch(nutricionRepositoryProvider);
  return repository.getRegistrosNutricionales(idIngreso);
});

// provider que obtiene el ultimo registro nutricional de un ingreso
final ultimoRegistroNutricionalProvider =
    FutureProvider.family<RegistroNutricional?, String>((ref, idIngreso) async {
  final repository = ref.watch(nutricionRepositoryProvider);
  return repository.getUltimoRegistroNutricional(idIngreso);
});
