import 'package:registro_uci/features/ingresos/data/dto/create_ingreso_dto.dart';
import 'package:registro_uci/features/ingresos/data/dto/update_ingreso_dto.dart';
import 'package:registro_uci/features/ingresos/domain/models/ingreso.dart';

// repositorio abstracto que define las operaciones CRUD de ingresos
abstract class IngresosRepository {
  // obtiene todos los ingresos ordenados por fechaIngreso descendente
  Future<List<Ingreso>> getAllIngresos();
  // crea un nuevo ingreso en la base de datos
  Future<void> createIngreso(CreateIngresoDto dto);
  // actualiza un ingreso existente por su id
  Future<void> updateIngreso(
    String idIngreso,
    UpdateIngresoDto dto,
  );
  // obtiene un ingreso por su id
  Future<Ingreso?> getIngresoById(String idIngreso);

  // obtiene los ingresos filtrados por sala
  Future<List<Ingreso>> getIngresosBySala(Sala sala);

  // marca un ingreso como finalizado con la fecha de egreso
  Future<void> terminarIngreso(String idIngreso, DateTime fechaFin);
}
