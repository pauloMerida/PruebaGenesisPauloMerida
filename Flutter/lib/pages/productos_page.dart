import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/producto.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  List<Producto> productos = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    final api = Provider.of<ApiService>(context, listen: false);
    final data = await api.getProductos();
    setState(() { productos = data; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, i) {
          final p = productos[i];
          return ListTile(
            title: Text(p.nombre),
            subtitle: Text('Q\${p.precioBase.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
