class AtributoProducto {
  final int productoAtributoID;
  final int atributoID;
  final String nombre;
  final List<String> opciones;
  final double costoAdicional;

  AtributoProducto({required this.productoAtributoID, required this.atributoID, required this.nombre, required this.opciones, required this.costoAdicional});

  factory AtributoProducto.fromJson(Map<String, dynamic> json) {
    List<String> options = [];
    if (json['opciones'] != null) {
      options = List<String>.from(json['opciones']);
    } else if (json['valor'] != null) {
      options = (json['valor'] as String).split(',').map((s) => s.trim()).toList();
    }
    return AtributoProducto(
      productoAtributoID: json['productoAtributoID'] ?? 0,
      atributoID: json['atributoID'] ?? json['atributoId'] ?? 0,
      nombre: json['nombre'] ?? json['nombreAtributo'] ?? '',
      opciones: options,
      costoAdicional: (json['costoAdicional'] ?? 0).toDouble(),
    );
  }
}
