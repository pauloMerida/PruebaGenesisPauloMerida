import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/producto.dart';
import '../widgets/atributos_selector.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VentaPage extends StatefulWidget {
  const VentaPage({super.key});

  @override
  State<VentaPage> createState() => _VentaPageState();
}

class _VentaPageState extends State<VentaPage> {
  List<Producto> productos = [];
  List cart = [];
  int selectedSucursal = 0;
  List sucursales = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final api = Provider.of<ApiService>(context, listen: false);
    productos = await api.getProductos();
    // we assume an endpoint /sucursales exists; if not, mock one
    try {
      final res = await api.getSucursales();
      sucursales = res;
    } catch (_) {
      sucursales = [{'sucursalID':1,'nombre':'Principal'}];
    }
    setState((){});
  }

  void addToCart(Producto p) {
    final idx = cart.indexWhere((c) => c['productoID'] == p.productoID);
    if (idx >= 0) cart[idx]['cantidad'] += 1;
    else cart.add({'productoID': p.productoID, 'nombre': p.nombre, 'precioBase': p.precioBase, 'cantidad':1, 'atributosSeleccionados':{}});
    setState((){});
  }

  void removeFromCart(int productoID) {
    cart.removeWhere((c) => c['productoID'] == productoID);
    setState((){});
  }

  Future<void> submit() async {
    if (selectedSucursal == 0) {
      Fluttertoast.showToast(msg: 'Selecciona sucursal');
      return;
    }
    final venta = {'sucursalID': selectedSucursal, 'total': cart.fold(0, (t,c)=> t + c['precioBase']*c['cantidad']), 'estado':'Pendiente', 'esOffline': false};
    final detalles = cart.map((c) => {
      'productoID': c['productoID'],
      'cantidad': c['cantidad'],
      'precioUnitario': c['precioBase'],
      'atributosSeleccionados': jsonEncode(c['atributosSeleccionados'])
    }).toList();
    final payload = {'venta': venta, 'detalles': detalles};
    final api = Provider.of<ApiService>(context, listen: false);
    try {
      await api.createVenta(payload);
      Fluttertoast.showToast(msg: 'Venta registrada');
      cart.clear();
      setState((){});
    } catch (e) {
      // save to queue
      final prefs = await SharedPreferences.getInstance();
      final q = prefs.getStringList('ventas_queue') ?? [];
      q.add(jsonEncode(payload));
      await prefs.setStringList('ventas_queue', q);
      Fluttertoast.showToast(msg: 'Guardado offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Venta')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            DropdownButton<int>(
              value: selectedSucursal == 0 ? null : selectedSucursal,
              hint: const Text('Selecciona sucursal'),
              items: sucursales.map<DropdownMenuItem<int>>((s) => DropdownMenuItem<int>(value: s['sucursalID'], child: Text(s['nombre']))).toList(),
              onChanged: (v) => setState(() => selectedSucursal = v ?? 0),
            ),
            const SizedBox(height: 8),
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        children: productos.map((p) => ListTile(
                          title: Text(p.nombre),
                          subtitle: Text('Q\${p.precioBase.toStringAsFixed(2)}'),
                          trailing: ElevatedButton(onPressed: () => addToCart(p), child: const Text('Agregar')),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 360,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text('Carrito', style: TextStyle(fontSize: 18)),
                              const SizedBox(height: 8),
                              Expanded(child: ListView(
                                children: cart.map((c) => Column(
                                  children: [
                                    ListTile(
                                      title: Text(c['nombre']),
                                      subtitle: Text('x\${c['cantidad']}  Q\${(c['precioBase']*c['cantidad']).toStringAsFixed(2)}'),
                                      trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => removeFromCart(c['productoID'])),
                                    ),
                                    // atributos selector
                                    AtributosSelector(productoID: c['productoID'], onChanged: (map) { c['atributosSeleccionados'] = map; })
                                  ],
                                )).toList(),
                              )),
                              ElevatedButton(onPressed: submit, child: const Text('Registrar Venta'))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
