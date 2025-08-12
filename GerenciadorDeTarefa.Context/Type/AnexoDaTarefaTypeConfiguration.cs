using GerenciadorDeTarefa.Domain.Anexo;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace GerenciadorDeTarefa.Context.Type;

internal class AnexoDaTarefaTypeConfiguration : IEntityTypeConfiguration<AnexoDaTarefa>
{
    public void Configure(EntityTypeBuilder<AnexoDaTarefa> builder)
    {
        builder.HasKey(q => q.Id);
        builder.Property(q => q.Id).ValueGeneratedOnAdd();

        builder.HasOne(q => q.Tarefa).WithMany(q => q.Anexos).HasForeignKey(q => q.IdTarefa);
    }
}
