using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Backend.Data;
using Backend.Models;

namespace Backend.Endpoints
{
    public static class ProductoAtributosEndpoints
    {
        public static void Map(WebApplication app)
        {
            var group = app.MapGroup("/api/productoatributos");

            group.MapGet("/", async (CazuelaDbContext db) => await db.ProductoAtributos.ToListAsync());

       
            group.MapGet("/{id:long}", async (long id, CazuelaDbContext db) =>
                await db.ProductoAtributos.FindAsync(id) is ProductoAtributo pa ? Results.Ok(pa) : Results.NotFound());

            group.MapGet("/producto/{productoId:int}", async (int productoId, CazuelaDbContext db) =>
                await db.ProductoAtributos.Where(x => x.ProductoID == productoId).ToListAsync());

            group.MapPost("/", async (ProductoAtributo input, CazuelaDbContext db) =>
            {
                db.ProductoAtributos.Add(input);
                await db.SaveChangesAsync();
                return Results.Created($"/api/productoatributos/{input.ProductoAtributoID}", input);
            });

            group.MapPut("/{id:long}", async (long id, ProductoAtributo input, CazuelaDbContext db) =>
            {
                var existing = await db.ProductoAtributos.FindAsync(id);
                if (existing == null) return Results.NotFound();
                existing.Valor = input.Valor;
                existing.CostoAdicional = input.CostoAdicional;
                existing.AtributoID = input.AtributoID;
                await db.SaveChangesAsync();
                return Results.NoContent();
            });

            group.MapDelete("/{id:long}", async (long id, CazuelaDbContext db) =>
            {
                var existing = await db.ProductoAtributos.FindAsync(id);
                if (existing == null) return Results.NotFound();
                db.ProductoAtributos.Remove(existing);
                await db.SaveChangesAsync();
                return Results.NoContent();
            });
        }
    }
}

