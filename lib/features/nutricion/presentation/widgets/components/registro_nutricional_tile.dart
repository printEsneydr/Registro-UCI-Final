import 'package:flutter/material.dart';
import 'package:registro_uci/features/nutricion/domain/models/registro_nutricional.dart';

// widget que muestra un registro nutricional en una tarjeta expandible
class RegistroNutricionalTile extends StatelessWidget {
  final RegistroNutricional registro;
  final VoidCallback onDeleteTap;

  // constructor que recibe el registro y el callback de eliminacion
  const RegistroNutricionalTile({
    super.key,
    required this.registro,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: const Icon(Icons.restaurant_menu, color: Colors.orange),
        title: Text('Hora: ${registro.hora.hour.toString().padLeft(2, '0')}:${registro.hora.minute.toString().padLeft(2, '0')}'),
        subtitle: Text('Vía: ${registro.via} | Total: ${registro.total?.toStringAsFixed(0) ?? "—"}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ANTROPOMETRÍA', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildRow('Peso', '${registro.peso} kg'),
                _buildRow('Talla', '${registro.talla} cm'),
                _buildRow('IMC', registro.imc.toStringAsFixed(1)),
                _buildRow('Req. Calórico', '${registro.requerimientoCalorico.toStringAsFixed(0)} kcal'),
                const Divider(),
                const Text('DISTRIBUCIÓN CALÓRICA', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (registro.proteinas != null) _buildRow('Proteínas', '${registro.proteinas!.toStringAsFixed(0)}%'),
                if (registro.lipidos != null) _buildRow('Lípidos', '${registro.lipidos!.toStringAsFixed(0)}%'),
                if (registro.carbohidratos != null) _buildRow('Carbohidratos', '${registro.carbohidratos!.toStringAsFixed(0)}%'),
                if (registro.observaciones != null && registro.observaciones!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Observaciones: ${registro.observaciones}', style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDeleteTap),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // construye una fila con label y valor para mostrar datos antropometricos
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(value)]),
    );
  }
}
