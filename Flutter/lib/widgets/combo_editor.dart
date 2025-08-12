import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class ComboEditor extends StatefulWidget {
  final int comboId;
  const ComboEditor({super.key, required this.comboId});

  @override
  State<ComboEditor> createState() => _ComboEditorState();
}

class _ComboEditorState extends State<ComboEditor> {
  List items = [];
  List productos = [];
  int selectedProducto = 0;
  int cantidad = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    final api = Provider.of<ApiService>(context, listen: false);
    items = await api.getComboItems(widget.comboId);
    productos = await api.getProductos();
    setState(() => loading = false);
  }

  Future<void> addItem() async {
    final api = Provider.of<ApiService>(context, listen: false);
    if (selectedProducto == 0) return;
    await api.addComboItem(widget.comboId, {'productoID': selectedProducto, 'cantidad': cantidad});
    await load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: DropdownButton<int>(
            value: selectedProducto == 0 ? null : selectedProducto,
            hint: const Text('Selecciona producto'),
            items: productos.map<DropdownMenuItem<int>>((p) => DropdownMenuItem<int>(value: p['productoID'], child: Text(p['nombre']))).toList(),
            onChanged: (v) => setState(() => selectedProducto = v ?? 0),
          )),
          const SizedBox(width: 8),
          SizedBox(width: 80, child: TextField(
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: '$cantidad'),
            onChanged: (v) => cantidad = int.tryParse(v) ?? 1,
          )),
          ElevatedButton(onPressed: addItem, child: const Text('Agregar'))
        ]),
        const SizedBox(height: 8),
        ...items.map((it) => ListTile(
          title: Text(it['productoNombre'] ?? 'ID \${it['productoID']}'),
          subtitle: Text('x\${it['cantidad']}'),
        ))
      ],
    );
  }
}
