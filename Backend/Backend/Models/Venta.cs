using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class Venta
{
    [Key]
    public Guid VentaID { get; set; }
    public int SucursalID { get; set; }
    public DateTime FechaVenta { get; set; }
    public decimal Total { get; set; }
    public string Estado { get; set; } = "Pendiente";
    public bool EsOffline { get; set; }
}