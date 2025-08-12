using Microsoft.EntityFrameworkCore;
using Backend.Data;

namespace Backend.Endpoints;
public static class DashboardEndpoints
{
    public static void Map(WebApplication app)
    {
        var group = app.MapGroup("/api/dashboard");

       
        group.MapGet("/ventas/diarias", async (DateTime? from, DateTime? to, int? sucursalId, CazuelaDbContext db) =>
        {
            var q = db.MetricasVenta.AsQueryable();
            if (sucursalId.HasValue) q = q.Where(m => m.SucursalID == sucursalId.Value);
            if (from.HasValue) q = q.Where(m => m.Fecha >= from.Value.Date);
            if (to.HasValue) q = q.Where(m => m.Fecha <= to.Value.Date);
            var list = await q.OrderByDescending(m => m.Fecha).ToListAsync();
            return Results.Ok(list);
        });

        
        group.MapGet("/tamales/masvendidos", async (CazuelaDbContext db) =>
        {
            var data = await (from d in db.VentaDetalles
                              join p in db.Productos on d.ProductoID equals p.ProductoID
                              where p.CategoriaID == 1
                              group d by p.Nombre into g
                              select new { Nombre = g.Key, Cantidad = g.Sum(x => x.Cantidad) })
                              .OrderByDescending(x => x.Cantidad)
                              .Take(10)
                              .ToListAsync();
            return Results.Ok(data);
        });

       
        group.MapGet("/proporcion/picante", async (CazuelaDbContext db) =>
        {
            var detalles = await db.VentaDetalles.Where(d => d.AtributosSeleccionados != null).ToListAsync();
            var conPicante = detalles.Count(d => d.AtributosSeleccionados!.Contains("Picante", StringComparison.OrdinalIgnoreCase));
            var total = detalles.Count;
            return Results.Ok(new { ConPicante = conPicante, Total = total, Proporcion = total == 0 ? 0 : (double)conPicante / total });
        });
    }
}