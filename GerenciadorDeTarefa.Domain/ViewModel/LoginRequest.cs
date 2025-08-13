namespace GerenciadorDeTarefa.Domain.ViewModel;

public sealed record LoginRequest
{
    public string Email { get; set; }
    public string? Senha { get; set; }
}
