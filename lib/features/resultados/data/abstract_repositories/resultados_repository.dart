import 'package:registro_uci/features/resultados/domain/models/indicador.dart';
import 'package:registro_uci/features/resultados/domain/models/resultado.dart';

// repositorio abstracto para resultados e indicadores
abstract class ResultadosRepository {
  // obtiene los resultados de una intervencion
  Future<List<Resultado>> getResultadosDeIntervencion(String idIntervencion);

  // obtiene los indicadores de un resultado
  Future<List<Indicador>> getIndicadoresDeResultado(
    String idIntervencion,
    String idResultado,
  );
}
