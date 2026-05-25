import 'package:flutter/material.dart';

// pantalla de carga que muestra un indicador circular
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  // muestra un circulo de progreso en el centro de la pantalla
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
