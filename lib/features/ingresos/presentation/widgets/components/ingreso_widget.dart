import 'package:flutter/material.dart';
//import 'package:registro_uci/common/components/bed_widget.dart';
import 'package:registro_uci/common/components/tappable_container.dart';
import 'package:registro_uci/features/ingresos/domain/models/ingreso.dart';
import 'package:registro_uci/pages/ingreso/ingreso_page.dart';

class IngresoWidget extends StatelessWidget {
  final Ingreso ingreso;
  const IngresoWidget({
    super.key,
    required this.ingreso,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = ingreso.fechaFin == null;
    final int dias =
        _calculateDaysPassed(ingreso.fechaIngreso, ingreso.fechaFin);
    final int folio = dias + 1; // 📌 Folio empieza en 1 cuando los días son 0

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TappableContainer(
        padding: 15,
        backgroundColor: isActive ? null : Colors.grey.shade100,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return IngresoPage(idIngreso: ingreso.idIngreso);
            },
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ingreso.nombrePaciente.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        isActive ? Colors.green.shade100 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? Icons.play_circle : Icons.check_circle,
                        size: 16,
                        color: isActive
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isActive ? "Activo" : "Terminado",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.green.shade700
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Edad: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: ingreso.fechaNacimientoPaciente != null
                        ? _calculateAge(ingreso.fechaNacimientoPaciente!)
                        : 'Desconocido',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Diagnóstico: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: ingreso.diagnosticoActual,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            /// **Sección de iconos alineados a la izquierda**
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bed, color: Colors.white, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        ingreso.cama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                /// 📌 Contenedor para los días
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        isActive ? Colors.blue.shade400 : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        "Días: $dias",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    width: 10), // 📌 Espacio entre los dos contenedores

                /// 📌 Contenedor para el folio
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.purple
                        .shade400, // Puedes cambiar el color si lo deseas
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.receipt, color: Colors.white, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        "Folio: $folio",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return '$age años';
  }

  /// **Días empiezan en 0, pero Folio empieza en 1**
  int _calculateDaysPassed(DateTime fechaIngreso, DateTime? fechaFin) {
    final currentDate = DateTime.now();
    if (fechaFin == null) return currentDate.difference(fechaIngreso).inDays;
    return fechaFin.difference(fechaIngreso).inDays;
  }
}
