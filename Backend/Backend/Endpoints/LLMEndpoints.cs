using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Backend.Data;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Endpoints
{
    public record LLMAskRequest(string Prompt);

    public static class LLMEndpoints
    {
        public static void Map(WebApplication app)
        {
            var group = app.MapGroup("/api/llm");

           
            group.MapPost("/log", async (LLMLog input, CazuelaDbContext db) =>
            {
                db.LLMLogs.Add(input);
                await db.SaveChangesAsync();
                return Results.Created($"/api/llm/{input.LogID}", input);
            });

            group.MapGet("/logs", async (CazuelaDbContext db) => await db.LLMLogs.OrderByDescending(l => l.FechaHora).Take(100).ToListAsync());

           
            group.MapPost("/ask", async (LLMAskRequest request, CazuelaDbContext db, IConfiguration config, [FromServices] IHttpClientFactory httpFactory) =>
            {
                var apiKey = config["OpenRouter:ApiKey"];
                if (string.IsNullOrWhiteSpace(apiKey))
                    return Results.BadRequest(new { error = "OpenRouter API key not configured on server." });

                var model = config["OpenRouter:Model"] ?? "openrouter/auto";
                var client = httpFactory.CreateClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

                var payload = new
                {
                    model = model,
                    messages = new[]
                    {
                        new { role = "user", content = request.Prompt }
                    }
                };

                var json = JsonSerializer.Serialize(payload);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                
                var response = await client.PostAsync("https://openrouter.ai/api/v1/chat/completions", content);

                var respText = await response.Content.ReadAsStringAsync();

                
                string salida = respText;
                try
                {
                    using var doc = JsonDocument.Parse(respText);
                   
                    if (doc.RootElement.TryGetProperty("choices", out var choices) && choices.GetArrayLength() > 0)
                    {
                        var first = choices[0];
                        if (first.TryGetProperty("message", out var message) && message.TryGetProperty("content", out var contentElem))
                        {
                            salida = contentElem.GetString() ?? respText;
                        }
                        else if (first.TryGetProperty("text", out var textElem))
                        {
                            salida = textElem.GetString() ?? respText;
                        }
                    }
                }
                catch
                {
                    
                }

                
                var log = new LLMLog
                {
                    TipoSolicitud = "ask",
                    Entrada = request.Prompt,
                    Salida = salida,
                   
                };

                db.LLMLogs.Add(log);
                await db.SaveChangesAsync();

                return Results.Ok(new { result = salida, raw = respText, logId = log.LogID });
            });
        }
    }
}
