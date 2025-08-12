using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;

namespace Backend.Endpoints;
public static class MateriasPrimasEndpoints
{
    public static void Map(WebApplication app)
    {
        var group = app.MapGroup("/api/materias");

        group.MapGet("/", async (CazuelaDbContext db) => await db.MateriasPrimas.ToListAsync());
        group.MapGet("/{id:int}", async (int id, CazuelaDbContext db) =>
            await db.MateriasPrimas.FindAsync(id) is MateriaPrima m ? Results.Ok(m) : Results.NotFound());

        group.MapPost("/", async (MateriaPrima input, CazuelaDbContext db) =>
        {
            db.MateriasPrimas.Add(input);
            await db.SaveChangesAsync();
            return Results.Created($"/api/materias/{input.MateriaPrimaID}", input);
        });

        group.MapPut("/{id:int}", async (int id, MateriaPrima input, CazuelaDbContext db) =>
        {
            var m = await db.MateriasPrimas.FindAsync(id);
            if (m == null) return Results.NotFound();
            m.Nombre = input.Nombre;
            m.Tipo = input.Tipo;
            m.UnidadMedida = input.UnidadMedida;
            m.StockMinimo = input.StockMinimo;
            m.Activo = input.Activo;
            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/{id:int}", async (int id, CazuelaDbContext db) =>
        {
            var m = await db.MateriasPrimas.FindAsync(id);
            if (m == null) return Results.NotFound();
            db.MateriasPrimas.Remove(m);
            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}

