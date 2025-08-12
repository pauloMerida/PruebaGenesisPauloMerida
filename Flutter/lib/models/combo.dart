class ComboItem {
  final int comboItemID;
  final int productoID;
  final String? productoNombre;
  final double cantidad;
  final double precioBase;

  ComboItem({required this.comboItemID, required this.productoID, this.productoNombre, required this.cantidad, required this.precioBase});

  factory ComboItem.fromJson(Map<String, dynamic> json) => ComboItem(
    comboItemID: json['comboItemID'] ?? 0,
    productoID: json['productoID'] ?? 0,
    productoNombre: json['productoNombre'] ?? json['nombre'] ?? null,
    cantidad: (json['cantidad'] ?? 0).toDouble(),
    precioBase: (json['precioBase'] ?? 0).toDouble(),
  );
}

class Combo {
  final int comboID;
  final String? descripcion;
  final bool esEstacional;
  final List<ComboItem> items;

  Combo({required this.comboID, this.descripcion, required this.esEstacional, required this.items});

  factory Combo.fromJson(Map<String, dynamic> json) => Combo(
    comboID: json['comboID'] ?? 0,
    descripcion: json['descripcion'],
    esEstacional: json['esEstacional'] ?? false,
    items: (json['productos'] ?? json['comboItems'] ?? []).map<ComboItem>((e) => ComboItem.fromJson(e)).toList()
  );
}
