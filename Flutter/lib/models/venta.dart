class Venta {
  final String ventaID;
  final int sucursalID;
  final DateTime fechaVenta;
  final double total;
  final String estado;
  final bool esOffline;

  Venta({
    required this.ventaID,
    required this.sucursalID,
    required this.fechaVenta,
    required this.total,
    required this.estado,
    required this.esOffline,
  });

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        ventaID: json['ventaID'],
        sucursalID: json['sucursalID'],
        fechaVenta: DateTime.parse(json['fechaVenta']),
        total: (json['total'] as num).toDouble(),
        estado: json['estado'],
        esOffline: json['esOffline'],
      );
}
