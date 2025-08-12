namespace GerenciadorDeTarefa.Domain.Contas;

public interface IUsuarioDaSessao
{
    int Id { get; set; }
    string Nome { get; set; }
    string Email { get; set; }
}

public sealed record UsuarioDaSessao : IUsuarioDaSessao
{
    public int Id { get; set; }
    public string Nome { get; set; } = null!;
    public string Email { get; set; } = null!;
}