using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Azure.Core;
using System.ComponentModel.DataAnnotations;

namespace Backend.Endpoints;

public class VentaRequest
{
    [Required]
    public Venta Venta { get; set; } = null!;
    [Required]
    public List<VentaDetalle> Detalles { get; set; } = null!;
}

public static class VentasEndpoints
{
    public static void Map(WebApplication app)
    {
        var group = app.MapGroup("/api/ventas");

        group.MapGet("/", async (CazuelaDbContext db) => await db.Ventas.ToListAsync());

        group.MapGet("/{id:guid}", async (Guid id, CazuelaDbContext db) =>
            await db.Ventas.FindAsync(id) is Venta v ? Results.Ok(v) : Results.NotFound());

        group.MapPost("/", async (VentaRequest request, CazuelaDbContext db) =>
        {
            var venta = request.Venta;
            var detalles = request.Detalles;

            venta.VentaID = Guid.NewGuid();
            venta.FechaVenta = venta.FechaVenta == default ? DateTime.UtcNow : venta.FechaVenta;

            await using var tx = await db.Database.BeginTransactionAsync();
            try
            {
                db.Ventas.Add(venta);
                await db.SaveChangesAsync();

                foreach (var d in detalles)
                {
                    d.VentaID = venta.VentaID;
                    db.VentaDetalles.Add(d);
                }
                await db.SaveChangesAsync();
                await tx.CommitAsync();
                return Results.Created($"/api/ventas/{venta.VentaID}", venta);
            }
            catch (Exception ex)
            {
                await tx.RollbackAsync();
                return Results.Problem(ex.Message);
            }
        });

        group.MapPut("/{id:guid}/estado", async (Guid id, string estado, CazuelaDbContext db) =>
        {
            var v = await db.Ventas.FindAsync(id);
            if (v == null) return Results.NotFound();
            v.Estado = estado;
            await db.SaveChangesAsync();
            return Results.Ok(v);
        });
    }
}
