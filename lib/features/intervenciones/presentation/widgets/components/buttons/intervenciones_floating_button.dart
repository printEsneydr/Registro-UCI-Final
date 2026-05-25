import 'package:flutter/material.dart';

// boton flotante con menu para agregar o importar intervenciones
class IntervencionesFloatingButton extends StatelessWidget {
  // constructor de IntervencionesFloatingButton
  const IntervencionesFloatingButton({
    super.key,
    // required this.onCreate,
    required this.onImport,
    required this.onAdd,
  });

  // final VoidCallback onCreate;
  final VoidCallback onImport;
  final VoidCallback onAdd;

  // construye el popup menu con las opciones agregar e importar
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'importar':
            onImport();
            break;
          case 'agregar':
            onAdd();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'agregar',
            child: Text('Agregar necesidades'),
          ),
          const PopupMenuItem<String>(
            value: 'importar',
            child: Text('Importar necesidades'),
          ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
