# Guia de IA (GEMINI.md) - svc-conecta-raros-frontend

Este arquivo consolida as regras absolutas da organização **ACDG Edge Private Cloud** que a IA (Gemini ou qualquer outro agente) **DEVE** seguir inflexivelmente ao modificar ou expandir este repositório.

## 1. Regras de Ouro de Repositório e CI/CD
- **Nomenclatura:** Este repositório é um microsserviço independente nomeado como `svc-conecta-raros-frontend`.
- **Nenhum Segredo:** NENHUM segredo, senha ou token válido deve ser commitado no código, nem no `.env` (que deve estar no `.gitignore`), nem hardcoded em JS/HTML. Segredos devem ser geridos via Bitwarden Secrets Manager na infra.
- **Porta de Aplicação:** O serviço DEVE expor na porta `3000` (conforme configurado no `nginx.conf` e `Dockerfile`).
- **Comandos Make:** Sempre prefira testar, compilar e rodar via `make` (ex: `make dev`, `make build-release`). O `Makefile` já contempla a chamada ao Docker plugin moderno (`docker compose` ao invés de `docker-compose`).
- **CI/CD:** Qualquer push ou PR na branch `main` ativará o `.github/workflows/ci.yml`. O CI barrará se o `Dockerfile` não contiver as labels OCI obrigatórias.

## 2. Estrutura de Diretórios Inviolável
O repositório está subdividido para respeitar o padrão ACDG:
- `src/`: A raiz da aplicação de fato (arquivos originais HTML, CSS, JS, Assets). **Código fonte novo vai aqui.**
- `handbook/`: Guarda documentação viva.
  - `handbook/codebase/gemini.md`: Documento de fonte de verdade para contratos API (`acdgbrasil/contracts`).
  - `handbook/codebase/requisitos-api.md`: Contratos que combinamos para enviar à equipe de backend.
- `.github/workflows/`: Pipeline Actions usando workflow reutilizável.
- `scripts/`: Scripts utilitários (`check_coverage.sh`).
- Raiz (`/`): Destinada a definições em alto nível: `Dockerfile`, `Makefile`, `docker-compose.yml`, `README.md`, `CHANGELOG.md`.

## 3. Gestão de Handbook e Alterações Longas
Sempre que você criar uma feature nova significativa, documentar uma decisão de arquitetura técnica (como usar uma nova biblioteca JavaScript) ou relatar um erro catastrófico que você mesmo resolveu, crie os devidos arquivos dentro de `handbook/` (ex: `handbook/reports/SESSION_YYYY_MM_DD.md`).

## 4. Integrações e Contratos
Qualquer código em `src/app.js` ou `src/dashboard.js` que precise realizar um `fetch` ou consumir dados reais, DEVE tratar o repositório centralizado da organização (`https://github.com/acdgbrasil/contracts`) como a única Fonte da Verdade de Tipagens.
O backend expõe Liveness em `GET /health` e Readiness em `GET /ready` (o próprio *frontend container* expõe o mesmo no Nginx).

## 5. Docker OCI Padrão
Sempre preserve as 3 Labels padrão abaixo no `Dockerfile` (em todas as layers ativas):
```dockerfile
LABEL org.opencontainers.image.source="https://github.com/acdgbrasil/svc-conecta-raros-frontend"
LABEL org.opencontainers.image.description="ACDG svc-conecta-raros-frontend service"
LABEL org.opencontainers.image.licenses="Proprietary"
```

---
> **Nota de Contexto Gemini:** Leia as instruções acima antes de prosseguir com qualquer refatoração grave. Mantenha os arquivos existentes íntegros (HTML/CSS) nas implementações modulares baseadas em *Bento UI/Dark Mode* criadas até a data 2026-03-12.
