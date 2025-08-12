using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace Backend.Models;

public class Combo

{
    [Key]
    public int ComboID { get; set; }      
    public string? Descripcion { get; set; }
    public bool EsEstacional { get; set; }
    public DateTime? FechaInicio { get; set; }
    public DateTime? FechaFin { get; set; }

   
    public List<ComboItem> ComboItems { get; set; } = new();

  
    public Producto? Producto { get; set; }

}