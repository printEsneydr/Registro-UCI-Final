// interfaz abstracta que define el contrato para el repositorio de tratamientos
import 'package:registro_uci/features/lista_tratamientos/domain/models/lista_tratamientos.dart';

abstract class ListaTratamientosRepository {
  // obtiene los tratamientos de un registro diario en tiempo real
  Stream<List<ListaTratamientos>> getListaTratamientos(
    String idIngreso,
    String idRegistroDiario,
  );

  // agrega un nuevo tratamiento a la lista
  Future<void> addListaTratamientos(
    String idIngreso,
    String idRegistroDiario,
    ListaTratamientos listaTratamientos,
  );

  // actualiza un tratamiento existente
  Future<void> updateListaTratamientos(
    String idIngreso,
    String idRegistroDiario,
    String idListaTratamientos,
    ListaTratamientos listaTratamientos,
  );

  // elimina un tratamiento de la lista
  Future<void> deleteListaTratamientos(
    String idIngreso,
    String idRegistroDiario,
    String idListaTratamientos,
  );

  // obtiene un tratamiento especifico por su id
  Future<ListaTratamientos?> getListaTratamientosById(
    String idIngreso,
    String idRegistroDiario,
    String idListaTratamientos,
  );
}
