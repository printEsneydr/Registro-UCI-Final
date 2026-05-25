import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/providers/repository_providers.dart';

// Define a class to hold the parameters
// parametros para obtener el balance total de un registro diario
@immutable
class BalanceParams {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario
  final String idRegistroDiario;

  // constructor con los parametros requeridos
  const BalanceParams({
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BalanceParams &&
        other.idIngreso == idIngreso &&
        other.idRegistroDiario == idRegistroDiario;
  }

  @override
  int get hashCode => Object.hash(idIngreso, idRegistroDiario);
}

// provider que obtiene el balance total de liquidos de todas las horas
final totalBalanceProvider =
    FutureProvider.family<Map<String, dynamic>, BalanceParams>(
        (ref, params) async {
  final firestore = FirebaseFirestore.instance;

  // Get total administrados from registro diario
  final doc = await firestore
      .collection('ingresos')
      .doc(params.idIngreso)
      .collection('registrosDiarios')
      .doc(params.idRegistroDiario)
      .get();

  final data = doc.data() ?? {};
  final totalAdministrados =
      (data['totalAdministrados'] as num?)?.toDouble() ?? 0.0;

  // Calculate total eliminados
  double totalEliminados = 0.0;

  // Get all balancesDeLiquidos
  final balancesRef = firestore
      .collection('ingresos')
      .doc(params.idIngreso)
      .collection('registrosDiarios')
      .doc(params.idRegistroDiario)
      .collection('balancesDeLiquidos');

  final balancesSnapshot = await balancesRef.orderBy('orden').get();

  for (var balanceDoc in balancesSnapshot.docs) {
    final eliminadosRef = balanceDoc.reference.collection('eliminados');
    final eliminadosSnapshot = await eliminadosRef.get();

    for (var eliminadoDoc in eliminadosSnapshot.docs) {
      final Map<String, dynamic> eliminadoData = eliminadoDoc.data();
      totalEliminados += (eliminadoData['orina'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['perdidasInsensibles'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['sondaGastrica'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['residuoGastrico'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['tuboTorax1'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['tuboTorax2'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['tuboMediastino'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['drenAbdominal'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['ileostomia'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['fistulaEnterocutanea'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['deposicion'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['dialisis'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['ventriculosTomaExterna'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['otros'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['campoLibre1'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (eliminadoData['campoLibre2'] as num?)?.toDouble() ?? 0.0;
    }
  }

  final balance = totalAdministrados - totalEliminados;

  return {
    'totalAdministrados': totalAdministrados,
    'totalEliminados': totalEliminados,
    'balance': balance,
    'fechaCalculoTotalAdministrados': data['fechaCalculoTotalAdministrados'],
    'totalAdministradoCalculatedUntil':
        data['totalAdministradoCalculatedUntil'] ?? 0,
    'horaActual': data['totalAdministradoCalculatedUntil'] ?? 0,
  };
});

// Provider para balance hasta una hora específica
// parametros para obtener el balance hasta una hora especifica
@immutable
class BalancePorHoraParams {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario
  final String idRegistroDiario;
  // hora limite para el calculo del balance
  final int hora;

  // constructor con los parametros requeridos
  const BalancePorHoraParams({
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.hora,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BalancePorHoraParams &&
        other.idIngreso == idIngreso &&
        other.idRegistroDiario == idRegistroDiario &&
        other.hora == hora;
  }

  @override
  int get hashCode => Object.hash(idIngreso, idRegistroDiario, hora);
}

// provider que calcula el balance de liquidos hasta una hora especifica
final balancePorHoraProvider =
    FutureProvider.family<Map<String, dynamic>, BalancePorHoraParams>(
        (ref, params) async {
  final firestore = FirebaseFirestore.instance;

  double totalAdministrados = 0.0;
  double totalEliminados = 0.0;

  final balancesRef = firestore
      .collection('ingresos')
      .doc(params.idIngreso)
      .collection('registrosDiarios')
      .doc(params.idRegistroDiario)
      .collection('balancesDeLiquidos');

  final balancesSnapshot = await balancesRef.orderBy('orden').get();

  for (var balanceDoc in balancesSnapshot.docs) {
    final balanceData = balanceDoc.data();
    final horaBalance = (balanceData['hora'] as num?)?.toInt() ?? 0;

    // Si pasamos la hora objetivo, salir del loop
    if (horaBalance > params.hora) {
      break;
    }

    // Sumar administrados
    final administradosRef = balanceDoc.reference.collection('administrados');
    final administradosSnapshot = await administradosRef.get();
    for (var admDoc in administradosSnapshot.docs) {
      final admData = admDoc.data();
      totalAdministrados += (admData['cantidad'] as num?)?.toDouble() ?? 0.0;
    }

    // Sumar eliminados
    final eliminadosRef = balanceDoc.reference.collection('eliminados');
    final eliminadosSnapshot = await eliminadosRef.get();
    for (var elimDoc in eliminadosSnapshot.docs) {
      final elimData = elimDoc.data();
      totalEliminados += (elimData['orina'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['perdidasInsensibles'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['sondaGastrica'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['residuoGastrico'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['tuboTorax1'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['tuboTorax2'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['tuboMediastino'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['drenAbdominal'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['ileostomia'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['fistulaEnterocutanea'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['deposicion'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['dialisis'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['ventriculosTomaExterna'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['otros'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['campoLibre1'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['campoLibre2'] as num?)?.toDouble() ?? 0.0;
    }

    // Si llegamos a la hora objetivo, salir
    if (horaBalance == params.hora) {
      break;
    }
  }

  final balance = totalAdministrados - totalEliminados;

  return {
    'totalAdministrados': totalAdministrados,
    'totalEliminados': totalEliminados,
    'balance': balance,
    'hora': params.hora,
  };
});

// provider que obtiene el balance acumulado en una hora especifica
final balanceAcumuladoProvider =
    FutureProvider.family<Map<String, double>, CalculateParams>(
        (ref, params) async {
  final firestore = FirebaseFirestore.instance;

  double totalAdministrados = 0.0;
  double totalEliminados = 0.0;

  final balancesRef = firestore
      .collection('ingresos')
      .doc(params.idIngreso)
      .collection('registrosDiarios')
      .doc(params.idRegistroDiario)
      .collection('balancesDeLiquidos');

  final balancesSnapshot = await balancesRef.orderBy('orden').get();

  for (var balanceDoc in balancesSnapshot.docs) {
    final Map<String, dynamic> balanceData = balanceDoc.data();
    final horaBalance = balanceData['hora'] as int?;

    if (horaBalance != null && horaBalance > params.hora) {
      break;
    }

    // Sum administrados
    final administradosRef = balanceDoc.reference.collection('administrados');
    final administradosSnapshot = await administradosRef.get();
    for (var admDoc in administradosSnapshot.docs) {
      final Map<String, dynamic> admData = admDoc.data();
      totalAdministrados += admData['cantidad'] as int? ?? 0;
    }

    // Sum eliminados
    final eliminadosRef = balanceDoc.reference.collection('eliminados');
    final eliminadosSnapshot = await eliminadosRef.get();
    for (var elimDoc in eliminadosSnapshot.docs) {
      final Map<String, dynamic> elimData = elimDoc.data();
      totalEliminados += (elimData['orina'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['perdidasInsensibles'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['sondaGastrica'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['residuoGastrico'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['tuboTorax1'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['tuboTorax2'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['tuboMediastino'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['drenAbdominal'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['ileostomia'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['fistulaEnterocutanea'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['deposicion'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['dialisis'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['ventriculosTomaExterna'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['otros'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['campoLibre1'] as num?)?.toDouble() ?? 0.0;
      totalEliminados += (elimData['campoLibre2'] as num?)?.toDouble() ?? 0.0;
    }

    if (horaBalance != null && horaBalance == params.hora) {
      break;
    }
  }

  final balance = totalAdministrados - totalEliminados;

  return {
    'totalAdministrados': totalAdministrados,
    'totalEliminados': totalEliminados,
    'balance': balance,
  };
});

// Define a separate class for the calculation function parameters
// parametros para la funcion de calculo de balance acumulado
@immutable
class CalculateParams {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario
  final String idRegistroDiario;
  // hora para el calculo del balance
  final int hora;

  // constructor con los parametros requeridos
  const CalculateParams({
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.hora,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalculateParams &&
        other.idIngreso == idIngreso &&
        other.idRegistroDiario == idRegistroDiario &&
        other.hora == hora;
  }

  @override
  int get hashCode => Object.hash(idIngreso, idRegistroDiario, hora);
}

// provider que calcula el balance total hasta una hora usando el repositorio
final calculateBalanceProvider =
    FutureProvider.family<int, CalculateParams>((ref, params) async {
  final yourServiceClass = ref.watch(registrosDiariosRepositoryProvider);
  return await yourServiceClass.getBalanceAcumuladoUntilHora(
    params.idIngreso,
    params.idRegistroDiario,
    params.hora,
  );
});
