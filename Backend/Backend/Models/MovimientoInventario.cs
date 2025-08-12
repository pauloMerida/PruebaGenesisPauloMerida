using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class MovimientoInventario
{
    [Key]
    public long MovimientoID { get; set; }
    public int MateriaPrimaID { get; set; }
    public string TipoMovimiento { get; set; } = null!;
    public decimal Cantidad { get; set; }
    public decimal? CostoUnitario { get; set; }
    public DateTime FechaMovimiento { get; set; }
    public int SucursalID { get; set; }
    public string? Comentarios { get; set; }
}