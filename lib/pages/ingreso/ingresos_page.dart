import 'package:flutter/material.dart';
import 'package:registro_uci/features/auth/presentation/widgets/components/buttons/logout_icon_button.dart';
import 'package:registro_uci/features/ingresos/presentation/widgets/components/buttons/create_ingreso_floating_button.dart';
import 'package:registro_uci/features/ingresos/presentation/widgets/ingresos_list_widget.dart';

class IngresosPage extends StatefulWidget {
  const IngresosPage({super.key});

  @override
  State<IngresosPage> createState() => _IngresosPageState();
}

class _IngresosPageState extends State<IngresosPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Buscar paciente...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {});
                },
              )
            : const Text("Lista de Ingresos"),
        actions: const [
          LogoutIconButton(),
        ],
      ),
      body: IngresosListWidget(searchQuery: _searchController.text),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'search',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
            backgroundColor: _isSearching
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.secondary,
            child: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const CreateIngresoFAB(),
        ],
      ),
    );
  }
}
