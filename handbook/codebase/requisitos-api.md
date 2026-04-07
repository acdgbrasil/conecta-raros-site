# Especificação de Dados Requeridos - Frontend Conecta Raros

Este documento elenca os dados necessários que o frontend da Landing Page do **Conecta Raros** precisa consumir para renderizar os componentes interativos. Ele serve como guia para a equipe de backend estruturar os contratos `OpenAPI v3` no repositório central (`contracts`).

## 1. Hero Section (Métricas Globais)
A seção de destaque principal exibe grandes números consolidando o total de registros na plataforma.

**Endpoint Sugerido:** `GET /metrics/global`
**Dados Esperados (Response Schema):**
```json
{
  "totalRegistros": 15000,
  "sindromesMapeadas": 430,
  "precisaoIaPorcentagem": 98.5
}
```

## 2. Gráfico: Volume de Registros por Região
O primeiro card de dashboards simula um gráfico de barras indicando a quantidade de casos ou registros distribuídos por estados ou municípios. Ele possui barras laranjas (dados atuais) e cinzas (projeções ou metas).

**Endpoint Sugerido:** `GET /metrics/regional-volume`
**Dados Esperados (Array de Objetos):**
```json
[
  {
    "localidade": "Fortaleza",
    "casos": 210,
    "tipo": "consolidado" // Determina a cor no gráfico (laranja)
  },
  {
    "localidade": "Janeiro", // Eixo X pode ser mês no caso de projeção
    "casos": 350,
    "tipo": "projecao" // Determina a cor no gráfico (cinza/inativo)
  }
]
```

## 3. Painel de Insights IA
Card dinâmico que rotaciona (auto-slide) de tempos em tempos exibindo as principais conclusões que a IA encontrou nos dados. Atualmente a interface comporta **4** insights principais em carrossel.

**Endpoint Sugerido:** `GET /insights/highlights`
**Dados Esperados (Array de 4 Objetos):**
```json
[
  {
    "valorDestaque": "39%",
    "descricao": "Score de confiança de que os mapeamentos genéticos recentes estão correlacionados a agrupamentos ("clusters") familiares identificados."
  },
  {
    "valorDestaque": "12k",
    "descricao": "Novas variantes genéticas categorizadas automaticamente por nosso modelo de Machine Learning nas últimas 48 horas."
  }
]
```

## 4. Feed de Atividade Recente
Uma lista mostrando os últimos acontecimentos da plataforma (validações, novos clusters, entradas de dados).

**Endpoint Sugerido:** `GET /activities/recent` ou **WebSocket (AsyncAPI)**
**Dados Esperados:**
```json
[
  {
    "idEvento": "evt-12345",
    "tipoEvento": "VALIDACAO_SINDROME", // Usado para mapear o ícone visual (ex: ícone de check verde)
    "titulo": "Síndrome Validada",
    "descricao": "Paciente #4928 - Complexo de Hospitais SP",
    "tempoRelativo": "Há 2 min" // Ou ISO Timestamp (2025-10-24T10:30:00Z) para o front formatar
  },
  {
    "idEvento": "evt-12346",
    "tipoEvento": "NOVO_CLUSTER",
    "titulo": "Novo Cluster Identificado",
    "descricao": "Agrupamento familiar de 14 indivíduos em região endêmica de consanguinidade.",
    "tempoRelativo": "Há 12 min"
  }
]
```
