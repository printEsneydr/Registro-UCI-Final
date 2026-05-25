import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/components/bed_widget.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/firmas/domain/models/firma.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/firmas/presentation/widgets/components/buttons/firmar_reporte_button.dart';
import 'package:registro_uci/features/firmas/presentation/widgets/components/firma_widget.dart';
import 'package:registro_uci/features/intervenciones/presentation/widgets/add_intervenciones_form.dart';
import 'package:registro_uci/features/intervenciones/presentation/widgets/import_intervenciones_form.dart';
import 'package:registro_uci/features/intervenciones/presentation/widgets/intervenciones_list.dart';
import 'package:registro_uci/features/intervenciones/presentation/widgets/components/buttons/intervenciones_floating_button.dart';
import 'package:registro_uci/features/necesidades/presentation/widgets/components/create_necesidad_form.dart';

// pagina que muestra las intervenciones de enfermeria de un registro
class IntervencionesPage extends ConsumerWidget {
  // id del ingreso al que pertenece el registro
  final String idIngreso;
  // id del registro
  final String idRegistro;
  // firma del reporte, si ya esta firmado
  final Firma? firma;

  // constructor, requiere el id del ingreso y del registro, la firma es opcional
  const IntervencionesPage({
    super.key,
    required this.idIngreso,
    required this.idRegistro,
    this.firma,
  });

  @override
  Widget build(BuildContext context, ref) {
    final params = ReporteParams(idIngreso: idIngreso, idRegistro: idRegistro);

    // obtiene el rol del usuario actual
    final role = ref.watch(roleProvider);
    // permite firmar solo si no hay firma y el usuario es admin
    final canSign = firma == null && role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: Text("Lista de Necesidades")),
            const SizedBox(width: 10),
            BedProviderWidget(
              idIngreso: idIngreso,
              redirectable: true,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntervencionesList(
            idIngreso: idIngreso,
            idRegistro: idRegistro,
            readOnly: firma != null || role != UserRole.admin,
          ),
          canSign
              ? FirmarReporteButton(
                  params: params,
                  tipoFirma: "firmaNecesidades",
                )
              : firma != null
                  ? FirmaWidget(firma: firma!)
                  : const SizedBox()
        ],
      ),
      floatingActionButton: Visibility(
        visible: role == UserRole.admin && firma == null,
        child: IntervencionesFloatingButton(
          // onCreate: () => showCreateNecesidadDialog(context, params),
          onImport: () => showImportNecesidadDialog(context, params),
          onAdd: () => showAddIntervencionesDialog(context, params),
        ),
      ),
    );
  }

  // muestra un dialogo para crear una nueva necesidad
  void showCreateNecesidadDialog(BuildContext context, ReporteParams params) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: CreateNecesidadForm(params: params),
        );
      },
    );
  }

  // muestra un dialogo para importar intervenciones de otro registro
  void showImportNecesidadDialog(BuildContext context, ReporteParams params) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ImportIntervencionesForm(
            idIngreso: idIngreso,
            idRegistroToOmit: idRegistro,
          ),
        );
      },
    );
  }

  // muestra un dialogo para agregar intervenciones al registro
  void showAddIntervencionesDialog(BuildContext context, ReporteParams params) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AddIntervencionesForm(
            params: params,
          ),
        );
      },
    );
  }
}
