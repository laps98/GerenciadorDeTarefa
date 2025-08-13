# Projeto Tarefas

## 1. Banco de Dados Local (MySQL com Docker)

Criar container MySQL com Docker:
```bash
docker run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=tarefas_db -p 3306:3306 mariadb:10.5
```

Startar container:
```bash
docker start mysql
```

## 2. Backend - API em C# (ASP.NET Core MVC + DDD + Code First + JWT)
## 3. Funcionalidades da API
#### CRUD de Tarefas (Create, Read, Update, Delete)
#### Upload e exclusão de anexos locais
#### Autenticação via JWT para proteger rotas (login com email/senha)
#### Paginação e filtros (título, data)

## Como rodar o projeto
#### Subir banco MySQL com Docker
#### Ajustar connection string no backend
#### Rodar migrations para criar banco:
```bash
dotnet ef database update
```
#### Executar API:
```bash
dotnet run
```
#### Rodar app Flutter:
```bash
flutter run
```
#### Login com JWT
```bash
email: admin@admin
senha: 123456
```
