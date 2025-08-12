using System.ComponentModel.DataAnnotations;
namespace Backend.Models;

    public class CategoriaProducto
    {
        [Key]
        public byte CategoriaID { get; set; }
        public string Nombre { get; set; } = null!;
    }
