using GerenciadorDeTarefa.Api.Services;
using GerenciadorDeTarefa.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;

namespace GerenciadorDeTarefa.Api.Controllers;

[AllowAnonymous]
public class ContasController : BaseApiController
{
    private readonly IApplicationDbContext _context;

    public ContasController(IApplicationDbContext context)
    {
        _context = context;
    }

    [HttpPost("Token")]
    public IActionResult Autenticar([FromBody] LoginRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Password) || string.IsNullOrWhiteSpace(request.Email))
            return BadRequest(new { Message = "Login e a senha devem estar preeenchidos!" });


        if (request.Password == null ||  request.Password != "123456")
            return BadRequest(new { Message = "Usuário ou senha inválidos!" });

        var token = TokenService.GenerateToken();
        return Ok(new
        {
            Id = 1,
            Nome = "User",
            Email = "User@User",
            Token = token,
            ExpiresIn = 720 * 60 * 60
        });
    }
}