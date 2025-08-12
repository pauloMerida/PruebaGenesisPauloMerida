using Backend.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    [Table("AtributoOpciones", Schema = "cazuela")]
    public class AtributoOpcion
    {
        [Key]
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;

        public int AtributoId { get; set; }
        public Atributo? Atributo { get; set; }
    }
}

