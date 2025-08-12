using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class MateriaPrima
{
    [Key]
    public int MateriaPrimaID { get; set; }
    public string Nombre { get; set; } = null!;
    public string Tipo { get; set; } = null!;
    public string UnidadMedida { get; set; } = null!;
    public decimal StockMinimo { get; set; }
    public bool Activo { get; set; }
}