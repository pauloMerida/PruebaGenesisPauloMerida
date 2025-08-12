using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class MetricaVenta
{
    [Key]
    public int MetricaID { get; set; }
    public int SucursalID { get; set; }
    public DateTime Fecha { get; set; }
    public decimal TotalVentas { get; set; }
    public int TamalesVendidos { get; set; }
    public int BebidasVendidas { get; set; }
    public decimal PorcentajePicante { get; set; }
    public decimal DesperdicioMateriasPrimas { get; set; }
}