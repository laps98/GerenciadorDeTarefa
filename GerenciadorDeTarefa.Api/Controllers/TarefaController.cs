using GerenciadorDeTarefa.Domain;
using GerenciadorDeTarefa.Domain.Anexo;
using GerenciadorDeTarefa.Domain.Tarefas;
using GerenciadorDeTarefa.Domain.ViewModel;
using IronBugCore.Pagination;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace GerenciadorDeTarefa.Api.Controllers;

public class TarefasController : BaseApiController
{
    private readonly IApplicationDbContext _context;
    private readonly GerenciadorDeAnexo _anexo;

    public TarefasController(GerenciadorDeAnexo anexo, IApplicationDbContext context)
    {
        _anexo = anexo;
        _context = context;
    }

    [HttpPost("Criar")]
    public async Task<IActionResult> Criar([FromBody] TarefaRequest request)
    {
        var tarefa = new Tarefa
        {
            Titulo = request.Titulo,
            Descricao = request.Descricao,
            DataDaTarefa = request.DataDaTarefa
        };
        _context.Tarefas.Add(tarefa);
        _context.SaveChanges();

        foreach (var img in request.Imagens)
        {
            var caminho = await _anexo.SalvarImagem(img);
            var anexo = new AnexoDaTarefa
            {
                IdTarefa = tarefa.Id,
                Caminho = caminho

            };
        _context.AnexosDasTarefas.Add(anexo);
        }
        _context.SaveChanges();

        return Ok(tarefa);
    }

    [HttpGet]
    public IActionResult Listar([FromQuery] QueryFilter filter)
    {
        IQueryable<Tarefa> query = _context.Tarefas;


        if (!string.IsNullOrWhiteSpace(filter.Search))
        {
            string like = $"%{filter.Search.ToLower().Trim()}%";
            query = query.Where(q =>
                filter.Search == "" ||
                EF.Functions.Like(q.Descricao, like));
        }


        var paged = query.Paginate(filter);
        paged.AddSorterField(q => q.Descricao);

        return Ok(paged);
    }

    [HttpGet("{id}")]
    public IActionResult Obter(int id)
    {
        var tarefa = _context.Tarefas.FirstOrDefault(t => t.Id == id);
        if (tarefa == null) return BadRequest("Tarefa não encontrada");
        return Ok(tarefa);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Atualizar(int id, [FromBody] TarefaRequest request)
    {
        var tarefa = _context.Tarefas.FirstOrDefault(t => t.Id == id);
        if (tarefa == null) return BadRequest("Tarefa não encontrada");

        tarefa.Titulo = request.Titulo;
        tarefa.Descricao = request.Descricao;
        tarefa.DataDaTarefa = request.DataDaTarefa;

        foreach (var img in tarefa.Anexos)
            _anexo.ExcluirImagem(img.Caminho);

        tarefa.Anexos.Clear();

        foreach (var img in request.Imagens)
        {
            var caminho = await _anexo.SalvarImagem(img);
            var anexo = new AnexoDaTarefa
            {
                IdTarefa = tarefa.Id,
                Caminho = caminho

            };
            _context.AnexosDasTarefas.Add(anexo);
        }

        _context.SaveChanges();

        return Ok();
    }

    [HttpDelete("{id}")]
    public IActionResult Excluir(int id)
    {
        var tarefa = _context.Tarefas.FirstOrDefault(t => t.Id == id);
        if (tarefa == null) return BadRequest("Tarefa não encontrada");

        foreach (var img in tarefa.Anexos)
        {
            _anexo.ExcluirImagem(img.Caminho);
            _context.AnexosDasTarefas.Remove(img);

        }

        _context.Tarefas.Remove(tarefa);

        return NoContent();
    }
}
