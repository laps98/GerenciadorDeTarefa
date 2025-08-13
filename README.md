1. Banco de Dados Local (MySQL com Docker)
Criar container MySQL com Docker
docker run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=tarefas_db -p 3306:3306 mariadb:10.5
startar container: docker start mysql 
parar container: docker stop mysql
reiniciar container: docker rm mysql

2. Backend - API em C# (ASP.NET Core MVC + DDD + Code First + JWT)

3. Funcionalidades da API
CRUD de Tarefas (Create, Read, Update, Delete)
Upload e exclusão de anexos locais
Autenticação via JWT para proteger rotas (login com email/senha)
Paginacao e filtros (titulo, data)

Login com JWT
Usuário admin: email: admin@admin, senha: 123456

Como rodar o projeto
Subir banco MySQL com docker (como no passo 1)

Ajustar connection string no backend

Rodar migrations para criar banco (dotnet ef database update)

Executar API (dotnet run)

Rodar app Flutter (flutter run)
