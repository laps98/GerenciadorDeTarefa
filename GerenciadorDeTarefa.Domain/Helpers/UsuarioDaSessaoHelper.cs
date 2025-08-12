using GerenciadorDeTarefa.Domain.Components;
using GerenciadorDeTarefa.Domain.Contas;
using IronBug.Helpers;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace GerenciadorDeTarefa.Domain.Helpers;

public static class UsuarioDaSessaoHelper
{
    public static IUsuarioDaSessao? Usuario(this HttpContext context)
    {
        var user = context.User;
        var id = user.Claims.FirstOrDefault(c => c.Type == CustomClaimType.Id)?.Value.ToInt();
        if (id == null)
            return null;

        var nome = user.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Name)?.Value;
        var email = user.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Email)?.Value;

        var usuario = new UsuarioDaSessao
        {
            Id = id.Value,
            Nome = nome,
            Email = email,
        };

        return usuario;
    }
}