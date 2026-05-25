import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_uci/common/components/buttons/secondary_button.dart';
import 'package:registro_uci/features/auth/data/providers/user_role_provider.dart';
import 'package:registro_uci/features/auth/domain/enums/user_role.dart';
import 'package:registro_uci/features/ingresos/data/providers/ingreso_by_id_provider.dart';
import 'package:registro_uci/features/ingresos/domain/models/ingreso.dart';
import 'package:registro_uci/pages/ingreso/update_ingreso_page.dart';

// pagina que muestra los detalles completos de un ingreso
class IngresoDetailsPage extends ConsumerWidget {
  // identificador del ingreso
  final String idIngreso;

  const IngresoDetailsPage({
    super.key,
    required this.idIngreso,
  });

  // construye la pantalla con la informacion del paciente y boton de editar
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // verifica si el usuario es admin para mostrar boton de editar
    final role = ref.watch(roleProvider);
    final isAdmin = role == UserRole.admin;
    // obtiene los datos del ingreso
    final ingreso = ref.watch(ingresoByIdProvider(idIngreso));

    return ingreso.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Detalles de Ingreso",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Patient Info Header with Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.7, // 📌 Limita el ancho máximo del texto
                        child: Text(
                          data!.nombrePaciente.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        18, // 📌 Reduce el tamaño de la fuente
                                  ),
                          maxLines:
                              2, // 📌 Permite hasta 2 líneas antes de cortar
                          overflow: TextOverflow
                              .ellipsis, // 📌 Si es demasiado largo, muestra "..."
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Identificación: ${data.identificacionPaciente}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                  Icon(Icons.person_outline,
                      size: 60, color: Theme.of(context).colorScheme.primary),
                ],
              ),
              const SizedBox(height: 20),
              // Action Button (Edit Ingreso)
              if (isAdmin)
                Row(
                  children: [
                    SecondaryButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 10),
                          const Text("Editar ingreso"),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpdateIngresoPage(ingreso: data),
                        ));
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              // Details List with Icons
              _buildDetailTile(
                label: 'Fecha de Nacimiento',
                icon: Icons.cake_outlined,
                data: data.fechaNacimientoPaciente != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(data.fechaNacimientoPaciente!)
                    : "Desconocido",
                context: context,
              ),
              _buildDetailTile(
                label: 'E.P.S. o ARL',
                icon: Icons.local_hospital_outlined,
                data: data.epsOArl,
                context: context,
              ),
              _buildDetailTile(
                label: 'Carpeta',
                icon: Icons.folder_outlined,
                context: context,
                data: data.carpeta,
              ),
              _buildDetailTile(
                label: 'Fecha de Ingreso',
                icon: Icons.event_outlined,
                data: DateFormat('dd/MM/yyyy').format(data.fechaIngreso),
                context: context,
              ),
              _buildDetailTile(
                label: 'Nombre Familiar',
                icon: Icons.family_restroom_outlined,
                context: context,
                data: data.nombreFamiliar,
              ),
              _buildDetailTile(
                label: 'Parentesco Familiar',
                icon: Icons.people_outline,
                context: context,
                data: data.parentescoFamiliar,
              ),
              _buildDetailTile(
                label: 'Teléfono Familiar',
                icon: Icons.phone_outlined,
                context: context,
                data: data.telefonoFamiliar,
              ),
              _buildDetailTile(
                label: 'Diagnóstico Ingreso',
                icon: Icons.note_alt_outlined,
                context: context,
                data: data.diagnosticoIngreso,
              ),
              _buildDetailTile(
                label: 'Diagnóstico Actual',
                icon: Icons.local_hospital_outlined,
                context: context,
                data: data.diagnosticoActual,
              ),
              _buildDetailTile(
                label: 'Peso',
                icon: Icons.monitor_weight_outlined,
                context: context,
                data: '${data.peso.toString()} kg',
              ),
              _buildDetailTile(
                label: 'Talla',
                icon: Icons.height_outlined,
                context: context,
                data: '${data.talla.toString()} cm',
              ),
              _buildDetailTile(
                label: 'Cama',
                icon: Icons.bed_outlined,
                context: context,
                data: data.cama,
              ),
              _buildDetailTile(
                label: 'Sala',
                icon: Icons.meeting_room_outlined,
                context: context,
                data: data.sala.salaToString(),
              ),
              _buildDetailTile(
                label: 'Alergias',
                icon: Icons.warning_amber_outlined,
                context: context,
                data: data.alergias ?? "Ninguna",
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  // crea una fila con icono, etiqueta y valor para mostrar un detalle
  Widget _buildDetailTile({
    required String label,
    required IconData icon,
    required String data,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'PlusJakartaSans',
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: data,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
