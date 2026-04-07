SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

.PHONY: help deps build build-release dev test coverage coverage-report ci clean

help: ## Lista os comandos disponíveis
	@echo "Uso:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_.-]+:.*##/ {printf "  %-16s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

deps: ## Resolve dependências (N/A para HTML/CSS puramente, mas obrigatório na esteira)
	@echo "Nenhuma dependência externa para instalar na raiz do frontend puro."

build: ## Build de debug
	docker build -t acdgbrasil/svc-conecta-raros-frontend:debug .

build-release: ## Build de release/produção
	docker build -t acdgbrasil/svc-conecta-raros-frontend:release -f Dockerfile .

dev: ## Executa o serviço localmente
	docker compose up --build

test: ## Executa os testes
	@echo "Teste mockado: Nenhum framework de teste configurado para HTML puro ainda."

coverage: ## Executa testes + gate de cobertura
	./scripts/check_coverage.sh 80

coverage-report: ## Gera relatório de cobertura
	@echo "Relatório mockado finalizado."

ci: deps build-release coverage ## Pipeline local semelhante ao CI
	@echo "Pipeline local simulado completado com sucesso."

clean: ## Limpa artefatos de build
	docker compose down -v --remove-orphans || true
	docker rmi acdgbrasil/svc-conecta-raros-frontend:debug acdgbrasil/svc-conecta-raros-frontend:release || true
