# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Initial project structure.
- Landing page mockups and integration (`index.html`, `styles.css`).
- Dashboard modular bento grid design (`dashboard.html`, `dashboard.css`, `dashboard.js`).
- Migração para infraestrutura padrão ACDG (Dockerfile, Makefile, CI/CD, Handbook).
- Integração do dashboard com o serviço Social Care via REST API (`config.js`, `api-client.js`, `dashboard-data.js`).
- Injeção de configuração em runtime via `scripts/docker-entrypoint.sh` (lê `API_BASE_URL` e `API_TOKEN` do ambiente, gera `runtime-config.js` no startup do container).
- Estados de loading, erro e vazio com skeleton UI no dashboard.

### Changed
- Dashboard: páginas "Relatórios Clínicos" e "Modelos Preditivos" removidas por falta de endpoints na API contratada.
- OCI label `image.source` corrigido para apontar ao repositório real (`acdgbrasil/conecta-raros-site`).
- `.env.example` atualizado para refletir a Social Care API (`https://social-care.acdgbrasil.com.br/api/v1`).

### Security
- Token JWT (`API_TOKEN`) injetado exclusivamente via variável de ambiente do K3s (origem: Bitwarden Secrets Manager). Nunca commitado em código.
