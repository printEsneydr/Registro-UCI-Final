import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/balance_liquidos/balance_liquidos_administrados/domain/models/liquido_administrado.dart';

// widget que muestra un liquido administrado en una tarjeta con acciones
class LiquidoAdministradoTile extends ConsumerWidget {
  // modelo del liquido y callbacks para ver detalle, editar y eliminar
  final LiquidoAdministrado liquido;
  final VoidCallback onDetailsTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const LiquidoAdministradoTile({
    super.key,
    required this.liquido,
    required this.onDetailsTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  // construye el tile con icono segun si es tratamiento, y acciones segun el rol
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final isAdmin = role == UserRole.admin;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: liquido.esTratamiento
            ? const Icon(Icons.medication, color: Colors.red)
            : const Icon(Icons.local_drink),
        title: Text(liquido.medicamento),
        subtitle: Text("${liquido.cantidad} ml - ${liquido.hora.hour}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.info), onPressed: onDetailsTap),
            if (isAdmin)
              IconButton(icon: const Icon(Icons.edit), onPressed: onEditTap),
            if (isAdmin)
              IconButton(icon: const Icon(Icons.delete), onPressed: onDeleteTap),
          ],
        ),
      ),
    );
  }
}
