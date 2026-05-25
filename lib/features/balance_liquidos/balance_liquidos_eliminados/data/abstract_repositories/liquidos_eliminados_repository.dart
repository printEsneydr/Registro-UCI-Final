import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/dto/create_liquido_eliminado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/domain/models/liquido_eliminado.dart';

// interface abstracta del repositorio de liquidos eliminados
abstract class LiquidosEliminadosRepository {
  // crea un nuevo registro de liquido eliminado
  Future<void> createLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    CreateLiquidoEliminadoDto dto,
  );

  // actualiza un registro de liquido eliminado existente
  Future<void> updateLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoEliminado,
    CreateLiquidoEliminadoDto dto,
  );

  // elimina un registro de liquido eliminado
  Future<void> deleteLiquidoEliminado(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
    String idLiquidoEliminado,
  );

  // obtiene la lista de liquidos eliminados de un balance
  Future<List<LiquidoEliminado>> getLiquidosEliminados(
    String idIngreso,
    String idRegistroDiario,
    String idBalanceLiquidos,
  );
}
