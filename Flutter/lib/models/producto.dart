class Producto {
  final int productoID;
  final String nombre;
  final double precioBase;
  final int categoriaID;
  final String? unidadMedida;

  Producto({required this.productoID, required this.nombre, required this.precioBase, required this.categoriaID, this.unidadMedida});

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    productoID: json['productoID'] ?? json['productoId'] ?? 0,
    nombre: json['nombre'] ?? '',
    precioBase: (json['precioBase'] ?? 0).toDouble(),
    categoriaID: json['categoriaID'] ?? json['categoriaId'] ?? 0,
    unidadMedida: json['unidadMedida']
  );
}
