using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class LLMLog
{
    [Key]
    public long LogID { get; set; }
    public DateTime FechaHora { get; set; }
    public string TipoSolicitud { get; set; } = null!;
    public string Entrada { get; set; } = null!;
    public string Salida { get; set; } = null!;
    public decimal? CostoToken { get; set; }
    public int? DuracionMs { get; set; }
}