using Microsoft.EntityFrameworkCore;
using Backend.Models;

namespace Backend.Data;
public class CazuelaDbContext : DbContext
{
    public CazuelaDbContext(DbContextOptions<CazuelaDbContext> options) : base(options) { }

    public DbSet<Producto> Productos { get; set; } = null!;
    public DbSet<CategoriaProducto> CategoriasProducto { get; set; } = null!;
    public DbSet<Atributo> Atributos { get; set; } = null!;
    public DbSet<Combo> Combos { get; set; } = null!;
    public DbSet<ComboItem> ComboItems { get; set; } = null!;
    public DbSet<ProductoAtributo> ProductoAtributos { get; set; } = null!;
    public DbSet<Sucursal> Sucursales { get; set; } = null!;
    public DbSet<MateriaPrima> MateriasPrimas { get; set; } = null!;
    public DbSet<MovimientoInventario> MovimientosInventario { get; set; } = null!;
    public DbSet<Venta> Ventas { get; set; } = null!;
    public DbSet<VentaDetalle> VentaDetalles { get; set; } = null!;
    public DbSet<MetricaVenta> MetricasVenta { get; set; } = null!;
    public DbSet<LLMLog> LLMLogs { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("cazuela");

        modelBuilder.Entity<Producto>().HasKey(p => p.ProductoID);
        modelBuilder.Entity<CategoriaProducto>().HasKey(c => c.CategoriaID);
        modelBuilder.Entity<Atributo>().HasKey(a => a.AtributoID);
        modelBuilder.Entity<Combo>().HasKey(c => c.ComboID);
        modelBuilder.Entity<ComboItem>().HasKey(ci => ci.ComboItemID);
        modelBuilder.Entity<ProductoAtributo>().HasKey(pa => pa.ProductoAtributoID);
        modelBuilder.Entity<Sucursal>().HasKey(s => s.SucursalID);
        modelBuilder.Entity<MateriaPrima>().HasKey(mp => mp.MateriaPrimaID);
        modelBuilder.Entity<MovimientoInventario>().HasKey(mi => mi.MovimientoID);
        modelBuilder.Entity<Venta>().HasKey(v => v.VentaID);
        modelBuilder.Entity<VentaDetalle>().HasKey(vd => vd.VentaDetalleID);
        modelBuilder.Entity<MetricaVenta>().HasKey(m => m.MetricaID);
        modelBuilder.Entity<LLMLog>().HasKey(l => l.LogID);

        modelBuilder.Entity<Venta>().Property(v => v.VentaID).HasDefaultValueSql("NEWID()");
        modelBuilder.Entity<Venta>().Property(v => v.FechaVenta).HasDefaultValueSql("GETDATE()");
        modelBuilder.Entity<Producto>().Property(p => p.FechaCreacion).HasDefaultValueSql("GETDATE()");
        modelBuilder.Entity<LLMLog>().Property(l => l.FechaHora).HasDefaultValueSql("GETDATE()");

        modelBuilder.Entity<Combo>()
                .HasOne(c => c.Producto)
                .WithOne() 
                .HasForeignKey<Combo>(c => c.ComboID)
                .OnDelete(DeleteBehavior.Restrict);
        modelBuilder.Entity<Combo>()
                .HasMany(c => c.ComboItems)
                .WithOne(ci => ci.Combo)
                .HasForeignKey(ci => ci.ComboID)
                .OnDelete(DeleteBehavior.Cascade);

        
        modelBuilder.Entity<ComboItem>()
            .HasOne(ci => ci.Producto)
            .WithMany(p => p.ComboItems)
            .HasForeignKey(ci => ci.ProductoID)
            .OnDelete(DeleteBehavior.Restrict);

        base.OnModelCreating(modelBuilder);
    }
}