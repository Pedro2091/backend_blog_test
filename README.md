# Backend Blog Test

API REST em Ruby on Rails para um blog simples, com autenticação via JWT, usuários, posts e comentários.

## Stack

- Ruby 3.4.10
- Rails 8.1 (modo `--api`)
- PostgreSQL
- JWT (gem `jwt`) para autenticação
- `bcrypt` / `has_secure_password` para senhas
- Jbuilder para as respostas JSON
- RSpec para os testes

## Modelos

| Modelo  | Campos                                   | Associações                          |
|---------|-------------------------------------------|---------------------------------------|
| User    | `name`, `email`, `password` (hash)        | `has_many :posts`                     |
| Post    | `title`, `content`, `user`                | `belongs_to :user`, `has_many :comments` |
| Comment | `name`, `content`, `post`                 | `belongs_to :post`                    |

Ao apagar um usuário, seus posts são apagados em cascata; ao apagar um post, seus comentários são apagados em cascata.

## Setup

```bash
bundle install
cp .env.example .env   # ajuste DB_HOST/DB_USERNAME/DB_PASSWORD se necessário
bin/rails db:setup     # cria o banco, carrega o schema e roda o seed
```

## Rodando o servidor

```bash
bin/rails server
```

A API sobe em `http://localhost:3000`.

## Rodando os testes

```bash
bundle exec rspec
```

## Autenticação

Rotas de autenticação (públicas):

| Método | Rota        | Descrição                          |
|--------|-------------|--------------------------------------|
| POST   | `/register` | Cria um usuário e retorna um token   |
| POST   | `/login`    | Autentica e retorna um token         |

O token deve ser enviado nas rotas protegidas via header:

```
Authorization: Bearer <token>
```

## Rotas

### Users (protegidas — exigem token em todas as ações)

| Método | Rota          |
|--------|---------------|
| GET    | `/users`      |
| GET    | `/users/:id`  |
| POST   | `/users`      |
| PATCH  | `/users/:id`  |
| DELETE | `/users/:id`  |

### Posts (leitura pública, escrita protegida)

| Método | Rota          | Autenticação |
|--------|---------------|--------------|
| GET    | `/posts`      | Não          |
| GET    | `/posts/:id`  | Não          |
| POST   | `/posts`      | Sim          |
| PATCH  | `/posts/:id`  | Sim          |
| DELETE | `/posts/:id`  | Sim          |

### Comments (aninhadas em posts)

| Método | Rota                        |
|--------|------------------------------|
| GET    | `/posts/:post_id/comments`   |
| POST   | `/posts/:post_id/comments`   |

## Exemplos de uso

**Registro**

```bash
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{"user": {"name": "Maria", "email": "maria@teste.com", "password": "senha123", "password_confirmation": "senha123"}}'
```

**Login**

```bash
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{"email": "maria@teste.com", "password": "senha123"}'
```

**Criar post (autenticado)**

```bash
curl -X POST http://localhost:3000/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"post": {"title": "Meu post", "content": "Conteúdo do post"}}'
```
