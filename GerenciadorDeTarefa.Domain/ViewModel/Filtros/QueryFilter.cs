using IronBugCore.Pagination;

namespace GerenciadorDeTarefa.Domain.ViewModel.Filtros;

public sealed record TarefaQueryFilter : QueryFilter
{
    public string? Titulo { get; set; }
    public DateTime? DataDaTarefa { get; set; }
}