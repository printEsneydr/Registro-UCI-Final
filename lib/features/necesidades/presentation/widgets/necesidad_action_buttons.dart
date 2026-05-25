import 'package:flutter/material.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/necesidades/domain/models/necesidad.dart';
import 'package:registro_uci/features/necesidades/presentation/widgets/components/buttons/delete_necesidad_icon_button.dart';
import 'package:registro_uci/features/necesidades/presentation/widgets/components/buttons/update_necesidad_icon_button.dart';

// widget que agrupa los botones de accion (editar, eliminar) para una necesidad
class NecesidadActionButtons extends StatelessWidget {
  final Necesidad necesidad;
  final ReporteParams params;

  // constructor que recibe la necesidad y los parametros del reporte
  const NecesidadActionButtons({
    super.key,
    required this.params,
    required this.necesidad,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DeleteNecesidadIconButton(
          idNecesidad: necesidad.idNecesidad,
          params: params,
        ),
        UpdateNecesidadIconButton(
          params: params,
          necesidad: necesidad,
        ),
      ],
    );
  }
}
