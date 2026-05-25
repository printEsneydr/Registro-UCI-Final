// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/dto/create_liquido_administrado_dto.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/providers/liquidos_administrados_provider.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/data/providers/tratamientos_antibioticos_activos_provider.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/domain/models/liquido_administrado.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/controllers/create_many_liquidos_administrados_controller.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/widgets/components/add_liquidos_administrados_from_tratamiento_form.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/widgets/components/confirm_delete_liquido_administrado_form.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/widgets/components/create_liquido_administrado_form.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/widgets/components/liquido_administrado_tile.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/widgets/components/update_liquido_administrado_form.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/presentation/widgets/liquido_administrado_details_dialog.dart';

// pantalla que lista los liquidos administrados para un balance especifico
class LiquidosAdministradosScreen extends ConsumerWidget {
  // parametros que incluyen id de ingreso, registro diario y balance
  final LiquidosAdministradosParams params;

  // constructor requiere los parametros del balance
  const LiquidosAdministradosScreen({super.key, required this.params});

  // construye la pantalla con la lista de liquidos administrados
  @override
  Widget build(BuildContext context, ref) {
    final liquidos = ref.watch(liquidosAdministradosProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquidos Administrados'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, size: 28),
                const SizedBox(width: 8),
                Text(
                  'Hora ${params.idBalanceLiquidos}:00',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Fecha: ${params.idRegistroDiario}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: liquidos.when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final liquido = data[index];
                    return LiquidoAdministradoTile(
                      liquido: liquido,
                      onDetailsTap: () => _showLiquidoDetails(context, liquido),
                      onEditTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: UpdateLiquidoAdministradoForm(
                                params: params,
                                liquidoAdministrado: liquido,
                              ),
                            );
                          },
                        );
                      },
                      onDeleteTap: () => _showConfirmDelete(
                        context,
                        params,
                        liquido,
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFabMenu(context),
    );
  }

  // muestra dialogo con los detalles de un liquido administrado
  void _showLiquidoDetails(BuildContext context, LiquidoAdministrado liquido) {
    showDialog(
      context: context,
      builder: (context) => LiquidoAdministradoDetailsDialog(liquido: liquido),
    );
  }

  // muestra dialogo de confirmacion para eliminar un liquido administrado
  void _showConfirmDelete(
    BuildContext context,
    LiquidosAdministradosParams params,
    LiquidoAdministrado liquido,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: ConfirmDeleteLiquidoAdministrado(
            idLiquidoAdministrado: liquido.idLiquidoAdministrado,
            params: params,
          ),
        );
      },
    );
  }

  // construye el menu flotante con opciones para agregar liquidos o tratamientos
  Widget _buildFabMenu(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Show options dialog for new actions
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Nuevo liquido administrado"),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: CreateLiquidoAdministradoForm(params: params),
                      );
                    },
                  );
                }, // Add functionality
              ),
              ListTile(
                leading: const Icon(Icons.medication),
                title: const Text("Tratamiento antibiotico"),
                onTap: () {
                  final dateString = params.idRegistroDiario;
                  final hourString = params.idBalanceLiquidos;
                  final dateParts = dateString.split('-');
                  final year = int.parse(dateParts[0]);
                  final month = int.parse(dateParts[1]);
                  final day = int.parse(dateParts[2]);
                  final hour = int.parse(hourString);

                  final idIngreso = params.idIngreso;
                  final hora = DateTime(year, month, day, hour);

                  showDialog(
                    context: context,
                    builder: (context) {
                      return Consumer(
                        builder: (context, ref, _) {
                          // Watch for active antibiotic treatments
                          final tratamientosAsyncValue = ref.watch(
                              getTratamientosAntibioticosActivosProvider(
                                  TratamientosAntibioticosActivosParams(
                                      idIngreso: idIngreso, hora: hora)));
                          final controller = ref.watch(
                              createManyLiquidosAdministradosControllerProvider
                                  .notifier);

                          // Holds selected treatments
                          final selectedTratamientos =
                              <CreateLiquidoAdministradoDto>{};

                          return AlertDialog(
                            title: const Text(
                                "Seleccione Tratamientos Antibioticos"),
                            content:
                                AddLiquidosAdministradosFromTratamientoForm(
                              idIngreso: idIngreso,
                              hora: hora,
                              idRegistroDiario: params.idRegistroDiario,
                              idBalanceLiquidos: params.idBalanceLiquidos,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb_rounded),
                title: const Text("Sugerencias"),
                onTap: () {}, // Add functionality
              ),
            ],
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
