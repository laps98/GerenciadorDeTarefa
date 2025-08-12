using GerenciadorDeTarefa.Domain.ViewModel;

namespace GerenciadorDeTarefa.Domain.Anexo;

public interface IGerenciadorDeAnexo
{
    Task<string> SalvarImagem(ImagemRequest imagem);
    bool ExcluirImagem(string filePath);
}

public class GerenciadorDeAnexo : IGerenciadorDeAnexo
{
    private readonly string _uploadPath;

    public GerenciadorDeAnexo()
    {
        _uploadPath = Path.Combine(Directory.GetCurrentDirectory(), "uploads");

        if (!Directory.Exists(_uploadPath))
            Directory.CreateDirectory(_uploadPath);
    }

    public async Task<string> SalvarImagem(ImagemRequest imagem)
    {
        if (imagem == null || string.IsNullOrEmpty(imagem.Base64) || string.IsNullOrEmpty(imagem.Extensao))
            throw new Exception("Imagem inválida.");

        byte[] bytes = Convert.FromBase64String(imagem.Base64);
        var fileName = $"{Guid.NewGuid()}.{imagem.Extensao}";
        var filePath = Path.Combine(_uploadPath, fileName);

        await File.WriteAllBytesAsync(filePath, bytes);

        return filePath;
    }

    public bool ExcluirImagem(string filePath)
    {
        if (string.IsNullOrWhiteSpace(filePath))
            return false;

        var fullPath = Path.GetFullPath(filePath);

        if (!fullPath.StartsWith(_uploadPath))
        {
            return false;
        }

        if (File.Exists(fullPath))
        {
            File.Delete(fullPath);
            return true;
        }

        return false;
    }
}
