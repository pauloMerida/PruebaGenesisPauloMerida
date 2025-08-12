import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/combo.dart';
import '../models/atributo.dart';

class ApiService {
  static const String API_BASE = 'http://10.0.2.2:5266/api';

  Future<List<Producto>> getProductos() async {
    final res = await http.get(Uri.parse('\$API_BASE/productos'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Producto.fromJson(e)).toList();
    }
    throw Exception('Error fetching productos');
  }

  Future<List<dynamic>> getCombos() async {
    final res = await http.get(Uri.parse('\$API_BASE/combos'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Error fetching combos');
  }

  Future<List<dynamic>> getComboItems(int comboId) async {
    final res = await http.get(Uri.parse('\$API_BASE/combos/\$comboId/items'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Error fetching combo items');
  }

  Future<List<AtributoProducto>> getProductoAtributos(int productoId) async {
    final res = await http.get(Uri.parse('\$API_BASE/productoatributos/producto/\$productoId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => AtributoProducto.fromJson(e)).toList();
    }
    throw Exception('Error fetching producto atributos');
  }

  Future<dynamic> createVenta(Map<String, dynamic> payload) async {
    final res = await http.post(Uri.parse('\$API_BASE/ventas'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload));
    if (res.statusCode == 201 || res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Error creating venta: ' + res.body);
  }

  Future<dynamic> askLLM(String prompt) async {
    final res = await http.post(Uri.parse('\$API_BASE/llm/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('LLM error: ' + res.body);
  }
}
