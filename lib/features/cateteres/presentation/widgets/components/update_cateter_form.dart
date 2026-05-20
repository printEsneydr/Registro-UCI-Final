import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/components/buttons/primary_button.dart';
import 'package:registro_uci/features/cateteres/data/dto/update_cateter_dto.dart';
import 'package:registro_uci/features/cateteres/data/providers/cateteres_providers.dart';

class UpdateCateterFormButton extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final String idIngreso;
  final String idCateter;
  final TextEditingController tipoController;
  final TextEditingController viaController;
  final TextEditingController fechaInsercionController;
  final TextEditingController fechaRetiroController;
  final TextEditingController caracteristicasController;

  const UpdateCateterFormButton({
    super.key,
    required this.formKey,
    required this.idIngreso,
    required this.idCateter,
    required this.tipoController,
    required this.viaController,
    required this.fechaInsercionController,
    required this.fechaRetiroController,
    required this.caracteristicasController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Se obtiene la instancia con los parámetros correctos
    final futureProvider = actualizarCateterProvider((
      idIngreso: idIngreso,
      idCateter: idCateter,
      dto: UpdateCateterDto(
        tipo: tipoController.text.isNotEmpty ? tipoController.text : null,
        via: viaController.text.isNotEmpty ? viaController.text : null,
        fechaInsercion: fechaInsercionController.text.isNotEmpty
            ? _parseFecha(fechaInsercionController.text)
            : null,
        fechaRetiro: fechaRetiroController.text.isNotEmpty
            ? _parseFecha(fechaRetiroController.text)
            : null,
        caracteristicasSitioInsercion: caracteristicasController.text.isNotEmpty
            ? caracteristicasController.text
            : null,
      ),
    ));

    final estado = ref.watch(futureProvider);

    return PrimaryButton(
      onTap: estado.isLoading
          ? null
          : () async {
              if (formKey.currentState!.validate()) {
                try {
                  print(
                      "🛠️ Actualizando catéter ID: $idCateter en Ingreso: $idIngreso");

                  await ref.read(futureProvider.future);

                  // ✅ Forzar actualización en tiempo real
                  ref.invalidate(cateteresByIngresoProvider);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Catéter actualizado exitosamente."),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("⚠ Error al actualizar: $e")),
                    );
                  }
                }
              }
            },
      child: estado.when(
        data: (_) => const Text("ACTUALIZAR CATÉTER"),
        loading: () =>
            const CircularProgressIndicator(), // 🔄 Indica que está actualizando
        error: (error, _) =>
            Text("⚠ Error: $error", style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  /// 🔥 **Función para manejar fechas de forma segura**
  DateTime? _parseFecha(String fechaTexto) {
    try {
      return DateTime.parse(fechaTexto);
    } catch (e) {
      print("❌ Error al parsear fecha: $e");
      return null; // 🔄 Retorna null en caso de error
    }
  }
}
