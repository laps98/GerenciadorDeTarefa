using GerenciadorDeTarefa.Domain.Anexo;

namespace GerenciadorDeTarefa.Domain.Tarefas;

public class Tarefa
{
    public int Id { get; set; }
    public string Titulo { get; set; }
    public string Descricao { get; set; }
    public DateTime DataDaTarefa { get; set; }

    public ICollection<AnexoDaTarefa> Anexos { get; set; } = new HashSet<AnexoDaTarefa>();
}
