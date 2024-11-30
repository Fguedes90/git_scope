# Git Scope 🔍

Git Scope é uma ferramenta CLI poderosa para gerenciar e filtrar diffs do Git de forma inteligente, especialmente útil para projetos Python/Django com múltiplas aplicações e diferentes tipos de arquivos.

[![PyPI version](https://badge.fury.io/py/git-scope.svg)](https://badge.fury.io/py/git-scope)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Características

- 🎯 Filtragem inteligente de diffs baseada em padrões
- 🔄 Atualização automática da branch principal
- 🎨 Interface CLI amigável e colorida
- 📦 Suporte a múltiplas aplicações Django
- 🛠️ Configuração flexível via arquivo `.diffignore`

## 🚀 Instalação

```bash
# Via pip
pip install git-scope

# Via Poetry
poetry add git-scope
```

## 📖 Uso Básico

```bash
# Verificar a instalação
git-scope hello

# Gerar um diff limpo
git-scope diff output.diff

# Filtrar diff para uma aplicação específica
git-scope diff output.diff --app minha_app

# Pular atualização da branch principal
git-scope diff output.diff --skip-git-update
```

## ⚙️ Configuração

### Arquivo .diffignore

O Git Scope usa um arquivo `.diffignore` para definir padrões de exclusão. Padrões padrão incluem:

```plaintext
*/migrations/*
*.js
*.jsx
*.ts
*.tsx
*.css
*.scss
frontend/*
static/*
# ... adicione seus próprios padrões
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Aqui está como você pode ajudar:

1. Faça um Fork do projeto
2. Crie sua Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a Branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Documentação

Para documentação detalhada, consulte:
- [Guia de Início Rápido](docs/guides/getting-started.md)
- [Referência da API](docs/api/README.md)
- [Exemplos](docs/examples/README.md)

## 🎯 Motivação

Git Scope nasceu da necessidade de simplificar a revisão de código em projetos complexos, especialmente aqueles com múltiplas tecnologias e aplicações. Inspirado em um script de limpeza de diffs, evoluiu para uma ferramenta completa de gerenciamento de escopo Git.

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

Feito com ❤️ para a comunidade de desenvolvedores 