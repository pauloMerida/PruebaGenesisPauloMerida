class LLMLog {
  final int logID;
  final DateTime fechaHora;
  final String tipoSolicitud;
  final String entrada;
  final String salida;
  final double? costoToken;
  final int? duracionMs;

  LLMLog({
    required this.logID,
    required this.fechaHora,
    required this.tipoSolicitud,
    required this.entrada,
    required this.salida,
    this.costoToken,
    this.duracionMs,
  });

  factory LLMLog.fromJson(Map<String, dynamic> json) => LLMLog(
        logID: json['logID'],
        fechaHora: DateTime.parse(json['fechaHora']),
        tipoSolicitud: json['tipoSolicitud'],
        entrada: json['entrada'],
        salida: json['salida'],
        costoToken:
            json['costoToken'] != null ? (json['costoToken'] as num).toDouble() : null,
        duracionMs: json['duracionMs'],
      );
}
