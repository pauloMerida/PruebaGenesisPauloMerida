using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Endpoints;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHttpClient();

builder.Services.AddDbContext<CazuelaDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("CazuelaDb")));


builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });


});

var app = builder.Build();
app.UseCors();

app.MapGet("/", () => Results.Ok("Cazuela Chapina API - Minimal API"));

ProductosEndpoints.Map(app);
SucursalesEndpoints.Map(app);
MateriasPrimasEndpoints.Map(app);
MovimientosInventarioEndpoints.Map(app);
CombosEndpoints.Map(app);
VentasEndpoints.Map(app);
DashboardEndpoints.Map(app);
LLMEndpoints.Map(app);
AtributosEndpoints.Map(app);
ProductoAtributosEndpoints.Map(app);

app.Run();