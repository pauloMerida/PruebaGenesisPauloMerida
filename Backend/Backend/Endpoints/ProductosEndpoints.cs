using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;

namespace Backend.Endpoints;
public static class ProductosEndpoints
{
    public static void Map(WebApplication app)
    {
        var group = app.MapGroup("/api/productos");

        group.MapGet("/", async (CazuelaDbContext db) => await db.Productos.ToListAsync());

        group.MapGet("/{id:int}", async (int id, CazuelaDbContext db) =>
            await db.Productos.FindAsync(id) is Producto p ? Results.Ok(p) : Results.NotFound());

        group.MapPost("/", async (Producto input, CazuelaDbContext db) =>
        {
            db.Productos.Add(input);
            await db.SaveChangesAsync();
            return Results.Created($"/api/productos/{input.ProductoID}", input);
        });

        group.MapPut("/{id:int}", async (int id, Producto input, CazuelaDbContext db) =>
        {
            var p = await db.Productos.FindAsync(id);
            if (p == null) return Results.NotFound();
            p.Nombre = input.Nombre;
            p.CategoriaID = input.CategoriaID;
            p.PrecioBase = input.PrecioBase;
            p.UnidadMedida = input.UnidadMedida;
            p.EsCombo = input.EsCombo;
            p.Activo = input.Activo;
            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/{id:int}", async (int id, CazuelaDbContext db) =>
        {
            var p = await db.Productos.FindAsync(id);
            if (p == null) return Results.NotFound();
            db.Productos.Remove(p);
            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}