# syntax=docker/dockerfile:1.7

# ============================================================
# Stage 1: Build & Prepare
# ============================================================
FROM nginx:1.29-alpine AS build

WORKDIR /build

# Labels OCI obrigatórios (validados pela CI)
LABEL org.opencontainers.image.source="https://github.com/acdgbrasil/conecta-raros-site"
LABEL org.opencontainers.image.description="ACDG svc-conecta-raros-frontend service"
LABEL org.opencontainers.image.licenses="Proprietary"

# Criar configuração customizada do Nginx para suportar porta 3000 e Liveness/Readiness
RUN echo 'server {' > /build/nginx.conf && \
    echo '    listen 3000;' >> /build/nginx.conf && \
    echo '    server_name localhost;' >> /build/nginx.conf && \
    echo '    root /usr/share/nginx/html;' >> /build/nginx.conf && \
    echo '    index index.html;' >> /build/nginx.conf && \
    echo '    location / {' >> /build/nginx.conf && \
    echo '        try_files $uri $uri/ /index.html;' >> /build/nginx.conf && \
    echo '    }' >> /build/nginx.conf && \
    echo '    location /health {' >> /build/nginx.conf && \
    echo '        default_type application/json;' >> /build/nginx.conf && \
    echo '        return 200 "{\"status\": \"ok\"}";' >> /build/nginx.conf && \
    echo '    }' >> /build/nginx.conf && \
    echo '    location /ready {' >> /build/nginx.conf && \
    echo '        default_type application/json;' >> /build/nginx.conf && \
    echo '        return 200 "{\"status\": \"ready\", \"checks\": {}}";' >> /build/nginx.conf && \
    echo '    }' >> /build/nginx.conf && \
    echo '}' >> /build/nginx.conf

# ============================================================
# Stage 2: Runtime (imagem slim/alpine)
# ============================================================
FROM nginx:1.29-alpine

# OCI labels required on final image too
LABEL org.opencontainers.image.source="https://github.com/acdgbrasil/conecta-raros-site"
LABEL org.opencontainers.image.description="ACDG svc-conecta-raros-frontend service"
LABEL org.opencontainers.image.licenses="Proprietary"

WORKDIR /usr/share/nginx/html

# Remover default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copiar config customizado gerado no estágio anterior
COPY --from=build /build/nginx.conf /etc/nginx/conf.d/default.conf

# Copiar estáticos do frontend
COPY src/ ./

COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
