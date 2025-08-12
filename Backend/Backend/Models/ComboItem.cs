using System.ComponentModel.DataAnnotations;
namespace Backend.Models;
public class ComboItem
{
    [Key]
    public long ComboItemID { get; set; }
    public int ComboID { get; set; }      
    public int ProductoID { get; set; }   
    public decimal Cantidad { get; set; }

   
    public Producto Producto { get; set; }
    public Combo Combo { get; set; }
}