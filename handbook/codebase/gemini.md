# Fonte da Verdade para Integrações API

Este documento serve como a referência principal e central para qualquer integração de backend a ser realizada no frontend do projeto **Conecta Raros**.

**Repositório de Contratos (Single Source of Truth):**
👉 [https://github.com/acdgbrasil/contracts](https://github.com/acdgbrasil/contracts)

## Diretrizes de Integração
- **APIs Síncronas (REST/HTTP):** Todas as requisições em tempo real para alimentar os dashboards e formulários da Landing Page devem obedecer aos contratos **OpenAPI v3** definidos no repositório acima.
- **Eventos Assíncronos:** Qualquer consumo de eventos ou mensageria deve seguir os contratos **AsyncAPI v3**.
- Em caso de dúvidas sobre as tipagens, endpoints, payloads ou modelos de dados (schemas), o repositório `contracts` tem a palavra final para evitar inconsistências entre o front-end e os microserviços.
