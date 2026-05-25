import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/data/providers/liquidos_eliminados_provider.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/domain/models/liquido_eliminado.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/presentation/controllers/delete_liquido_eliminado_controller.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/presentation/widgets/components/create_liquido_eliminado_form.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/presentation/widgets/components/liquido_eliminado_tile.dart';
import 'package:registro_uci/pages/balance_liquidos/providers.dart';

// pantalla que lista los liquidos eliminados para un balance especifico
class LiquidosEliminadosScreen extends ConsumerWidget {
  // parametros que incluyen id de ingreso, registro diario y balance
  final LiquidosEliminadosParams params;

  // constructor requiere los parametros del balance
  const LiquidosEliminadosScreen({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceParams = BalanceParams(
      idIngreso: params.idIngreso,
      idRegistroDiario: params.idRegistroDiario,
    );
    final balanceData = ref.watch(totalBalanceProvider(balanceParams));

    return Scaffold(
      appBar: AppBar(
        title: Text('Hora ${params.idBalanceLiquidos}:00'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.blue.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Hora ${params.idBalanceLiquidos}:00',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: balanceData.when(
              data: (data) {
                final totalAdministrados =
                    (data['totalAdministrados'] ?? 0).toInt();
                final totalEliminados = (data['totalEliminados'] ?? 0).toInt();
                final balance = (data['balance'] ?? 0).toInt();
                final isPositive = balance >= 0;
                final balanceColor = balance > 0
                    ? Colors.green
                    : balance < 0
                        ? Colors.red
                        : Colors.grey;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBalanceColumn(
                        'Admin.', '$totalAdministrados', Colors.green),
                    _buildBalanceColumn(
                        'Elim.', '$totalEliminados', Colors.orange),
                    _buildBalanceColumn(
                      'Balance',
                      '${isPositive ? '+' : ''}$balance',
                      balanceColor,
                      isBold: true,
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error'),
            ),
          ),
          Expanded(
            child: LiquidosEliminadosList(params: params),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: CreateLiquidoEliminadoForm(params: params),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // widget que muestra una columna con etiqueta y valor numerico del balance
  Widget _buildBalanceColumn(String label, String value, Color color,
      {bool isBold = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          '$value ml',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}

// widget que construye la lista de liquidos eliminados
class LiquidosEliminadosList extends ConsumerWidget {
  // parametros para obtener los liquidos eliminados
  final LiquidosEliminadosParams params;

  // constructor requiere los parametros
  const LiquidosEliminadosList({super.key, required this.params});

  // construye la lista de liquidos eliminados desde el provider
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liquidosAsync = ref.watch(liquidosEliminadosProvider(params));

    return liquidosAsync.when(
      data: (liquidos) {
        if (liquidos.isEmpty) {
          return const Center(child: Text('No hay líquidos eliminados'));
        }
        return ListView.builder(
          itemCount: liquidos.length,
          itemBuilder: (context, index) {
            final liquido = liquidos[index];
            return LiquidoEliminadoTile(
              liquido: liquido,
              onDeleteTap: () => _confirmDelete(context, ref, liquido),
            );
          },
        );
      },
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  // muestra dialogo de confirmacion y elimina un liquido eliminado
  void _confirmDelete(
      BuildContext context, WidgetRef ref, LiquidoEliminado liquido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Está seguro de eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final controller =
                    ref.read(deleteLiquidoEliminadoControllerProvider.notifier);
                await controller.deleteLiquidoEliminado(
                  params.idIngreso,
                  params.idRegistroDiario,
                  params.idBalanceLiquidos,
                  liquido.idLiquidoEliminado,
                );
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
