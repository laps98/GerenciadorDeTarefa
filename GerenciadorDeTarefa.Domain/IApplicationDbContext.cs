using GerenciadorDeTarefa.Domain.Anexo;
using GerenciadorDeTarefa.Domain.Tarefas;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace GerenciadorDeTarefa.Domain;

public interface IApplicationDbContext 
{

    DbSet<Tarefa> Tarefas { get; set; }
    DbSet<AnexoDaTarefa> AnexosDasTarefas { get; set; }
    //DbSet<Usuario> Usuarios { get; set; }

    DatabaseFacade Database { get; }
    int SaveChanges();
    Task<int> SaveChangesAsync();
}
