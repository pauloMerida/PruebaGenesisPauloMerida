using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class Sucursal
{
    [Key]
    public int SucursalID { get; set; }
    public string Nombre { get; set; } = null!;
    public string Direccion { get; set; } = null!;
    public string? Telefono { get; set; }
    public bool Activo { get; set; }
}