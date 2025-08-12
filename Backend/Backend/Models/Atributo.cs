using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Backend.Models;
public class Atributo
{
    [Key]
    public short AtributoID { get; set; }
    public string Nombre { get; set; } = null!;
    public string Tipo { get; set; } = null!;
}