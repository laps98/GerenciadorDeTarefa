using GerenciadorDeTarefa.Domain.Components;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace GerenciadorDeTarefa.Api.Services;

public static class TokenService
{
    public static string GenerateToken()
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes(Constants.SecretKey);

        var claims = new List<(string key, string value)>
            {
                (CustomClaimType.Id, "1"),
                (ClaimTypes.Name, "User"),
                (ClaimTypes.Email, "user@user"),
            }.Where(q => !string.IsNullOrWhiteSpace(q.value))
            .Select(q => new Claim(q.key, q.value))
            .ToList();

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddHours(720),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha512Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}