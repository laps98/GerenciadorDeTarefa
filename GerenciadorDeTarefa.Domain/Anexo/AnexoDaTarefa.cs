using GerenciadorDeTarefa.Domain.Tarefas;

namespace GerenciadorDeTarefa.Domain.Anexo;

public class AnexoDaTarefa
{
    public int Id { get; set; }
    public int IdTarefa { get; set; }
    public string Caminho { get; set; }

    public Tarefa Tarefa{ get; set; }
}
