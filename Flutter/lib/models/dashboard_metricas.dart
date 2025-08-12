class DashboardMetricas {
  final String fecha;
  final double totalVentas;
  final int tamalesVendidos;
  final int bebidasVendidas;
  final double porcentajePicante;
  final double desperdicioMateriasPrimas;

  DashboardMetricas({
    required this.fecha,
    required this.totalVentas,
    required this.tamalesVendidos,
    required this.bebidasVendidas,
    required this.porcentajePicante,
    required this.desperdicioMateriasPrimas,
  });

  factory DashboardMetricas.fromJson(Map<String, dynamic> json) =>
      DashboardMetricas(
        fecha: json['fecha'],
        totalVentas: (json['totalVentas'] as num).toDouble(),
        tamalesVendidos: json['tamalesVendidos'],
        bebidasVendidas: json['bebidasVendidas'],
        porcentajePicante: (json['porcentajePicante'] as num).toDouble(),
        desperdicioMateriasPrimas:
            (json['desperdicioMateriasPrimas'] as num).toDouble(),
      );
}
