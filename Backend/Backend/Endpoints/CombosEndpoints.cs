using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;

namespace Backend.Endpoints;
public static class CombosEndpoints
{
    public static void Map(WebApplication app)
    {
        var group = app.MapGroup("/api/combos");


        group.MapGet("/api/combos", async (CazuelaDbContext db) =>
        {
            var combos = await db.Combos
                .Include(c => c.ComboItems)              
                    .ThenInclude(ci => ci.Producto)     
                .Select(c => new
                {
                    c.ComboID,
                    c.Descripcion,
                    c.EsEstacional,
                    c.FechaInicio,
                    c.FechaFin,
                    Productos = c.ComboItems.Select(ci => new
                    {
                        ci.ComboItemID,
                        ci.ProductoID,
                        Nombre = ci.Producto != null ? ci.Producto.Nombre : null,
                        ci.Cantidad,
                        PrecioBase = ci.Producto != null ? ci.Producto.PrecioBase : 0m
                    })
                })
                .ToListAsync();

            return Results.Ok(combos);
        });

        group.MapGet("/", async (CazuelaDbContext db) => await db.Combos.ToListAsync());
        group.MapGet("/{id:int}", async (int id, CazuelaDbContext db) =>
            await db.Combos.FindAsync(id) is Combo c ? Results.Ok(c) : Results.NotFound());

        group.MapPost("/", async (Combo input, CazuelaDbContext db) =>
        {

            var producto = await db.Productos.FindAsync(input.ComboID);
            if (producto == null) return Results.BadRequest("Producto for combo not found");
            producto.EsCombo = true;
            db.Combos.Add(input);
            await db.SaveChangesAsync();
            return Results.Created($"/api/combos/{input.ComboID}", input);
        });

        group.MapPut("/{id:int}", async (int id, Combo input, CazuelaDbContext db) =>
        {
            var c = await db.Combos.FindAsync(id);
            if (c == null) return Results.NotFound();
            c.Descripcion = input.Descripcion;
            c.EsEstacional = input.EsEstacional;
            c.FechaInicio = input.FechaInicio;
            c.FechaFin = input.FechaFin;
            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapPost("/{comboId:int}/items", async (int comboId, ComboItem item, CazuelaDbContext db) =>
        {
            item.ComboID = comboId;
            db.ComboItems.Add(item);
            await db.SaveChangesAsync();
            return Results.Created($"/api/combos/{comboId}/items/{item.ComboItemID}", item);
        });

        group.MapGet("/{comboId:int}/items", async (int comboId, CazuelaDbContext db) =>
            await db.ComboItems
                .Where(ci => ci.ComboID == comboId)
                .Include(ci => ci.Producto)
                .Select(ci => new
                {
                    ci.ComboItemID,
                    ci.ComboID, 
                    ci.ProductoID,
                    ci.Cantidad,
                    productoNombre = ci.Producto.Nombre  
                })
                .ToListAsync());
    }
}
