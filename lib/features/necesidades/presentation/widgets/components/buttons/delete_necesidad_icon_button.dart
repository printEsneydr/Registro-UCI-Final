import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/components/icon_buttons/delete_icon_button.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/necesidades/presentation/widgets/components/confirm_delete_necesidad_form.dart';

// boton icono que abre el dialogo de confirmacion para eliminar una necesidad
class DeleteNecesidadIconButton extends ConsumerWidget {
  final String idNecesidad;
  final ReporteParams params;

  // constructor que recibe el id de la necesidad y los parametros del reporte
  const DeleteNecesidadIconButton({
    super.key,
    required this.params,
    required this.idNecesidad,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DeleteIconButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: ConfirmDeleteNecesidadForm(
                  idNecesidad: idNecesidad, params: params),
            );
          },
        );
      },
    );
  }
}
