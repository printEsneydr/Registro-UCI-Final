import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/features/ingresos/data/providers/ingresos_by_sala_provider.dart';
import 'package:registro_uci/features/ingresos/presentation/widgets/components/ingreso_widget.dart';
import 'package:registro_uci/common/components/form_fields/dropdown_button_form_field.dart';
import 'package:registro_uci/features/ingresos/domain/models/ingreso.dart';

enum IngresoFilter { activos, terminados, todos }

class IngresosListWidget extends ConsumerStatefulWidget {
  const IngresosListWidget({super.key});

  @override
  ConsumerState<IngresosListWidget> createState() => _IngresosListWidgetState();
}

class _IngresosListWidgetState extends ConsumerState<IngresosListWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Sala selectedSala = Sala.A;
  IngresoFilter filter = IngresoFilter.activos;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          filter = IngresoFilter.values[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: EnumDropdownButtonFormField(
            onSelected: (sala) {
              setState(() {
                selectedSala = Sala.values.firstWhere((s) => s.name == sala);
              });
            },
            label: "Filtrar por Sala",
            value: selectedSala.name,
            values: Sala.values.map((sala) => sala.name).toList(),
            prefixIcon: const Icon(Icons.filter_list),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Buscar por nombre...",
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
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(
              icon: Icon(Icons.play_circle_outline),
              text: "Activos",
            ),
            Tab(
              icon: Icon(Icons.check_circle_outline),
              text: "Terminados",
            ),
            Tab(
              icon: Icon(Icons.list),
              text: "Todos",
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              IngresosList(
                  selectedSala: selectedSala,
                  filter: IngresoFilter.activos,
                  searchQuery: _searchController.text),
              IngresosList(
                  selectedSala: selectedSala,
                  filter: IngresoFilter.terminados,
                  searchQuery: _searchController.text),
              IngresosList(
                  selectedSala: selectedSala,
                  filter: IngresoFilter.todos,
                  searchQuery: _searchController.text),
            ],
          ),
        ),
      ],
    );
  }
}

class IngresosList extends ConsumerWidget {
  final Sala selectedSala;
  final IngresoFilter filter;
  final String searchQuery;

  const IngresosList({
    required this.selectedSala,
    required this.filter,
    this.searchQuery = "",
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingresos = ref.watch(ingresosBySalaProvider(selectedSala));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(ingresosBySalaProvider(selectedSala));
      },
      child: ingresos.when(
        data: (data) {
          final filteredIngresos = _filterIngresos(data);

          if (filteredIngresos.isEmpty) {
            final isSearching = searchQuery.isNotEmpty;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSearching
                        ? Icons.search_off
                        : filter == IngresoFilter.activos
                            ? Icons.person_off
                            : filter == IngresoFilter.terminados
                                ? Icons.check_circle_outline
                                : Icons.inbox,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSearching
                        ? "No se encontraron pacientes"
                        : filter == IngresoFilter.activos
                            ? "No hay ingresos activos"
                            : filter == IngresoFilter.terminados
                                ? "No hay ingresos terminados"
                                : "No hay ingresos",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: filteredIngresos.length,
            itemBuilder: (context, index) {
              return IngresoWidget(ingreso: filteredIngresos[index]);
            },
          );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text("Error: ${error.toString()}"),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        skipLoadingOnRefresh: false,
      ),
    );
  }

  List<Ingreso> _filterIngresos(List<Ingreso> ingresos) {
    var filtered = ingresos;

    switch (filter) {
      case IngresoFilter.activos:
        filtered = filtered.where((i) => i.fechaFin == null).toList();
        break;
      case IngresoFilter.terminados:
        filtered = filtered.where((i) => i.fechaFin != null).toList();
        break;
      case IngresoFilter.todos:
        break;
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where((i) =>
              i.nombrePaciente.toLowerCase().contains(query) ||
              i.identificacionPaciente.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }
}
