import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/components/bed_widget.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/firmas/domain/models/firma.dart';
import 'package:registro_uci/features/firmas/domain/models/reporte_params.dart';
import 'package:registro_uci/features/firmas/presentation/widgets/components/buttons/firmar_reporte_button.dart';
import 'package:registro_uci/features/firmas/presentation/widgets/components/firma_widget.dart';
import 'package:registro_uci/features/necesidades/presentation/widgets/necesidades_list.dart';

class NecesidadesPage extends ConsumerWidget {
  final String idIngreso;
  final String idRegistro;
  final Firma? firma;

  const NecesidadesPage({
    super.key,
    required this.idIngreso,
    required this.idRegistro,
    this.firma,
  });

  @override
  Widget build(BuildContext context, ref) {
    final params = ReporteParams(idIngreso: idIngreso, idRegistro: idRegistro);

    final role = ref.watch(roleProvider);

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
          NecesidadesList(
            idIngreso: idIngreso,
            idRegistro: idRegistro,
            readOnly: firma != null,
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
    );
  }
}
