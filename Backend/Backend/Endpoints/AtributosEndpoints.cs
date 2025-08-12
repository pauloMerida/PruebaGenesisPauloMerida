using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Backend.Data;
using Backend.Models;

namespace Backend.Endpoints
{
    public static class AtributosEndpoints
    {
        public static void Map(WebApplication app)
        {
            var group = app.MapGroup("/api/atributos");

            app.MapGet("/api/productos/{id}/atributos", async (int id, CazuelaDbContext db) =>
            {
                var items = await db.ProductoAtributos
                    .Where(pa => pa.ProductoID == id)
                    .Join(db.Atributos,
                          pa => pa.AtributoID,
                          a => a.AtributoID,
                          (pa, a) => new {
                              pa.ProductoAtributoID,
                              AtributoID = a.AtributoID,
                              Nombre = a.Nombre,
                              Tipo = a.Tipo,
                              Valor = pa.Valor,              
                              pa.CostoAdicional
                          })
                    .ToListAsync();

                var result = items.Select(x => new {
                    x.ProductoAtributoID,
                    x.AtributoID,
                    x.Nombre,
                    x.Tipo,
                    Opciones = x.Valor?.Split(',', StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).ToList() ?? new List<string>(),
                    x.CostoAdicional
                });

                return Results.Ok(result);
            });

            group.MapGet("/", async (CazuelaDbContext db) =>
                await db.Atributos.ToListAsync());

            group.MapGet("/{id:int}", async (int id, CazuelaDbContext db) =>
                await db.Atributos.FindAsync((short)id) is Atributo a ? Results.Ok(a) : Results.NotFound());

            group.MapPost("/", async (Atributo input, CazuelaDbContext db) =>
            {
                db.Atributos.Add(input);
                await db.SaveChangesAsync();
                return Results.Created($"/api/atributos/{input.AtributoID}", input);
            });

            group.MapPut("/{id:int}", async (int id, Atributo input, CazuelaDbContext db) =>
            {
                var existing = await db.Atributos.FindAsync((short)id);
                if (existing == null) return Results.NotFound();
                existing.Nombre = input.Nombre;
                existing.Tipo = input.Tipo;
                await db.SaveChangesAsync();
                return Results.NoContent();
            });

            group.MapDelete("/{id:int}", async (int id, CazuelaDbContext db) =>
            {
                var existing = await db.Atributos.FindAsync((short)id);
                if (existing == null) return Results.NotFound();
                db.Atributos.Remove(existing);
                await db.SaveChangesAsync();
                return Results.NoContent();
            });
        }
    }
}
