namespace GerenciadorDeTarefa.Domain.ViewModel;

public sealed record ImagemRequest
{
    public string Base64 { get; set; }
    public string Extensao { get; set; }
}
