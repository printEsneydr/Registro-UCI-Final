import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/dto/create_liquido_administrado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/domain/models/liquido_administrado.dart';

// interface abstracta del repositorio de liquidos administrados
abstract class LiquidosAdministradosRepository {
  // crea un liquido administrado
  Future<void> createLiquidoAdministrado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    CreateLiquidoAdministradoDto dto,
  );

  // actualiza un liquido administrado existente
  Future<void> updateLiquidoAdministrado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoAdministrado,
    CreateLiquidoAdministradoDto dto,
  );

  // elimina un liquido administrado
  Future<void> deleteLiquidoAdministrado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoAdministrado,
  );

  // obtiene la lista de liquidos administrados de un balance
  Future<List<LiquidoAdministrado>> getLiquidosAdministrados(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
  );

  // obtiene liquidos administrados de la hora anterior
  Future<List<LiquidoAdministrado>> getLiquidosAdministradosFromPreviousHour(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
  );

  // obtiene tratamientos antibioticos activos como dto
  Future<List<CreateLiquidoAdministradoDto>> getTratamientosAntibioticosActivos(
    String idIngreso,
    DateTime hora,
  );

  // crea multiples liquidos administrados en lote
  Future<void> createManyLiquidosAdministrados(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    List<CreateLiquidoAdministradoDto> dtos,
  );
}
