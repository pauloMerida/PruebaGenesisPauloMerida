using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;

namespace Backend.Endpoints;
public static class MovimientosInventarioEndpoints
{
    public static void Map(WebApplication app)
    {
        var group = app.MapGroup("/api/inventario");

        group.MapGet("/movimientos", async (CazuelaDbContext db) => await db.MovimientosInventario.ToListAsync());

        group.MapPost("/movimientos", async (MovimientoInventario input, CazuelaDbContext db) =>
        {
            input.FechaMovimiento = input.FechaMovimiento == default ? DateTime.UtcNow : input.FechaMovimiento;
            db.MovimientosInventario.Add(input);
            await db.SaveChangesAsync();
            return Results.Created($"/api/inventario/movimientos/{input.MovimientoID}", input);
        });

        
        group.MapGet("/stock/{materiaId:int}", async (int materiaId, CazuelaDbContext db) =>
        {
            var entradas = await db.MovimientosInventario
                .Where(m => m.MateriaPrimaID == materiaId && (m.TipoMovimiento == "Entrada" || m.TipoMovimiento == "Ajuste"))
                .SumAsync(m => (decimal?)m.Cantidad) ?? 0m;
            var salidas = await db.MovimientosInventario
                .Where(m => m.MateriaPrimaID == materiaId && (m.TipoMovimiento == "Salida" || m.TipoMovimiento == "Merma"))
                .SumAsync(m => (decimal?)m.Cantidad) ?? 0m;
            return Results.Ok(new { MateriaPrimaID = materiaId, StockActual = entradas - salidas });
        });
    }
}
