using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class VentaDetalle
{
    [Key]
    public long VentaDetalleID { get; set; }
    public Guid VentaID { get; set; }
    public int ProductoID { get; set; }
    public decimal Cantidad { get; set; }
    public decimal PrecioUnitario { get; set; }
    public string? AtributosSeleccionados { get; set; }
}