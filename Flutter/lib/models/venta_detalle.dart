class VentaDetalle {
  final int ventaDetalleID;
  final String ventaID;
  final int productoID;
  final double cantidad;
  final double precioUnitario;
  final String? atributosSeleccionados;

  VentaDetalle({
    required this.ventaDetalleID,
    required this.ventaID,
    required this.productoID,
    required this.cantidad,
    required this.precioUnitario,
    this.atributosSeleccionados,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) => VentaDetalle(
        ventaDetalleID: json['ventaDetalleID'],
        ventaID: json['ventaID'],
        productoID: json['productoID'],
        cantidad: (json['cantidad'] as num).toDouble(),
        precioUnitario: (json['precioUnitario'] as num).toDouble(),
        atributosSeleccionados: json['atributosSeleccionados'],
      );
}
