using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace Backend.Models;
public class Producto
{
    [Key]
    public int ProductoID { get; set; }
    public string Nombre { get; set; } = null!;
    public byte CategoriaID { get; set; }
    public decimal PrecioBase { get; set; }
    public string? UnidadMedida { get; set; }
    public bool EsCombo { get; set; }
    public DateTime FechaCreacion { get; set; }
    public bool Activo { get; set; }
    public List<ComboItem> ComboItems { get; set; } = new();
}
