import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:registro_uci/common/themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registro_uci/features/auth/data/providers/is_logged_in_provider.dart';
import 'package:registro_uci/pages/ingreso/ingresos_page.dart';
import 'package:registro_uci/pages/login_page.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// punto de entrada de la aplicacion
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Intl.defaultLocale = 'es_ES';
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

// widget principal de la app
// maneja el splash screen y la navegacion inicial
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// estado del widget MyApp
class _MyAppState extends State<MyApp> {
  // controla si se muestra la pantalla de splash
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  // simula carga inicial antes de mostrar la app
  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.local_hospital,
                      size: 100,
                      color: Colors.teal,
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
'Sabana UCI',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Sabana UCI',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      // redirige al login o a la pagina principal segun el estado de auth
      home: Consumer(
        builder: (context, ref, child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);
          ();
          if (isLoggedIn) {
            return const IngresosPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
