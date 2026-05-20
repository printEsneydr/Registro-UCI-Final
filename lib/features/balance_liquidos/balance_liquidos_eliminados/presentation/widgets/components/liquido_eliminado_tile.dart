import 'package:flutter/material.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_eliminados/domain/models/liquido_eliminado.dart';

class LiquidoEliminadoTile extends StatelessWidget {
  final LiquidoEliminado liquido;
  final VoidCallback onDeleteTap;

  const LiquidoEliminadoTile({
    super.key,
    required this.liquido,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final total = liquido.orina +
        liquido.perdidasInsensibles +
        liquido.sondaGastrica +
        liquido.residuoGastrico +
        liquido.tuboTorax1 +
        liquido.tuboTorax2 +
        liquido.tuboMediastino +
        liquido.drenAbdominal +
        liquido.ileostomia +
        liquido.fistulaEnterocutanea +
        liquido.deposicion +
        liquido.dialisis +
        liquido.ventriculosTomaExterna +
        liquido.otros +
        liquido.campoLibre1 +
        liquido.campoLibre2;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: const Icon(Icons.delete_outline, color: Colors.red),
        title: Text('Hora: ${liquido.hora.hour}:00'),
        subtitle: Text('Total: $total ml'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Diuresis / Orina', liquido.orina),
                _buildRow('Pérdidas Insensibles', liquido.perdidasInsensibles),
                _buildRow('Sonda Gástrica', liquido.sondaGastrica),
                _buildRow('Residuo Gástrico', liquido.residuoGastrico),
                _buildRow('Tubo Tórax 1', liquido.tuboTorax1),
                _buildRow('Tubo Tórax 2', liquido.tuboTorax2),
                _buildRow('Tubo Mediastino', liquido.tuboMediastino),
                _buildRow('Dren Abdominal', liquido.drenAbdominal),
                _buildRow('Ileostomía', liquido.ileostomia),
                _buildRow('Fístula Enterocutánea', liquido.fistulaEnterocutanea),
                _buildRow('Deposición', liquido.deposicion),
                _buildRow('Diálisis', liquido.dialisis),
                _buildRow('Ventrículos Toma Externa', liquido.ventriculosTomaExterna),
                _buildRow('Otros', liquido.otros),
                _buildRow('Campo Libre 1', liquido.campoLibre1),
                _buildRow('Campo Libre 2', liquido.campoLibre2),
                if (liquido.comentario != null &&
                    liquido.comentario!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Comentario: ${liquido.comentario}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDeleteTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('$value ml'),
        ],
      ),
    );
  }
}
