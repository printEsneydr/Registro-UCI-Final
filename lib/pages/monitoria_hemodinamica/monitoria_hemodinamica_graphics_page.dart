import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/domain/models/monitoria_hemodinamica.dart';
import 'package:registro_uci/features/monitorias_hemodinamicas/data/providers/monitoria_hemodinamica_provider.dart';

class GraphicsPage extends ConsumerWidget {
  final String idIngreso;
  final String idRegistroDiario;

  const GraphicsPage({
    super.key,
    required this.idIngreso,
    required this.idRegistroDiario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitorización Hemodinámica'),
        elevation: 0,
      ),
      body: _buildBody(ref),
    );
  }

  Widget _buildBody(WidgetRef ref) {
    final monitoriasAsync = ref.watch(monitoriasHemodinamicasStreamProvider(
      ParametrosMonitoriaHemodinamica(
        idIngreso: idIngreso,
        idRegistroDiario: idRegistroDiario,
      ),
    ));

    return monitoriasAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (monitorias) {
        if (monitorias.isEmpty) {
          return const Center(child: Text('No hay datos registrados'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // GRÁFICOS DE PRESIÓN ARTERIAL
              _buildSectionTitle('Presión Arterial'),
              _buildLineChartCard(
                title: 'Presión Sistólica (PAS)',
                data: monitorias,
                getValue: (m) => m.pas?.toDouble(),
                color: Colors.red,
                unit: 'mmHg',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Presión Diastólica (PAD)',
                data: monitorias,
                getValue: (m) => m.pad?.toDouble(),
                color: Colors.blue,
                unit: 'mmHg',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Presión Media (PAM)',
                data: monitorias,
                getValue: (m) => m.pam?.toDouble(),
                color: Colors.purple,
                unit: 'mmHg',
              ),

              // GRÁFICOS DE SIGNOS VITALES BÁSICOS
              _buildSectionTitle('Signos Vitales'),
              _buildLineChartCard(
                title: 'Frecuencia Cardíaca (FC)',
                data: monitorias,
                getValue: (m) => m.fc?.toDouble(),
                color: Colors.green,
                unit: 'ppm',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Frecuencia Respiratoria (FR)',
                data: monitorias,
                getValue: (m) => m.fr?.toDouble(),
                color: Colors.teal,
                unit: 'rpm',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Temperatura',
                data: monitorias,
                getValue: (m) => m.t,
                color: Colors.orange,
                unit: '°C',
                decimalPlaces: 1,
              ),

              // GRÁFICOS DE OXIGENACIÓN
              _buildSectionTitle('Oxigenación'),
              _buildLineChartCard(
                title: 'Saturación de O₂',
                data: monitorias,
                getValue: (m) => m.saturacion?.toDouble(),
                color: Colors.blueAccent,
                unit: '%',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'FiO₂',
                data: monitorias,
                getValue: (m) => m.fio2?.toDouble(),
                color: Colors.lightBlue,
                unit: '%',
              ),

              // GRÁFICOS DE PRESIONES ESPECIALES
              _buildSectionTitle('Presiones Especiales'),
              _buildLineChartCard(
                title: 'Presión Venosa Central (PVC)',
                data: monitorias,
                getValue: (m) => m.pvc?.toDouble(),
                color: Colors.deepPurple,
                unit: 'mmHg',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Presión Intraabdominal (PIA)',
                data: monitorias,
                getValue: (m) => m.pia?.toDouble(),
                color: Colors.brown,
                unit: 'mmHg',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Presión Intracraneal (PIC)',
                data: monitorias,
                getValue: (m) => m.pic?.toDouble(),
                color: Colors.indigo,
                unit: 'mmHg',
              ),

              // GRÁFICOS METABÓLICOS
              _buildSectionTitle('Parámetros Metabólicos'),
              _buildLineChartCard(
                title: 'Glucometría',
                data: monitorias,
                getValue: (m) => m.glucometria?.toDouble(),
                color: Colors.pink,
                unit: 'mg/dL',
                minY: 0,
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Insulina',
                data: monitorias,
                getValue: (m) => m.insulina?.toDouble(),
                color: Colors.amber,
                unit: 'U',
                minY: 0,
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Resistencia Vascular Sistémica (RVS)',
                data: monitorias,
                getValue: (m) => m.rvc?.toDouble(),
                color: Colors.cyan,
                unit: 'dinas·s·cm⁻⁵',
                minY: 0,
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Presión de Perfusión Arterial (PPA)',
                data: monitorias,
                getValue: (m) => m.ppa?.toDouble(),
                color: Colors.red.shade700,
                unit: 'mmHg',
              ),
              const SizedBox(height: 20),
              _buildLineChartCard(
                title: 'Presión de Perfusión Cerebral (PPC)',
                data: monitorias,
                getValue: (m) => m.ppc?.toDouble(),
                color: Colors.deepOrange,
                unit: 'mmHg',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildLineChartCard({
    required String title,
    required List<MonitoriaHemodinamica> data,
    required double? Function(MonitoriaHemodinamica) getValue,
    required Color color,
    required String unit,
    int decimalPlaces = 0,
    double? minY,
  }) {
    final datosFiltrados = data.where((m) => getValue(m) != null).toList()
      ..sort((a, b) => a.hora.compareTo(b.hora));

    if (datosFiltrados.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
              'No hay datos registrados para $title'),
        ),
      );
    }

    final horas = datosFiltrados.map((m) => m.hora).toList();
    final minHora = horas.reduce((a, b) => a < b ? a : b);
    final maxHora = horas.reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minX: minHora.toDouble(),
                  maxX: maxHora.toDouble(),
                  minY: minY ?? _getMinY(title, datosFiltrados, getValue),
                  maxY: _calculateMaxY(datosFiltrados, getValue, minY),
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _calculateInterval(minHora, maxHora),
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${value.toInt()}h',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: datosFiltrados.map((m) {
                        return FlSpot(m.hora.toDouble(), getValue(m) ?? 0);
                      }).toList(),
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final hora = spot.x.toInt();
                          return LineTooltipItem(
                            '${hora}h: ${spot.y.toStringAsFixed(decimalPlaces)} $unit',
                            TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateInterval(int minHora, int maxHora) {
    final diff = maxHora - minHora;
    if (diff <= 6) return 1;
    if (diff <= 12) return 2;
    return 4;
  }

  double _getMinY(String title, List<MonitoriaHemodinamica> data, 
      double? Function(MonitoriaHemodinamica) getValue) {
    if (title.contains('Temperatura')) return 35;
    if (title.contains('Sat')) return 80;
    if (title.contains('FiO₂')) return 0;
    final values = data.map((m) => getValue(m) ?? 0).toList();
    if (values.isEmpty) return 0;
    final min = values.reduce((a, b) => a < b ? a : b);
    return (min * 0.8).clamp(0, double.infinity);
  }

  double _calculateMaxY(List<MonitoriaHemodinamica> data,
      double? Function(MonitoriaHemodinamica) getValue, double? minY) {
    final values = data.map((m) => getValue(m) ?? 0).toList();
    if (values.isEmpty) return 100;
    final max = values.reduce((a, b) => a > b ? a : b);
    
    if (minY != null) return max * 1.1;
    if (max <= 100) return 100;
    return max * 1.2;
  }
}
