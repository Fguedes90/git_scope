.PHONY: help install dev clean test lint format check coverage docs build publish docs-dev docs-init version changelog validate-docs deploy-docs

help:  ## Mostra esta mensagem de ajuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install:  ## Instala o pacote e dependências
	poetry install

dev:  ## Configura ambiente de desenvolvimento
	poetry install --with dev
	poetry run pre-commit install
	poetry run pre-commit autoupdate

clean:  ## Limpa arquivos temporários e caches
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name "*.egg" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name ".coverage" -exec rm -rf {} +
	find . -type d -name "htmlcov" -exec rm -rf {} +
	find . -type d -name "dist" -exec rm -rf {} +
	find . -type d -name "build" -exec rm -rf {} +

test:  ## Roda todos os testes
	poetry run pytest

test-unit:  ## Roda apenas testes unitários
	poetry run pytest tests/unit -v

test-integration:  ## Roda apenas testes de integração
	poetry run pytest tests/integration -v

test-acceptance:  ## Roda apenas testes de aceitação
	poetry run pytest tests/acceptance -v

test-watch:  ## Roda testes em modo watch
	poetry run ptw

lint:  ## Roda todas as verificações de código
	poetry run flake8 src tests
	poetry run mypy src tests
	poetry run black --check src tests
	poetry run isort --check-only src tests

format:  ## Formata o código automaticamente
	poetry run black src tests
	poetry run isort src tests

check:  ## Roda todas as verificações (lint + test)
	make lint
	make test

coverage:  ## Gera relatório de cobertura de testes
	poetry run pytest --cov=git_scope --cov-report=html
	@echo "Relatório HTML gerado em htmlcov/index.html"

docs-init:  ## Inicializa a documentação Mintlify
	@if ! command -v mintlify &> /dev/null; then \
		echo "Instalando Mintlify..."; \
		npm install -g mintlify; \
	fi
	@if [ ! -f mint.json ]; then \
		echo "Criando configuração Mintlify..."; \
		mintlify init; \
	fi

docs-dev:  ## Inicia servidor de desenvolvimento da documentação
	@if ! command -v mintlify &> /dev/null; then \
		echo "Mintlify não encontrado. Execute 'make docs-init' primeiro."; \
		exit 1; \
	fi
	mintlify dev

docs:  ## Gera e valida a documentação
	@if ! command -v mintlify &> /dev/null; then \
		echo "Mintlify não encontrado. Execute 'make docs-init' primeiro."; \
		exit 1; \
	fi
	mintlify build
	mintlify validate

build:  ## Constrói o pacote para distribuição
	poetry build

publish:  ## Publica o pacote no PyPI
	poetry publish

publish-test:  ## Publica o pacote no TestPyPI
	poetry config repositories.testpypi https://test.pypi.org/legacy/
	poetry publish -r testpypi

update-deps:  ## Atualiza todas as dependências
	poetry update

security-check:  ## Verifica vulnerabilidades nas dependências
	poetry run safety check

type-check:  ## Verifica tipagem estática
	poetry run mypy src tests

pre-commit:  ## Roda pre-commit em todos os arquivos
	poetry run pre-commit run --all-files

version:  ## Show current version
	poetry version

changelog:  ## Generate changelog
	git-cliff --output CHANGELOG.md

validate-docs:  ## Validate documentation
	mintlify verify

deploy-docs:  ## Deploy documentation to Mintlify
	mintlify deploy

ci:  ## Roda todas as verificações de CI localmente
	make clean
	make install
	make check
	make coverage
	make build
	make validate-docs

# Variáveis de ambiente e configuração
export PYTHONPATH := src:$(PYTHONPATH)
export PYTHONWARNINGS := ignore