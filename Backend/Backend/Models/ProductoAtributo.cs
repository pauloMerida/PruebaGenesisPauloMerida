using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class ProductoAtributo
{
    [Key]
    public long ProductoAtributoID { get; set; }
    public int ProductoID { get; set; }
    public short AtributoID { get; set; }
    public string Valor { get; set; } = null!;
    public decimal CostoAdicional { get; set; }
}