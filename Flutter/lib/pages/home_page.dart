import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('La Cazuela Chapina')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Panel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/productos'), child: const Text('Productos')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/combos'), child: const Text('Combos')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/ventas/nuevo'), child: const Text('Registrar Venta')),
          ],
        ),
      ),
    );
  }
}
