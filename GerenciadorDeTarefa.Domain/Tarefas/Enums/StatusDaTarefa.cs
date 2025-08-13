using System.ComponentModel.DataAnnotations;

namespace GerenciadorDeTarefa.Domain.Tarefas.Enums;

public enum StatusDaTarefa
{
    Pendente,
    [Display(Name = "Concluída")]
    Concluida,
    Cancelada
}
