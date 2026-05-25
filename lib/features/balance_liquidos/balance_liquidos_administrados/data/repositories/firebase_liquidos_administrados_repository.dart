import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_uci/features/antibioticos/data/dto/create_dosis_tratamiento_dto.dart';
import 'package:registro_uci/features/antibioticos/domain/models/tratamiento_antibiotico.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/abstract_repositories/liquidos_administrados_repository.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/dto/create_liquido_administrado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/domain/models/liquido_administrado.dart';

// implementacion en firebase del repositorio de liquidos administrados
class FirebaseLiquidosAdministradosRepository
    implements LiquidosAdministradosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // crea un liquido administrado y sincroniza con tratamiento si corresponde
  @override
  Future<void> createLiquidoAdministrado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    CreateLiquidoAdministradoDto dto,
  ) async {
    final administradosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('administrados');

    final newDocRef = administradosRef.doc();
    final liquidoAdministradoData = dto;

    await _firestore.runTransaction((transaction) async {
      transaction.set(newDocRef, liquidoAdministradoData);

      if (dto.esTratamiento) {
        await _syncTratamientoAntibiotico(transaction, idIngreso, dto);
      }
    });
  }

  // actualiza un liquido administrado y sincroniza con tratamiento si corresponde
  @override
  Future<void> updateLiquidoAdministrado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoAdministrado,
    CreateLiquidoAdministradoDto dto,
  ) async {
    final liquidoAdministradoRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('administrados')
        .doc(idLiquidoAdministrado);

    await _firestore.runTransaction((transaction) async {
      transaction.update(liquidoAdministradoRef, dto);

      if (dto.esTratamiento) {
        await _syncTratamientoAntibiotico(transaction, idIngreso, dto);
      }
    });
  }

  // elimina un liquido administrado y su dosis de tratamiento si corresponde
  @override
  Future<void> deleteLiquidoAdministrado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoAdministrado,
  ) async {
    final liquidoAdministradoRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('administrados')
        .doc(idLiquidoAdministrado);

    await _firestore.runTransaction((transaction) async {
      final liquidoAdministradoDoc =
          await transaction.get(liquidoAdministradoRef);
      final isTratamiento =
          liquidoAdministradoDoc.data()?['esTratamiento'] ?? false;

      transaction.delete(liquidoAdministradoRef);

      if (isTratamiento) {
        await _deleteDosisTratamiento(
            transaction, idIngreso, liquidoAdministradoDoc.data());
      }
    });
  }

  // elimina la dosis asociada a un tratamiento antibiotico
  Future<void> _deleteDosisTratamiento(Transaction transaction,
      String idIngreso, Map<String, dynamic>? data) async {
    final medicamento = data?['medicamento'];
    final hora = (data?['hora'] as Timestamp?)?.toDate();

    if (medicamento == null || hora == null) return;

    final tratamientoQuery = await _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('tratamientosAntibioticos')
        .where('antibiotico', isEqualTo: medicamento)
        .limit(1)
        .get();

    if (tratamientoQuery.docs.isEmpty) return;

    final tratamientoDoc = tratamientoQuery.docs.first;
    final fechaInicio = (tratamientoDoc['fechaInicio'] as Timestamp).toDate();
    final dia = _calculateDayNumber(fechaInicio, hora);

    final diaDocRef = tratamientoDoc.reference
        .collection('diasTratamiento')
        .doc(dia.toString());
    final dosisRef = await diaDocRef
        .collection('dosis')
        .where('hora', isEqualTo: hora)
        .limit(1)
        .get();

    if (dosisRef.docs.isNotEmpty) {
      transaction.delete(dosisRef.docs.first.reference);
    }
  }

  // obtiene todos los liquidos administrados de un balance
  @override
  Future<List<LiquidoAdministrado>> getLiquidosAdministrados(
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
        .collection('administrados')
        .get();

    return querySnapshot.docs
        .map((doc) => LiquidoAdministrado.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  // obtiene liquidos administrados de la hora anterior
  @override
  Future<List<LiquidoAdministrado>> getLiquidosAdministradosFromPreviousHour(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
  ) async {
    final previousHour = DateTime.now().subtract(const Duration(hours: 1));
    final querySnapshot = await _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('administrados')
        .where('hora', isGreaterThanOrEqualTo: previousHour)
        .get();

    return querySnapshot.docs
        .map((doc) => LiquidoAdministrado.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  // crea multiples liquidos administrados en lote
  @override
  Future<void> createManyLiquidosAdministrados(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    List<CreateLiquidoAdministradoDto> dtos,
  ) async {
    final administradosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('registrosDiarios')
        .doc(idRegistroDiario)
        .collection('balancesDeLiquidos')
        .doc(idBalanceLiquidos)
        .collection('administrados');

    // Avoid using transactions here
    for (final dto in dtos) {
      final newDocRef = administradosRef.doc();
      await newDocRef.set(
          dto); // Ensure CreateLiquidoAdministradoDto has a toJson() method

      if (dto.esTratamiento) {
        // Implement without transactions
        await _syncTratamientoAntibioticoWithoutTransaction(idIngreso, dto);
      }
    }
  }

  // sincroniza con tratamiento antibiotico sin usar transaccion
  Future<void> _syncTratamientoAntibioticoWithoutTransaction(
    String idIngreso,
    CreateLiquidoAdministradoDto dto,
  ) async {
    final tratamientosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('tratamientosAntibioticos');

    final tratamientoQuery = await tratamientosRef
        .where('antibiotico', isEqualTo: dto.medicamento)
        .limit(1)
        .get();

    if (tratamientoQuery.docs.isEmpty) return;

    final tratamientoDoc = tratamientoQuery.docs.first;
    final fechaInicio = (tratamientoDoc['fechaInicio'] as Timestamp).toDate();

    final diasTratamientoRef =
        tratamientoDoc.reference.collection('diasTratamiento');
    final dia = _calculateDayNumber(fechaInicio, dto.hora);

    final diaDocRef = diasTratamientoRef.doc(dia.toString());
    final diaDoc = await diaDocRef.get();

    if (!diaDoc.exists) {
      await diaDocRef.set({
        'dia': dia,
        'inicio': fechaInicio.add(Duration(days: dia - 1)),
        'fin': fechaInicio
            .add(Duration(days: dia))
            .subtract(const Duration(seconds: 1)),
      });
    }

    final dosisTratamientoRef = diaDocRef.collection('dosis').doc();
    await dosisTratamientoRef.set(
      CreateDosisTratamientoDto(
        cantidad: dto.cantidad,
        comentario: dto.comentario,
        dosis: dto.dosis,
        hora: dto.hora,
      ), // Ensure CreateDosisTratamientoDto has a toJson() method
    );
  }

  // calcula el numero de dia desde la fecha de inicio del tratamiento
  int _calculateDayNumber(DateTime fechaInicio, DateTime hora) {
    final difference = hora.difference(fechaInicio).inDays;
    return difference + 1;
  }

  // sincroniza con tratamiento antibiotico usando una transaccion
  Future<void> _syncTratamientoAntibiotico(
    Transaction transaction,
    String idIngreso,
    CreateLiquidoAdministradoDto dto,
  ) async {
    final tratamientosRef = _firestore
        .collection('ingresos')
        .doc(idIngreso)
        .collection('tratamientosAntibioticos');

    final tratamientoQuery = await tratamientosRef
        .where('antibiotico', isEqualTo: dto.medicamento)
        .limit(1)
        .get();

    if (tratamientoQuery.docs.isEmpty) return;

    final tratamientoDoc = tratamientoQuery.docs.first;
    final fechaInicio = (tratamientoDoc['fechaInicio'] as Timestamp).toDate();

    final diasTratamientoRef =
        tratamientoDoc.reference.collection('diasTratamiento');
    final dia = _calculateDayNumber(fechaInicio, dto.hora);

    final diaDocRef = diasTratamientoRef.doc(dia.toString());
    final diaDoc = await transaction.get(diaDocRef);

    if (!diaDoc.exists) {
      transaction.set(diaDocRef, {
        'dia': dia,
        'inicio': fechaInicio.add(Duration(days: dia - 1)),
        'fin': fechaInicio
            .add(Duration(days: dia))
            .subtract(const Duration(seconds: 1)),
      });
    }

    final dosisTratamientoRef = diaDocRef.collection('dosis').doc();
    transaction.set(
        dosisTratamientoRef,
        CreateDosisTratamientoDto(
          cantidad: dto.cantidad,
          comentario: dto.comentario,
          dosis: dto.dosis,
          hora: dto.hora,
        ));
  }

  // obtiene los tratamientos antibioticos activos para convertirlos en dto
  @override
  Future<List<CreateLiquidoAdministradoDto>> getTratamientosAntibioticosActivos(
    String idIngreso,
    DateTime hora,
  ) async {
    try {
      // Retrieve all antibiotic treatments for the given ingreso
      final tratamientosAntibioticos =
          await getTratamientosAntibioticosDeIngreso(idIngreso);

      // Filter to include only active treatments
      final tratamientosActivos = tratamientosAntibioticos.where((tratamiento) {
        // Consider treatments active if fechaFin is null or in the future
        return tratamiento.fechaFin == null;
      }).toList();

      // Map the filtered results to CreateLiquidoAdministradoDto
      return tratamientosActivos.map((tratamiento) {
        return CreateLiquidoAdministradoDto(
          medicamento: tratamiento.antibiotico,
          cantidad: tratamiento.cantidad,
          comentario: null, // Assuming no comment is provided
          dosis: tratamiento.dosis,
          hora: hora, // Using the provided hour parameter
          esTratamiento: true,
        );
      }).toList();
    } catch (e) {
      log('Error al obtener tratamientos antibióticos activos: $e');
      throw Exception('Error al obtener tratamientos antibióticos activos');
    }
  }

  // obtiene todos los tratamientos antibioticos de un ingreso
  Future<List<TratamientoAntibiotico>> getTratamientosAntibioticosDeIngreso(
    String idIngreso,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('ingresos')
          .doc(idIngreso)
          .collection('tratamientosAntibioticos')
          .get();

      return querySnapshot.docs
          .map((doc) => TratamientoAntibiotico.fromJson(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      log('Error al obtener los tratamientos antibióticos: $e');
      throw Exception('Error al obtener los tratamientos antibióticos');
    }
  }
}
