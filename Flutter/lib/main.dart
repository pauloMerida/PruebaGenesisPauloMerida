import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'services/api_service.dart';
import 'pages/productos_page.dart';
import 'pages/combos_page.dart';
import 'pages/venta_page.dart';

void main() {
  runApp(const CazuelaApp());
}

class CazuelaApp extends StatelessWidget {
  const CazuelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
      ],
      child: MaterialApp(
        title: 'La Cazuela Chapina',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: const HomePage(),
        routes: {
          '/productos': (_) => const ProductosPage(),
          '/combos': (_) => const CombosPage(),
          '/ventas/nuevo': (_) => const VentaPage(),
        },
      ),
    );
  }
}
