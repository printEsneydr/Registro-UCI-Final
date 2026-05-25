import 'package:registro_uci/features/firmas/data/dto/create_firma_dto.dart';
import 'package:registro_uci/features/firmas/domain/models/firma.dart';
import 'package:registro_uci/features/registros_diarios/data/dto/create_registro_diario_dto.dart';
import 'package:registro_uci/features/registros_diarios/domain/models/registro_diario.dart';

// repositorio abstracto para operaciones con registros diarios
abstract class IRegistrosDiariosRepository {
  // obtiene todos los registros diarios de un ingreso
  Future<List<RegistroDiario>> getRegistrosDiariosDeIngreso(String idIngreso);

  // obtiene un registro diario especifico por id
  Future<RegistroDiario?> getRegistroDiario(
    String idIngreso,
    String idRegistro,
  );

  // agrega un nuevo registro diario a un ingreso
  Future<void> addRegistroDiarioToIngreso(
    String idIngreso,
    CreateRegistroDiarioDto dto,
  );

  // firma un reporte dentro del registro diario
  Future<void> firmarReporte(
    String idIngreso,
    String idRegistro,
    String tipoFirma,
    CreateFirmaDto firma,
  );

  // obtiene una firma especifica del registro diario
  Future<Firma?> getFirma(
    String idIngreso,
    String idRegistro,
    String tipoFirma,
  );

  // calcula el balance acumulado hasta una hora determinada
  Future<int> getBalanceAcumuladoUntilHora(
    String idIngreso,
    String idRegistroDiario,
    int hora,
  );
}
