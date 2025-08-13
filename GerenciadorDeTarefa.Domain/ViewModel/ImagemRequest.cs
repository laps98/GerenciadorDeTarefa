namespace GerenciadorDeTarefa.Domain.ViewModel;

public sealed record ImagemRequest
{
    public int? id { get; set; }
    public string? Base64 { get; set; }
    public string? Extensao { get; set; }
    public string? Caminho{ get; set; }
}
