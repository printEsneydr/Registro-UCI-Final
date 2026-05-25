import 'package:flutter/material.dart';
import '../../features/control_riesgos/presentation/widgets/update_control_riegos_form.dart';
import 'package:registro_uci/features/control_riesgos/domain/models/control_de_riesgos.dart';
import 'package:registro_uci/features/control_riesgos/data/repositories/firabase_control_de_riesgos.dart'; // Asegúrate de importar el modelo correcto

// pagina para editar un registro existente de control de riesgos
class UpdateControlRiesgosPage extends StatelessWidget {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario asociado
  final String idRegistroDiario;
  // id del control de riesgos a editar
  final String controlRiesgosId;

  // constructor requiere id de ingreso, registro diario y control de riesgos
  const UpdateControlRiesgosPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
    required this.controlRiesgosId,
  });

  // construye la pagina, carga el registro y muestra el formulario de edicion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<ControlDeRiesgos>(
          future: _fetchControlDeRiesgos(), // Método para obtener el objeto
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No se encontró el registro'));
            }
            final controlDeRiesgos = snapshot.data!;
            return UpdateControlRiesgosForm(
              idIngreso: idIngreso,
              idRegistroDiario: idRegistroDiario,
              controlDeRiesgos: controlDeRiesgos, // Pasar el objeto completo
            );
          },
        ),
      ),
    );
  }

  // obtiene el control de riesgos desde firebase usando su id
  Future<ControlDeRiesgos> _fetchControlDeRiesgos() async {
    final repository = FirebaseControlDeRiesgosRepository();
    return await repository.getControlDeRiesgosById(
      idIngreso,
      idRegistroDiario,
      controlRiesgosId,
    );
  }
}
