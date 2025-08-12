import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class AtributosSelector extends StatefulWidget {
  final int productoID;
  final Function(Map<String,String>) onChanged;
  const AtributosSelector({super.key, required this.productoID, required this.onChanged});

  @override
  State<AtributosSelector> createState() => _AtributosSelectorState();
}

class _AtributosSelectorState extends State<AtributosSelector> {
  List atributos = [];
  Map<int, String> seleccion = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final api = Provider.of<ApiService>(context, listen: false);
    try {
      final data = await api.getProductoAtributos(widget.productoID);
      setState(() => atributos = data);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (atributos.isEmpty) return const SizedBox();
    return Column(
      children: atributos.map((a) => Padding(
        padding: const EdgeInsets.symmetric(vertical:4.0),
        child: Row(
          children: [
            Expanded(child: Text(a.nombre)),
            SizedBox(
              width: 150,
              child: DropdownButton<String>(
                value: seleccion[a.atributoID],
                hint: const Text('Selecciona'),
                items: a.opciones.map<DropdownMenuItem<String>>((o) => DropdownMenuItem<String>(value: o, child: Text(o))).toList(),
                onChanged: (v) {
                  setState(() => seleccion[a.atributoID] = v ?? '');
                  widget.onChanged(Map.fromEntries(seleccion.entries.map((e) => MapEntry(e.key.toString(), e.value))));
                },
              ),
            )
          ],
        ),
      )).toList(),
    );
  }
}
