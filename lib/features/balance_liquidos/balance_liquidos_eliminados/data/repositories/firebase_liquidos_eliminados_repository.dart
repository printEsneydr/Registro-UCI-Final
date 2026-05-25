import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/abstract_repositories/liquidos_eliminados_repository.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/dto/create_liquido_eliminado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/domain/models/liquido_eliminado.dart';

// implementacion en firebase del repositorio de liquidos eliminados
class FirebaseLiquidosEliminadosRepository
    implements LiquidosEliminadosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // crea un nuevo documento en la subcoleccion 'eliminados' del balance
  @override
  Future<void> createLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    CreateLiquidoEliminadoDto dto,
  ) async {
    final eliminadosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('eliminados'); // ← NUEVA COLECCIÓN

    final newDocRef = eliminadosRef.doc();
    await newDocRef.set(dto.toMap());
  }

  // actualiza un documento existente en la subcoleccion 'eliminados'
  @override
  Future<void> updateLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoEliminado,
    CreateLiquidoEliminadoDto dto,
  ) async {
    final liquidoEliminadoRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('eliminados')
        .doc(idLiquidoEliminado);

    await liquidoEliminadoRef.update(dto.toMap());
  }

  // elimina un documento de la subcoleccion 'eliminados'
  @override
  Future<void> deleteLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoEliminado,
  ) async {
    final liquidoEliminadoRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('eliminados')
        .doc(idLiquidoEliminado);

    await liquidoEliminadoRef.delete();
  }

  // obtiene todos los liquidos eliminados ordenados por hora
  @override
  Future<List<LiquidoEliminado>> getLiquidosEliminados(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
  ) async {
    final querySnapshot = await _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('eliminados')
        .orderBy('hora') // Ordenar por hora
        .get();

    return querySnapshot.docs
        .map((doc) => LiquidoEliminado.fromJson(doc.data(), id: doc.id))
        .toList();
  }
}
