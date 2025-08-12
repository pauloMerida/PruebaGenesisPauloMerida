using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;

namespace Backend.Endpoints;
public static class SucursalesEndpoints
{
    public static void Map(WebApplication app)
    {
        var group = app.MapGroup("/api/sucursales");

        group.MapGet("/", async (CazuelaDbContext db) => await db.Sucursales.ToListAsync());
        group.MapGet("/{id:int}", async (int id, CazuelaDbContext db) =>
            await db.Sucursales.FindAsync(id) is Sucursal s ? Results.Ok(s) : Results.NotFound());

        group.MapPost("/", async (Sucursal input, CazuelaDbContext db) =>
        {
            db.Sucursales.Add(input);
            await db.SaveChangesAsync();
            return Results.Created($"/api/sucursales/{input.SucursalID}", input);
        });

        group.MapPut("/{id:int}", async (int id, Sucursal input, CazuelaDbContext db) =>
        {
            var s = await db.Sucursales.FindAsync(id);
            if (s == null) return Results.NotFound();
            s.Nombre = input.Nombre;
            s.Direccion = input.Direccion;
            s.Telefono = input.Telefono;
            s.Activo = input.Activo;
            await db.SaveChangesAsync();
            return Results.NoContent();
        });

        group.MapDelete("/{id:int}", async (int id, CazuelaDbContext db) =>
        {
            var s = await db.Sucursales.FindAsync(id);
            if (s == null) return Results.NotFound();
            db.Sucursales.Remove(s);
            await db.SaveChangesAsync();
            return Results.NoContent();
        });
    }
}