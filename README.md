# svc-conecta-raros-frontend

Frontend do portal público e dashboard do **Conecta Raros**, gerido dentro da infraestrutura da ACDG Edge Private Cloud.

## Tecnologias e Arquitetura
Este repositório contém puramente assets estáticos (HTML, CSS e JS Vanilla).
Em produção, a aplicação é montada em uma imagem Nginx Alpine multi-stage para ser servida com altíssima performance nos clusters K3s.

## Como Rodar Localmente (Desenvolvimento)

A forma padrão definida pela organização é utilizando Docker Compose:

1. Clone o repositório.
2. Crie ou verifique o arquivo `.env` (use o `.env.example` como base).
3. Execute o Make target:
   ```bash
   make dev
   ```
   *Isto via levantar o Nginx servindo os arquivos na porta `3000`*.
4. Acesse `http://localhost:3000`

## Como Contribuir

- **Handbooks:** Todas as decisões arquiteturais e operacionais devem ser documentadas em `handbook/`.
- **Git Flow:** Nós utilizamos o modelo de branch `feat/*`, `fix/*`, `chore/*`, `docs/*` a partir da main.
- **Conventional Commits:** Seus commits devem ser formatados (`feat: add something`, `fix: resolving bug`).
- **PRs:** Abra uma Pull Request seguindo o template do repositório antes de realizar o merge. O CI irá barrar caso a cobertura de código caia do threshold configurado em `scripts/check_coverage.sh`.

## Contratos
Como este é um projeto frontend, dependemos de contratos de Backend. Todas as integrações (OpenAPI e AsyncAPI) são regidas pela "Fonte da Verdade" oficial:
[https://github.com/acdgbrasil/contracts](https://github.com/acdgbrasil/contracts)
