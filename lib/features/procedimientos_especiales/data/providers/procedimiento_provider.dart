// proveedor que expone el repositorio de firebase para procedimientos especiales
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firabase_procedimientos_especiales.dart';
import '../../domain/models/procedimientos_especiales.dart';
import '../../data/dto/create_procedimiento_dto.dart';
import '../../data/dto/update_procedimiento_dto.dart';

// proveedor del repositorio de firebase
final procedimientoRepositoryProvider =
    Provider<FirebaseProcedimientosRepository>((ref) {
  return FirebaseProcedimientosRepository();
});

// proveedor que retorna un stream de procedimientos en tiempo real por id de ingreso
final procedimientoStreamProvider =
    StreamProvider.family<List<ProcedimientoEspecial>, String>(
        (ref, idIngreso) {
  final repository = ref.watch(procedimientoRepositoryProvider);
  return repository.getProcedimientosDeRegistro(idIngreso);
});

// proveedor que expone la clase ProcedimientoActions para operaciones crud
final procedimientoActionProvider = Provider<ProcedimientoActions>((ref) {
  return ProcedimientoActions(ref.watch(procedimientoRepositoryProvider));
});

// clase con metodos para agregar, actualizar y eliminar procedimientos
class ProcedimientoActions {
  final FirebaseProcedimientosRepository _repository;

  ProcedimientoActions(this._repository);

  // agrega un procedimiento con datos basicos y estado opcional
  Future<void> addProcedimiento(String idIngreso, String nombre,
      {String? medicamentoInfusion, String? dosisInfusion, String estado = "Por realizar"}) async {
    final nuevoProcedimiento = CreateProcedimientoDto(
      nombreProcedimiento: nombre,
      estado: estado,
      medicamentoInfusion: medicamentoInfusion,
      dosisInfusion: dosisInfusion,
    );
    await _repository.addProcedimientoToRegistro(idIngreso, nuevoProcedimiento);
  }

  // agrega un procedimiento usando un dto directamente
  Future<void> addProcedimientoWithDto(
      String idIngreso, CreateProcedimientoDto dto) async {
    await _repository.addProcedimientoToRegistro(idIngreso, dto);
  }

  // actualiza el estado de un procedimiento existente
  Future<void> updateProcedimiento(
      String idIngreso, String idProcedimiento, String nuevoEstado) async {
    final updateDto = UpdateProcedimientoDto(estado: nuevoEstado);
    await _repository.updateProcedimientoDeRegistro(
        idIngreso, idProcedimiento, updateDto);
  }

  // edita los campos de medicamento y dosis de infusion de un procedimiento
  Future<void> editProcedimientoInfusion(
    String idIngreso,
    String idProcedimiento,
    String? medicamentoInfusion,
    String? dosisInfusion,
  ) async {
    final data = <String, dynamic>{};
    if (medicamentoInfusion != null) data['medicamentoInfusion'] = medicamentoInfusion;
    if (dosisInfusion != null) data['dosisInfusion'] = dosisInfusion;
    if (data.isNotEmpty) {
      await _repository.updateProcedimientoFields(idIngreso, idProcedimiento, data);
    }
  }

  // elimina un procedimiento de firestore
  Future<void> deleteProcedimiento(
      String idIngreso, String idProcedimiento) async {
    await _repository.deleteProcedimientoDeRegistro(idIngreso, idProcedimiento);
  }

  // edita el nombre de un procedimiento existente
  Future<void> editProcedimientoNombre(
      String idIngreso, String idProcedimiento, String nuevoNombre) async {
    await _repository.editProcedimientoNombre(
        idIngreso, idProcedimiento, nuevoNombre);
  }

  // actualiza solo el estado de un procedimiento
  Future<void> updateProcedimientoEstado(
      String idIngreso, String idProcedimiento, String nuevoEstado) async {
    await _repository.updateProcedimientoEstado(
        idIngreso, idProcedimiento, nuevoEstado);
  }
}
