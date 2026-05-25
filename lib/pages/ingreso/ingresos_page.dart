import 'package:flutter/material.dart';
import 'package:registro_uci/features/auth/presentation/widgets/components/buttons/logout_icon_button.dart';
import 'package:registro_uci/features/ingresos/presentation/widgets/components/buttons/create_ingreso_floating_button.dart';
import 'package:registro_uci/features/ingresos/presentation/widgets/ingresos_list_widget.dart';

// pagina que lista todos los ingresos con busqueda
class IngresosPage extends StatefulWidget {
  const IngresosPage({super.key});

  @override
  State<IngresosPage> createState() => _IngresosPageState();
}

// estado de la pagina de ingresos, maneja el controlador de busqueda
class _IngresosPageState extends State<IngresosPage> {
  // controlador para el campo de texto de busqueda
  final TextEditingController _searchController = TextEditingController();

  // libera el controlador al destruir el widget
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // construye la pantalla con barra de busqueda y lista de ingresos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Ingresos"),
        actions: const [
          LogoutIconButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar paciente por nombre o identificación...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: IngresosListWidget(searchQuery: _searchController.text),
          ),
        ],
      ),
      floatingActionButton: const CreateIngresoFAB(),
    );
  }
}
