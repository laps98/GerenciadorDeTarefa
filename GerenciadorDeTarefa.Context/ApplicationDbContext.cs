using GerenciadorDeTarefa.Domain;
using GerenciadorDeTarefa.Domain.Anexo;
using GerenciadorDeTarefa.Domain.Tarefas;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace GerenciadorDeTarefa.Context;

public class ApplicationDbContext : DbContext, IApplicationDbContext
{
    public DbSet<Tarefa> Tarefas { get; set; }
    public DbSet<AnexoDaTarefa> AnexosDasTarefas { get; set; }

    public ApplicationDbContext(DbContextOptions options) : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        //modelBuilder.RemovePluralizingTableNameConvention();

        modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

        base.OnModelCreating(modelBuilder);
    }

    public override int SaveChanges()
    {

        return base.SaveChanges();
    }

    public async Task<int> SaveChangesAsync()
    {
        return await base.SaveChangesAsync();
    }
}
