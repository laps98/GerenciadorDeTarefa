using GerenciadorDeTarefa.Context;
using GerenciadorDeTarefa.Domain;
using GerenciadorDeTarefa.Domain.Anexo;
using GerenciadorDeTarefa.Domain.Components;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Text;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

var services = builder.Services;

services.AddCors();
services.AddControllers()
    .AddJsonOptions(options => { options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull; });

services.AddEndpointsApiExplorer();
//builder.AddSwaggerConfiguration();
services.AddSwaggerGen(q =>
{
    q.SwaggerDoc("v1", new OpenApiInfo { Title = "Gerenciador", Version = "v1" });

    q.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization Header - utilizado com Bearer Authentication.\r\n\r\n" +
                      "Digite 'Bearer' [espaço] e então seu token no campo abaixo.\r\n\r\n" +
                      "Exemplo (informar sem as aspas): 'Bearer 12345abcdef'",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT"
    });

    q.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        },
                    },
                    []
                }
            });
});
//builder.AddContextConfiguration();
var connectionString = builder.Configuration["ConnectionStrings:DefaultConnection"];

services.AddDbContext<IApplicationDbContext, ApplicationDbContext>(options =>
{
    options.ConfigureWarnings(warningsConfigurationBuilder => warningsConfigurationBuilder.Ignore(CoreEventId.PossibleIncorrectRequiredNavigationWithQueryFilterInteractionWarning));
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
});

services.AddDomainInjection();

services.AddControllersWithViews()
    .AddNewtonsoftJson(options =>
    {
        options.SerializerSettings.ContractResolver = new DefaultContractResolver();
        options.SerializerSettings.DefaultValueHandling = DefaultValueHandling.Include;
    });

//builder.AddAuthenticationConfiguration();
var key = Encoding.ASCII.GetBytes(Constants.SecretKey);
services.AddAuthentication(x =>
{
    x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
    .AddJwtBearer(x =>
    {
        x.RequireHttpsMetadata = false;
        x.SaveToken = true;
        x.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(key),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });

var app = builder.Build();

//app.UseSwaggerConfiguration();
app.UseSwagger();
app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "API Gerenciador v1"));

//app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();
app.UseCors(x => x
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader());

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
