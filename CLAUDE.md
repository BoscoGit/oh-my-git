# Oh My Git! — Contexto do Projeto

## O que é este projeto

**Oh My Git!** é um jogo open-source educacional que ensina Git através de uma metáfora de "máquina do tempo". Commits são snapshots, branches são linhas do tempo paralelas, merge é fundir universos, etc.

- Engine: **Godot 3.x** (não Godot 4)
- Repositório original: `git-learning-game/oh-my-git` (upstream)
- Fork do usuário: `BoscoGit/oh-my-git` (origin)
- Linguagem dos scripts: GDScript

## Objetivo do usuário

Contribuir com uma **tradução completa do jogo para Português do Brasil (pt-BR)**, dividida em duas Pull Requests:

- **PR1** — Infraestrutura i18n + menu de seleção de idioma + tradução da UI
- **PR2** — Tradução do conteúdo dos níveis (títulos, descrições, objetivos, parabéns)

O fluxo é: desenvolver e testar no fork → abrir PR no upstream quando estiver pronto.

## Estado atual das branches

### `feature/i18n-language-menu` (PR #1 no fork)
Infraestrutura de internacionalização completa:
- `scenes/i18n.gd` — autoload que carrega `translations/*.json` no `TranslationServer` ao iniciar
- `translations/en.json` e `translations/pt_BR.json` — strings da UI
- `scenes/title.tscn / title.gd` — botão **Language** + painel de seleção de idioma
- `scenes/game.gd` — salva/restaura o locale no savegame (`user://savegame.json`)
- Cenas com textos longos (`no_git.tscn`, `survey.tscn`, `level_select.tscn`) usam chaves semânticas (`NO_GIT_MESSAGE`, `SURVEY_THANKS_TEXT`, `SURVEY_HELP_TEXT`)
- `scenes/level_select.gd` — dica do badge usa `tr()`
- `scenes/file_browser.gd` — notificação "Click on these files to edit them!" usa `tr()`

### `feature/i18n-level-translations` (PR #2 no fork) ← branch atual
Tradução do conteúdo dos 47 níveis ativos:
- `scenes/level.gd` — overlay de locale: ao carregar um nível, busca `levels/<locale>/<capitulo>/<nivel>` e sobrepõe `title`, `description`, `cli`, `congrats` e `win_descriptions`
- `levels/pt_BR/` — 47 arquivos traduzidos em 12 capítulos: intro, files, branches, merge, index, remotes, changing-the-past, shit-happens, workflows, bisect, stash, tags
- Cada arquivo traduzido contém apenas os campos traduzíveis; `[setup]` e `[win]` (bash scripts) ficam sempre no original inglês
- `[win_descriptions]` mapeia os textos dos objetivos (extraídos dos comentários `#` do `[win]`) para pt-BR

## Arquitetura de tradução

```
Godot 3 auto-translates Label/Button text via tr() on render
    ↓
i18n.gd (autoload) loads translations/*.json into TranslationServer
    ↓
game.gd restores saved locale on startup
    ↓
level.gd overlays levels/pt_BR/<chapter>/<level> over English originals
```

**Para adicionar um novo idioma:**
1. Criar `translations/<locale>.json` com as strings da UI
2. Criar `levels/<locale>/` espelhando a estrutura de capítulos/níveis
3. Adicionar o locale ao array `LOCALES` em `scenes/i18n.gd`

## Estrutura do projeto

```
scenes/          Scripts GDScript e cenas .tscn
levels/          Níveis em formato texto customizado (title, description, cli, congrats, setup, win)
levels/pt_BR/    Traduções pt-BR dos níveis (apenas campos de texto, sem scripts bash)
translations/    Arquivos JSON com strings da UI por locale
resources/       cards.json (descrições dos cards — não traduzido ainda)
```

## O que ainda pode ser feito (fora do escopo das PRs atuais)

- Traduzir o conteúdo dos **arquivos criados pelos scripts `[setup]`** (ex: `form.txt` no nível `risky`) — requer cuidado pois `[win]` pode fazer grep no conteúdo
- Traduzir as descrições dos **cards** em `resources/cards.json`
- Traduzir os capítulos `low-level` e `unused` (não estão na sequência principal)
- Adicionar outros idiomas além de pt-BR

## Observação sobre o upstream

O README avisa que o projeto está em **low-maintenance mode**. PRs grandes podem demorar para ser revisadas. Os mantenedores pedem para entrar em contato antes de trabalhar em mudanças grandes em arquivos `.tscn`.
