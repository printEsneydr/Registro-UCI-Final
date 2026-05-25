// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/balance_liquidos/data/providers/balances_de_liquidos_provider.dart';
import 'package:registro_uci/pages/balance_liquidos/providers.dart';

// widget que muestra el resumen del balance de liquidos en una tarjeta
class BalanceCard extends ConsumerStatefulWidget {
  // id del ingreso del paciente
  final String idIngreso;
  // id del registro diario asociado
  final String idRegistroDiario;

  // constructor requiere id de ingreso y registro diario
  const BalanceCard({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  @override
  ConsumerState<BalanceCard> createState() => _BalanceCardState();
}

// estado del BalanceCard, maneja la hora seleccionada y carga de datos
class _BalanceCardState extends ConsumerState<BalanceCard> {
  // hora seleccionada para el balance parcial
  int _horaSeleccionada = 8;
  // indica si se estan cargando los datos iniciales
  bool _cargando = true;

  // genera la lista de horas disponibles de 8 a 24 y luego de 1 a 7
  List<int> _generarHoras() {
    final horas = <int>[];
    // Horas 8 a 24
    for (var i = 8; i <= 24; i++) {
      horas.add(i);
    }
    // Horas 1 a 7 (día siguiente)
    for (var i = 1; i <= 7; i++) {
      horas.add(i);
    }
    return horas;
  }

  // formatea la hora para mostrar en el dropdown
  String _formatHora(int hora) {
    if (hora <= 24) {
      return 'Hasta las $hora:00';
    } else {
      final horaReal = hora - 24;
      return 'Hasta las $horaReal:00 (día sig.)';
    }
  }

  // inicializa el estado y carga la hora calculada del registro diario
  @override
  void initState() {
    super.initState();
    _cargarHoraInicial();
  }

  // carga la hora hasta la que se ha calculado el total administrado
  Future<void> _cargarHoraInicial() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final doc = await firestore
          .collection('ingresos')
          .doc(widget.idIngreso)
          .collection('registrosDiarios')
          .doc(widget.idRegistroDiario)
          .get();
      final data = doc.data() ?? {};
      final horaCalculada =
          (data['totalAdministradoCalculatedUntil'] as num?)?.toInt() ?? 8;
      if (mounted) {
        setState(() {
          _horaSeleccionada = horaCalculada > 0 ? horaCalculada : 8;
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  // invalida los providers para recargar los datos del balance
  void _recargar() {
    ref.invalidate(totalBalanceProvider(BalanceParams(
      idIngreso: widget.idIngreso,
      idRegistroDiario: widget.idRegistroDiario,
    )));
    ref.invalidate(balancePorHoraProvider(BalancePorHoraParams(
      idIngreso: widget.idIngreso,
      idRegistroDiario: widget.idRegistroDiario,
      hora: _horaSeleccionada,
    )));
    ref.invalidate(balancesDeLiquidosProvider(BalancesDeLiquidosParams(
      idIngreso: widget.idIngreso,
      idRegistroDiario: widget.idRegistroDiario,
    )));
  }

  // construye la tarjeta con el balance, selector de hora y estado
  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final horasDisponibles = _generarHoras();
    final balancePorHoraParams = BalancePorHoraParams(
      idIngreso: widget.idIngreso,
      idRegistroDiario: widget.idRegistroDiario,
      hora: _horaSeleccionada,
    );

    final balanceHoraData =
        ref.watch(balancePorHoraProvider(balancePorHoraParams));

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance de Líquidos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _recargar,
                  tooltip: 'Recargar datos',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<int>(
                value: _horaSeleccionada,
                isExpanded: true,
                underline: const SizedBox(),
                items: horasDisponibles
                    .map((hora) => DropdownMenuItem(
                          value: hora,
                          child: Text(_formatHora(hora)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _horaSeleccionada = value;
                    });
                    ref.invalidate(balancePorHoraProvider(BalancePorHoraParams(
                      idIngreso: widget.idIngreso,
                      idRegistroDiario: widget.idRegistroDiario,
                      hora: value,
                    )));
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            balanceHoraData.when(
              data: (data) {
                final totalAdministrados =
                    (data['totalAdministrados'] as num?)?.toInt() ?? 0;
                final totalEliminados =
                    (data['totalEliminados'] as num?)?.toInt() ?? 0;
                final balance = (data['balance'] as num?)?.toInt() ?? 0;

                final isPositive = balance >= 0;
                final balanceColor = balance > 0
                    ? Colors.green
                    : balance < 0
                        ? Colors.red
                        : Colors.grey;

                final String estadoMensaje;
                if (balance > 200) {
                  estadoMensaje = '⚠️ Retención significativa';
                } else if (balance < -200) {
                  estadoMensaje = '⚠️ Pérdida significativa';
                } else if (balance > 0) {
                  estadoMensaje = '✓ Retención normal';
                } else if (balance < 0) {
                  estadoMensaje = '⚠️ Pérdida';
                } else {
                  estadoMensaje = '= Balanceado';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildColumn(
                            'Admin.', '$totalAdministrados', Colors.green),
                        _buildColumn(
                            'Elim.', '$totalEliminados', Colors.orange),
                        _buildColumn(
                          'Balance',
                          '${isPositive ? '+' : ''}$balance',
                          balanceColor,
                          isBold: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: balanceColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        estadoMensaje,
                        style: TextStyle(
                          color: balanceColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _formatHora(_horaSeleccionada),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(height: 8),
                      Text('Error: $error'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _recargar,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // columna con etiqueta y valor en ml para mostrar en el balance
  Widget _buildColumn(String label, String value, Color color,
      {bool isBold = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          '$value ml',
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
