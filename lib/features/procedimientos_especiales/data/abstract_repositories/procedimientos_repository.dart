// interfaz abstracta que define el contrato para el repositorio de procedimientos
import '../dto/create_procedimiento_dto.dart';
import '../dto/update_procedimiento_dto.dart';
import '../../domain/models/procedimientos_especiales.dart';

abstract class ProcedimientosRepository {
  // obtiene los procedimientos de un ingreso en tiempo real via stream
  Stream<List<ProcedimientoEspecial>> getProcedimientosDeRegistro(
    String idIngreso,
  );

  // agrega un nuevo procedimiento al ingreso
  Future<void> addProcedimientoToRegistro(
    String idIngreso,
    CreateProcedimientoDto dto,
  );

  // actualiza el estado de un procedimiento existente
  Future<void> updateProcedimientoDeRegistro(
    String idIngreso,
    String idProcedimiento,
    UpdateProcedimientoDto dto,
  );

  // elimina un procedimiento del ingreso
  Future<void> deleteProcedimientoDeRegistro(
    String idIngreso,
    String idProcedimiento,
  );

  // edita el nombre de un procedimiento
  Future<void> editProcedimientoNombre(
    String idIngreso,
    String idProcedimiento,
    String nuevoNombre,
  );

  // actualiza el estado de un procedimiento
  Future<void> updateProcedimientoEstado(
    String idIngreso,
    String idProcedimiento,
    String nuevoEstado,
  );
}
