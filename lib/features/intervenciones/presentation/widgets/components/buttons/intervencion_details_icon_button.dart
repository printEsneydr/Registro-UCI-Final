import 'package:flutter/material.dart';
import 'package:registro_uci/common/components/icon_buttons/details_icon_button.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/intervenciones/domain/models/intervencion.dart';
import 'package:registro_uci/pages/intervenciones/intervencion_page.dart';

// boton de icono para ver los detalles de una intervencion
class IntervencionDetailsIconButton extends StatelessWidget {
  final Intervencion intervencion;
  final ReporteParams params;

  // constructor de IntervencionDetailsIconButton
  const IntervencionDetailsIconButton({
    super.key,
    required this.params,
    required this.intervencion,
  });

  // navega a la pagina de detalle de la intervencion al presionar
  @override
  Widget build(BuildContext context) {
    return DetailsIconButton(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return IntervencionPage(
                intervencion: intervencion,
              );
            },
          ),
        );
      },
    );
  }
}
