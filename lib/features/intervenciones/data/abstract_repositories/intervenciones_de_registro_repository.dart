import 'package:registro_uci/features/intervenciones/domain/models/intervencion.dart';

// repositorio abstracto para intervenciones de un registro
abstract class IntervencionesDeRegistroRepository {
  // agrega intervenciones a un registro
  Future<void> agregarIntervencionesARegistro(
    String idIngreso,
    String idRegistro,
    List<String> idsIntervenciones,
  );

  // elimina una intervencion de un registro
  Future<void> eliminarIntervencionDeRegistro(
    String idIngreso,
    String idRegistro,
    String idIntervencion,
  );

  // obtiene las intervenciones de un registro
  Future<List<Intervencion>> getIntervencionesDeRegistro(
    String idIngreso,
    String idRegistro,
  );

  // importa intervenciones de un registro a otro
  Future<void> importIntervencionesFromRegistro(
    String idIngreso,
    String originRegistro,
    String targetRegistro,
  );
}
