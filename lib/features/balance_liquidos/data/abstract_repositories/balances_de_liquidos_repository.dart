import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/features/balance_liquidos/domain/models/balance_de_liquidos.dart';

// interface abstracta del repositorio de balances de liquidos
abstract class BalancesDeLiquidosRepository {
  // obtiene la lista de balances de liquidos de un registro diario
  Future<List<BalanceDeLiquidos>> getBalancesDeLiquidos(
    String idIngreso,
    String idRegistroDiario,
  );
  // obtiene el documento del registro diario desde firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getBalanceDeLiquidosDoc(
    String idIngreso,
    String idRegistroDiario,
  );
}
