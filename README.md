# Miaudota - Microsserviços MongoDB (Usuários e Adoção)

Os dois microsserviços que usam **MongoDB Atlas**: **Usuários** (cadastro, login com JWT, perfil, exclusão de conta) e **Adoção** (animais, favoritos e solicitações de adoção), ambos com CRUD completo e Swagger.

> Arquitetura de Soluções em Nuvem (PUCPR) - PJBL Miaudota - Entrega 3. Integrantes em [GRUPO.md](GRUPO.md).

## Arquitetura

Clean Architecture (Domain / Application / Infrastructure / Presentation) combinada com **Vertical Slice**: cada funcionalidade fica em `src/<serviço>/casos-de-uso/<feature>/`, com o caso de uso e o controller lado a lado.

Cada serviço é dividido em `domain/` (entidades e portas), `casos-de-uso/<feature>/` (Vertical Slice: caso de uso + controller na mesma pasta), `infrastructure/` (adaptadores Mongoose, bcrypt, JWT) e `presentation/`. O domínio não importa framework nenhum.

As regras de dependência são verificadas automaticamente pelos **testes de arquitetura** (`src/testes/arquitetura.test.ts`): o domínio não importa frameworks, os casos de uso não dependem de infraestrutura, uma fatia não importa outra, e um serviço não importa outro.

```
src/
  shared/            erros de domínio, eventos, autenticação interna, configuração
  usuarios/
  adocao/
  testes/            testes unitários e de arquitetura
```

## Tecnologias

Node.js 20, TypeScript, NestJS 10, Swagger (`@nestjs/swagger`), class-validator, RabbitMQ (eventos), Docker, testes com `node:test`.
MongoDB Atlas (Mongoose), bcrypt, JWT.

## Endpoints principais

- **Usuários** (`:3101`): `POST /usuarios`, `POST /usuarios/login`, `GET /usuarios/me`, `DELETE /usuarios/me`, `POST /internos/usuarios/resumos`
- **Adoção** (`:3102`): `POST|GET /animais`, `GET /animais/sugestoes`, `GET /animais/meus`, `GET|PATCH|DELETE /animais/:id`, `POST|GET /favoritos`, `DELETE /favoritos/:idAnimal`, `POST /solicitacoes`, `GET /solicitacoes/enviadas|recebidas`, `GET /solicitacoes/:id`, `PATCH /solicitacoes/:id/status`
- Swagger de cada serviço em `/docs`

## Como executar

### 1. Pelas imagens do Docker Hub (recomendado)

| Serviço | Imagem no Docker Hub |
|---|---|
| Microsserviço de Usuários | `sofhiachromiec/pjbl-usuarios:v1` |
| Microsserviço de Adoção | `sofhiachromiec/pjbl-adocao:v1` |

Crie um `.env` a partir de `.env.example` (chaves, banco e RabbitMQ) e rode:

```bash
docker run --rm -p 3101:3101 --env-file .env sofhiachromiec/pjbl-usuarios:v1   # Microsserviço de Usuários
docker run --rm -p 3102:3102 --env-file .env sofhiachromiec/pjbl-adocao:v1   # Microsserviço de Adoção
```

URLs na nuvem (Azure Container Apps):

| Serviço | URL pública | Swagger |
|---|---|---|
| Microsserviço de Usuários | https://miaudota-usuarios.proudground-4968a7f1.canadacentral.azurecontainerapps.io | https://miaudota-usuarios.proudground-4968a7f1.canadacentral.azurecontainerapps.io/docs |
| Microsserviço de Adoção | https://miaudota-adocao.proudground-4968a7f1.canadacentral.azurecontainerapps.io | https://miaudota-adocao.proudground-4968a7f1.canadacentral.azurecontainerapps.io/docs |

O frontend publicado (Azure Static Web Apps) está em https://red-mushroom-01f218510.4.azurestaticapps.net.

### 2. Localmente com Node

```bash
cp .env.example .env     # preencha os valores
npm install
npm run start:all        # compila e sobe os serviços deste repositório
```

O Swagger de cada serviço fica em `http://localhost:<porta>/docs` (use o botão **Authorize** para informar `chave-interna` e, quando pedido, `usuario-id` e `usuario-tipo`).

## Testes

```bash
npm test
```

Executa os testes unitários (regras de negócio e casos de uso, com dublês em memória) e os testes de arquitetura.

## Publicar as imagens

```bash
docker login
./publicar.sh
```

## Integrantes

- Sofhia Chromiec
- Fernanda Giacobbo
- Júlia Melo
- Pedro Serafim
