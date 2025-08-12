using GerenciadorDeTarefa.Domain.Contas;
using GerenciadorDeTarefa.Domain.Helpers;
using Microsoft.AspNetCore.Mvc;

namespace GerenciadorDeTarefa.Api.Controllers;

[ApiController]
[Route("[controller]")]
public class BaseApiController : ControllerBase
{
    protected IUsuarioDaSessao Usuario => HttpContext.Usuario()!;
}
