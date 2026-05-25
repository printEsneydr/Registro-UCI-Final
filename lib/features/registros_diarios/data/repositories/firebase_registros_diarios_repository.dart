// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/common/constants/firebase_collection_names.dart';
import 'package:registro_uci/features/balance_liquidos/data/dto/create_balace_de_liquidos_dto.dart';
import 'package:registro_uci/features/firmas/data/dto/create_firma_dto.dart';
import 'package:registro_uci/features/firmas/domain/models/firma.dart';
import 'package:registro_uci/features/registros_diarios/data/abstract_repositories/registros_diarios_repository.dart';
import 'package:registro_uci/features/registros_diarios/data/dto/create_registro_diario_dto.dart';
import 'package:registro_uci/features/registros_diarios/domain/models/registro_diario.dart';

// implementacion en firebase del repositorio de registros diarios
class FirebaseRegistrosDiariosRepository
    implements IRegistrosDiariosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RegistroDiario>> getRegistrosDiariosDeIngreso(
      String idIngreso) async {
    try {
      // obtiene los documentos de la subcoleccion 'registrosDiarios' del ingreso
      final querySnapshot = await _firestore
          .collection(FirebaseCollectionNames.ingresos)
          .doc(idIngreso)
          .collection(FirebaseCollectionNames.registrosDiarios)
          .get();

      // mapea los documentos firestore a modelos RegistroDiario
      return querySnapshot.docs
          .map((doc) => RegistroDiario.fromJson(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to fetch registros diarios');
    }
  }

  @override
  Future<RegistroDiario?> getRegistroDiario(
      String idIngreso, String idRegistro) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('registrosDiarios')
          .doc(idRegistro);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        return RegistroDiario.fromJson(docSnapshot.data()!, id: docSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      log('Error al obtener el registro diario: $e');
      throw Exception('Error al obtener el registro diario');
    }
  }

  @override
  Future<void> addRegistroDiarioToIngreso(
      String idIngreso, CreateRegistroDiarioDto dto) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final registrosDiariosRef = _firestore
            .collection(FirebaseCollectionNames.ingresos)
            .doc(idIngreso)
            .collection(FirebaseCollectionNames.registrosDiarios);

        // usa la fecha como id del documento para evitar duplicados
        final String fechaRegistroId =
            dto.fechaRegistro.toIso8601String().split('T')[0];

        final docRef = registrosDiariosRef.doc(fechaRegistroId);

        final existingRegistro = await transaction.get(docRef);

        // valida que no exista ya un registro para esa fecha
        if (existingRegistro.exists) {
          throw Exception(
              'Ya existe un registro diario para la fecha: $fechaRegistroId');
        }

        // crea el registro diario
        transaction.set(docRef, dto);

        // crea los 24 registros de balance de liquidos para el dia
        final horas = [
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          1,
          2,
          3,
          4,
          5,
          6,
          7
        ];
        final balancesDeLiquidos = List.generate(
          24,
          (index) => CreateBalanceDeLiquidosDto(
            orden: index + 1,
            hora: horas[index],
          ),
        );

        final balancesDeLiquidosRef =
            docRef.collection(FirebaseCollectionNames.balancesDeLiquidos);

        for (var balance in balancesDeLiquidos) {
          final balanceDocRef = balancesDeLiquidosRef.doc('${balance.hora}');
          transaction.set(balanceDocRef, balance);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> firmarReporte(
    String idIngreso,
    String idRegistro,
    String tipoFirma,
    CreateFirmaDto firma,
  ) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('registrosDiarios')
          .doc(idRegistro);

      // actualiza el campo de firma correspondiente en el documento
      await docRef.update({
        tipoFirma: firma,
      });
    } catch (e) {
      log('Error al firmar el reporte: $e');
      throw Exception('Error al firmar el reporte');
    }
  }

  @override
  Future<Firma?> getFirma(
    String idIngreso,
    String idRegistro,
    String tipoFirma,
  ) async {
    try {
      final docRef = _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('registrosDiarios')
          .doc(idRegistro);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final firmaData = docSnapshot.data()![tipoFirma];
        if (firmaData != null) {
          return Firma.fromJson(firmaData);
        } else {
          return null;
        }
      } else {
        throw Exception('Registro diario no encontrado');
      }
    } catch (e) {
      log('Error al obtener la firma: $e');
      throw Exception('Error al obtener la firma');
    }
  }

  @override
  Future<int> getBalanceAcumuladoUntilHora(
    String idIngreso,
    String idRegistroDiario,
    int hora,
  ) async {
    int totalBalanceAcumulado = 0;

    // referencia a la subcoleccion de balances de liquidos
    CollectionReference balancesDeLiquidosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos');

    // obtiene todos los balances ordenados
    QuerySnapshot balancesSnapshot =
        await balancesDeLiquidosRef.orderBy('orden').get();

    // itera sobre los balances hasta llegar a la hora indicada
    var shouldBreak = false;
    for (var balanceDoc in balancesSnapshot.docs) {
      Map<String, dynamic> balanceData =
          balanceDoc.data() as Map<String, dynamic>;

      if (balanceData['hora'] != null && balanceData['hora'] == hora) {
        shouldBreak = true;
      }

      log(balanceData['hora'].toString());

      // referencia a los administrados de cada balance
      CollectionReference administradosRef =
          balanceDoc.reference.collection('administrados');

      // suma las cantidades de los administrados
      QuerySnapshot administradosSnapshot = await administradosRef.get();
      int balanceTotalForThisBalance =
          administradosSnapshot.docs.fold(0, (suma, administradoDoc) {
        Map<String, dynamic> administradoData =
            administradoDoc.data() as Map<String, dynamic>;
        final result = suma + (administradoData['cantidad'] ?? 0) as int;
        print(result.toString());
        return result;
      });

      totalBalanceAcumulado += balanceTotalForThisBalance;

      if (shouldBreak) {
        break;
      }
    }

    // actualiza el registro diario con el total calculado
    DocumentReference registroDiarioRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario);

    await registroDiarioRef.update({
      'totalAdministrados': totalBalanceAcumulado,
      'fechaCalculoTotalAdministrados': FieldValue.serverTimestamp(),
      'totalAdministradoCalculatedUntil': hora,
    });

    return totalBalanceAcumulado;
  }
}
