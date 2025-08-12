import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/combo.dart';
import '../widgets/combo_editor.dart';

class CombosPage extends StatefulWidget {
  const CombosPage({super.key});

  @override
  State<CombosPage> createState() => _CombosPageState();
}

class _CombosPageState extends State<CombosPage> {
  List<Combo> combos = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    final api = Provider.of<ApiService>(context, listen: false);
    final data = await api.getCombos();
    setState(() { combos = data.map<Combo>((e) => Combo.fromJson(e)).toList(); loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Combos')),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: combos.length,
        itemBuilder: (context, i) {
          final c = combos[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.descripcion ?? 'Combo \${c.comboID}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...c.items.map((it) => ListTile(
                    title: Text(it.productoNombre ?? 'ID \${it.productoID}'),
                    trailing: Text('x\${it.cantidad.toStringAsFixed(0)}'),
                  ))
                ],
              ),
            )
          );
        },
      ),
    );
  }
}
