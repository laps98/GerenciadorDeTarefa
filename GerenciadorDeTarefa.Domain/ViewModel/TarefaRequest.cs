namespace GerenciadorDeTarefa.Domain.ViewModel;
public class TarefaRequest
{
    public string Titulo { get; set; }
    public string Descricao { get; set; }
    public DateTime DataDaTarefa { get; set; }
    public List<ImagemRequest> Imagens { get; set; } = new List<ImagemRequest>();
}