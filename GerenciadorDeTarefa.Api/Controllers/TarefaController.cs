using GerenciadorDeTarefa.Domain;
using GerenciadorDeTarefa.Domain.Anexo;
using GerenciadorDeTarefa.Domain.Tarefas;
using GerenciadorDeTarefa.Domain.ViewModel;
using GerenciadorDeTarefa.Domain.ViewModel.Filtros;
using IronBug.Helpers;
using IronBugCore.Pagination;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Transactions;

namespace GerenciadorDeTarefa.Api.Controllers;

public class TarefaController : BaseApiController
{
    private readonly IApplicationDbContext _context;
    private readonly IGerenciadorDeAnexo _anexo;

    public TarefaController(IGerenciadorDeAnexo anexo, IApplicationDbContext context)
    {
        _anexo = anexo;
        _context = context;
    }

    [HttpPost("Save")]
    public async Task<IActionResult> Save([FromBody] TarefaRequest request)
    {
        using var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

        var anexos = new List<string>();
        try
        {
            var tarefa = _context.Tarefas.Include(q => q.Anexos).FirstOrDefault(t => t.Id == request.id) ?? new Tarefa();
            var idDosAnexosDaRequest = request.Imagens.Select(q => q.id??0).ToList();
            var idosDosAnexosDoBanco = tarefa.Anexos.Select(q => q.Id).ToList();
            var idsParaRemover = idosDosAnexosDoBanco.Except(idDosAnexosDaRequest).ToList();

            tarefa.Titulo = request.Titulo;
            tarefa.Descricao = request.Descricao;
            tarefa.DataDaTarefa = request.DataDaTarefa;
            tarefa.Status = request.Status;

            if (tarefa.Id == 0)
                _context.Tarefas.Add(tarefa);
            else
                _context.Tarefas.Update(tarefa);

            _context.SaveChanges();

            foreach (var img in request.Imagens)
            {
                if (!string.IsNullOrEmpty(img.Base64))
                {
                    var caminho = await _anexo.SalvarImagem(img);
                    anexos.Add(caminho);
                    var anexo = new AnexoDaTarefa
                    {
                        IdTarefa = tarefa.Id,
                        Caminho = caminho
                    };
                    _context.AnexosDasTarefas.Add(anexo);
                }
            }
            _context.SaveChanges();

            foreach (var img in tarefa.Anexos.Where(q=>idsParaRemover.Contains(q.Id)))
            {
                _anexo.ExcluirImagem(img.Caminho);
                _context.AnexosDasTarefas.Remove(img);
            }

            _context.SaveChanges();

            scope.Complete();

            return Ok();
        }
        catch (Exception e)
        {
            foreach (var img in anexos)
                _anexo.ExcluirImagem(img);

            return BadRequest(e.Message);
        }

    }

    [HttpGet("Listar")]
    public IActionResult Listar([FromQuery] TarefaQueryFilter filter)
    {
        IQueryable<Tarefa> query = _context.Tarefas.Include(q => q.Anexos);


        if (!string.IsNullOrWhiteSpace(filter.Titulo))
        {
            string like = $"%{filter.Titulo.ToLower().Trim()}%";
            query = query.Where(q =>
                filter.Search == "" ||
                EF.Functions.Like(q.Titulo, like));
        }

        if (filter.DataDaTarefa != null) {
            query = query.Where(q => q.DataDaTarefa.Date == filter.DataDaTarefa.Value.Date);
        }

        if (filter.Status != null)
        {
            query = query.Where(q => q.Status == filter.Status);
        }

        var paged = query.Paginate(filter);
        paged.AddSorterField("Data", q => q.DataDaTarefa);

        var response = paged.Select(q => new
        {
            q.Id,
            q.Titulo,
            q.Descricao,
            q.Status,
            DataDaTarefa = q.DataDaTarefa.ToString("dd/MM/yyyy"),

            Imagens = q.Anexos.Select(q => new { q.Id, q.Caminho }).ToList()

        }).ToList();

        return Ok(response);
    }

    [HttpDelete("Excluir/{id}")]
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
        _context.SaveChanges();

        return Ok();
    }

    //[HttpGet("{id}")]
    //public IActionResult Obter(int id)
    //{
    //    var tarefa = _context.Tarefas.FirstOrDefault(t => t.Id == id);
    //    if (tarefa == null) return BadRequest("Tarefa não encontrada");
    //    return Ok(tarefa);
    //}

    //[HttpPut("{id}")]
    //public async Task<IActionResult> Atualizar(int id, [FromBody] TarefaRequest request)
    //{
    //    var tarefa = _context.Tarefas.FirstOrDefault(t => t.Id == id);
    //    if (tarefa == null) return BadRequest("Tarefa não encontrada");

    //    tarefa.Titulo = request.Titulo;
    //    tarefa.Descricao = request.Descricao;
    //    tarefa.DataDaTarefa = request.DataDaTarefa;

    //    foreach (var img in tarefa.Anexos)
    //        _anexo.ExcluirImagem(img.Caminho);

    //    tarefa.Anexos.Clear();

    //    foreach (var img in request.Imagens)
    //    {
    //        var caminho = await _anexo.SalvarImagem(img);
    //        var anexo = new AnexoDaTarefa
    //        {
    //            IdTarefa = tarefa.Id,
    //            Caminho = caminho

    //        };
    //        _context.AnexosDasTarefas.Add(anexo);
    //    }

    //    _context.SaveChanges();

    //    return Ok();
    //}

}
