using GerenciadorDeTarefa.Domain.Anexo;
using Microsoft.Extensions.DependencyInjection;

namespace GerenciadorDeTarefa.Domain;

public static class DomainInjection
{
    private static IServiceCollection _service = null!;
    public static void AddDomainInjection(this IServiceCollection service)
    {
        _service = service;

        _service.AddTransient<IGerenciadorDeAnexo, GerenciadorDeAnexo>();
    }
}