# Integração do Dashboard com a Social Care API

## Contexto
O dashboard do `conecta-raros-site` originalmente exibia dados 100% hardcoded em HTML.
A partir desta integração, o dashboard consome dados reais do serviço **Social Care**
(`acdgbrasil/contracts/services/social-care`), seguindo os contratos OpenAPI v3
definidos como fonte única de verdade.

## Arquitetura

```
dashboard.html (DOM com IDs)
    ↑ updates
dashboard.js (orquestrador — triggers de carga, busca debounced)
    ↑ chama
dashboard-data.js (mapeia respostas API → DOM, gerencia loading/error/empty)
    ↑ chama
api-client.js (fetch wrapper, headers de auth, timeout, error handling)
    ↑ lê
config.js (CR.config — defaults)
    ↑ sobrescrito por
runtime-config.js (gerado pelo entrypoint a partir de envs)
```

Tudo Vanilla JS sob o namespace global `window.CR`. Sem build step, sem framework.

## Endpoints consumidos

| Método | Path | Auth | Uso no dashboard |
|--------|------|------|------------------|
| GET | `/health` | público | Health check antes de tentar carregar pacientes |
| GET | `/patients?limit=&search=&cursor=` | Bearer JWT | Métricas e tabelas das páginas Visão Geral e Pacientes |
| GET | `/patients/{patientId}` | Bearer JWT | (Disponível para futuras telas de detalhe) |

Envelope de resposta padrão: `{ data: T, meta: { timestamp } }` — `api-client.js`
desempacota automaticamente.

## Configuração em runtime

A configuração é injetada em runtime pelo `scripts/docker-entrypoint.sh`, que lê
variáveis de ambiente do container e gera `/usr/share/nginx/html/runtime-config.js`
antes do nginx subir:

| Variável | Origem | Default |
|----------|--------|---------|
| `API_BASE_URL` | ConfigMap K3s | `https://social-care.acdgbrasil.com.br/api/v1` |
| `API_TOKEN` | **Bitwarden Secrets Manager** | (vazio — dashboard mostra estado de auth requerida) |

Esse padrão evita rebuild da imagem por ambiente: a mesma imagem `release` roda em
dev, staging e prod, variando apenas as envs do Pod.

⚠️ **Regra inviolável:** `API_TOKEN` **NUNCA** pode aparecer em código, `.env`
commitado, JS estático ou ConfigMap. A única origem aceita é o Bitwarden Secrets
Manager montado no Pod via Secret do Kubernetes.

## Páginas removidas

As páginas "Relatórios Clínicos" e "Modelos Preditivos (IA)" foram **removidas**
porque o contrato atual da Social Care API não expõe dados que sustentem essas
métricas (taxa de aprovação de laudos, precisão NLP, clusters detectados). Quando
o backend disponibilizar endpoints específicos, basta recriar as páginas seguindo
o mesmo padrão de `loadVisaoGeral()` / `loadPacientes()` em `dashboard-data.js`.

## Estados de UX

- **Loading:** overlay com spinner + skeleton bars nos métricas (`.skeleton-text`,
  `.skeleton-metric`).
- **Error:** mensagem inline com botão "Tentar novamente". Para 401/403, mensagem
  específica indicando que autenticação é necessária.
- **Empty:** ícone + mensagem "Nenhum paciente encontrado" no lugar das linhas da
  tabela.

## Verificação

1. Local: `make dev` → abre em `http://localhost:3000/dashboard.html` → loading
   aparece e dashboard tenta atingir a API configurada em `API_BASE_URL`.
2. Health check do nginx (não da API): `curl http://localhost:3000/health` deve
   retornar `{"status":"ok"}` (probe do K3s).
3. Sem token, dashboard exibe estado "Autenticação necessária" — comportamento
   esperado em ambientes sem secret configurado.
4. Com token válido (definido em `API_TOKEN`), métricas e tabelas populam com
   dados reais do Social Care.
