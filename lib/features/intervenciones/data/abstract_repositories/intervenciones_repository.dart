import 'package:registro_uci/features/intervenciones/domain/models/actividad.dart';
import 'package:registro_uci/features/intervenciones/domain/models/intervencion.dart';

// repositorio abstracto para intervenciones
abstract class IntervencionesRepository {
  // obtiene todas las intervenciones
  Future<List<Intervencion>> getIntervenciones();
  // obtiene las actividades de una intervencion
  Future<List<Actividad>> getActividadesDeIntervencion(String idIntervencion);
}
