# language: pt

Funcionalidade: Filtragem por Padrões
  Como um desenvolvedor
  Eu quero filtrar diffs usando padrões do .diffignore
  Para ver apenas as mudanças relevantes para minha revisão

  Cenário: Filtrar arquivos usando .diffignore
    Dado que existe um arquivo .diffignore com os padrões:
      """
      *.js
      */migrations/*
      """
    E que existe um diff com mudanças em múltiplos arquivos
    Quando eu executo o comando de filtragem
    Então apenas os arquivos que não correspondem aos padrões devem aparecer no resultado
    E a estrutura do diff original deve ser mantida

  Cenário: Suporte a wildcards
    Dado que existe um arquivo .diffignore com wildcards:
      """
      test_*.py
      src/*/temp/
      """
    Quando eu executo o comando de filtragem
    Então arquivos como "test_utils.py" devem ser ignorados
    E arquivos em diretórios como "src/app1/temp/" devem ser ignorados

Funcionalidade: Filtragem por Diretório
  Como um desenvolvedor
  Eu quero filtrar diffs por diretório específico
  Para focar em mudanças de uma área específica do código

  Cenário: Filtrar por diretório único
    Dado que existe um diff com mudanças em múltiplos diretórios
    Quando eu executo o comando com o filtro de diretório "src/core"
    Então apenas mudanças no diretório "src/core" devem aparecer
    E a estrutura do diff deve ser mantida

  Cenário: Filtrar por múltiplos diretórios
    Dado que existe um diff com mudanças em múltiplos diretórios
    Quando eu executo o comando com os filtros "src/core,tests/unit"
    Então apenas mudanças nos diretórios especificados devem aparecer
    E a ordem das mudanças deve ser mantida

  Cenário: Diretório sem mudanças
    Dado que existe um diff com mudanças
    Quando eu executo o comando com filtro para um diretório sem mudanças
    Então deve ser exibida uma mensagem informando que não há mudanças
    E o programa deve terminar com status 0

Funcionalidade: Filtragem por Tipo de Arquivo
  Como um desenvolvedor
  Eu quero filtrar diffs por extensão de arquivo
  Para revisar apenas arquivos de um tipo específico

  Cenário: Filtrar por única extensão
    Dado que existe um diff com diferentes tipos de arquivo
    Quando eu executo o comando com filtro ".py"
    Então apenas arquivos Python devem aparecer no resultado

  Cenário: Filtrar por múltiplas extensões
    Dado que existe um diff com diferentes tipos de arquivo
    Quando eu executo o comando com filtros ".py,.yml"
    Então apenas arquivos Python e YAML devem aparecer no resultado
    E a ordem original dos arquivos deve ser mantida

Funcionalidade: Output Colorido
  Como um desenvolvedor
  Eu quero ver o diff com sintaxe colorida
  Para identificar mudanças mais facilmente

  Cenário: Coloração padrão
    Dado que existe um diff com adições e remoções
    Quando eu executo o comando sem flags específicas
    Então linhas adicionadas devem aparecer em verde
    E linhas removidas devem aparecer em vermelho

  Cenário: Desabilitar cores
    Dado que existe um diff com adições e remoções
    Quando eu executo o comando com flag --no-color
    Então o output não deve conter códigos ANSI de cor

Funcionalidade: Modo Compacto
  Como um desenvolvedor
  Eu quero ver uma versão compacta do diff
  Para ter uma visão geral rápida das mudanças

  Cenário: Compactação de grandes mudanças
    Dado que existe um diff com blocos grandes de mudança
    Quando eu executo o comando em modo compacto
    Então blocos grandes devem ser resumidos
    E deve mostrar quantidade de linhas omitidas

  Cenário: Estatísticas no modo compacto
    Dado que existe um diff com múltiplas mudanças
    Quando eu executo o comando em modo compacto
    Então deve mostrar um sumário com total de arquivos modificados
    E deve mostrar total de linhas adicionadas/removidas

Funcionalidade: Exportação
  Como um desenvolvedor
  Eu quero salvar o diff filtrado em um arquivo
  Para poder compartilhar ou revisar depois

  Cenário: Exportar para arquivo novo
    Dado que existe um diff filtrado
    Quando eu executo o comando de exportação para "output.patch"
    Então o arquivo deve ser criado
    E deve conter o diff formatado corretamente

  Cenário: Exportar para arquivo existente
    Dado que existe um arquivo "output.patch"
    Quando eu executo o comando de exportação para "output.patch"
    Então deve perguntar se desejo sobrescrever
    E deve sobrescrever apenas se confirmado

Funcionalidade: Estatísticas Básicas
  Como um desenvolvedor
  Eu quero ver estatísticas das mudanças
  Para entender o impacto das alterações

  Cenário: Visualizar estatísticas completas
    Dado que existe um diff com múltiplas mudanças
    Quando eu executo o comando com flag --stats
    Então deve mostrar total de arquivos modificados
    E deve mostrar total de linhas adicionadas/removidas por tipo de arquivo
    E deve mostrar tamanho total do diff

Funcionalidade: Detecção de Movimentação
  Como um desenvolvedor
  Eu quero identificar código movido entre arquivos
  Para não revisar o mesmo código duas vezes

  Cenário: Detectar código movido
    Dado que existe um diff onde código foi movido entre arquivos
    Quando eu executo o comando com flag --detect-moves
    Então deve identificar os blocos movidos
    E deve mostrar arquivo de origem e destino
    E deve mostrar porcentagem de similaridade

Funcionalidade: Comandos Básicos
  Como um desenvolvedor
  Eu quero usar comandos intuitivos
  Para não precisar consultar a documentação constantemente

  Cenário: Ajuda do comando
    Quando eu executo o comando com --help
    Então deve mostrar descrição clara dos comandos
    E deve mostrar exemplos de uso
    E deve mostrar todas as flags disponíveis

  Cenário: Erro de uso
    Quando eu executo o comando com parâmetros inválidos
    Então deve mostrar mensagem de erro clara
    E deve sugerir o uso correto
    E deve terminar com status de erro

Funcionalidade: Configuração
  Como um desenvolvedor
  Eu quero configurar preferências padrão
  Para não repetir opções comuns

  Cenário: Carregar configuração do projeto
    Dado que existe um arquivo .git-scope.yml no projeto
    Quando eu executo qualquer comando
    Então deve usar as configurações do arquivo
    E deve sobrescrever configurações globais

  Cenário: Inicializar configuração
    Quando eu executo o comando init
    Então deve criar arquivo .git-scope.yml
    E deve incluir todas as configurações padrão
    E deve incluir comentários explicativos

  Esquema do Cenário: Validar configurações
    Dado que existe um arquivo .git-scope.yml
    Quando eu defino o valor de "<config>" como "<valor>"
    Então deve <resultado>

    Exemplos:
      | config           | valor   | resultado                    |
      | max_diff_size   | -1      | mostrar erro de validação    |
      | color_mode      | invalid | mostrar erro de validação    |
      | max_diff_size   | 1000    | aceitar o valor              |
      | color_mode      | auto    | aceitar o valor              | 