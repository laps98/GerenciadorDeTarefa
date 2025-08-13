using GerenciadorDeTarefa.Domain.Tarefas.Enums;

namespace GerenciadorDeTarefa.Domain.ViewModel;
public class TarefaRequest
{
    public int? id { get; set; }
    public string Titulo { get; set; }
    public string Descricao { get; set; }
    public DateTime DataDaTarefa { get; set; }
    public StatusDaTarefa Status { get; set; }
    public List<ImagemRequest> Imagens { get; set; } = new List<ImagemRequest>();
}