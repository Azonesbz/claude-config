# claude-config

Configuration **globale** de [Claude Code](https://docs.claude.com/en/docs/claude-code) : règles méthodologiques, sous-agents et commandes, partagés entre **tous les projets** et **toutes les machines**.

> Ce repo est la **source de vérité versionnée**. Son contenu est **copié** dans `~/.claude/` par `install.sh` (macOS/Linux) ou `install.ps1` (Windows). Claude Code lit toujours `~/.claude/`, **jamais ce repo directement**.

## Ce que couvre cette config

### 📐 Règles (`rules/`) — méthodo chargée dans chaque session

| Règle | Couvre |
|-------|--------|
| `flow.md` | Pipeline `/flow` : plan → PR → exécution par tranches |
| `incremental-implementation.md` | Découpe en **tranches petites et vérifiables** |
| `test-driven-development.md` | TDD Red-Green-Refactor, motif Prove-It, **AAA** |
| `code-organization.md` | Taille fichier (~100 l.), **responsabilité unique** (SRF), fichiers d'entrée fins |
| `clean-code.md` | Granularité **fonction** : fn courtes, ≤3 params, flux plat, nommage, pureté |
| `code-review-and-quality.md` | Revue finale en **5 axes** (comportement, sécurité, maintenabilité, perf, UX) |

### 🤖 Sous-agents (`agents/`)

| Agent | Rôle |
|-------|------|
| `architecture` | Valide le **placement** des fichiers selon les zones du dépôt |
| `factorizer` | **Découpe** les fichiers trop gros (≤100 l., 1 module = 1 responsabilité) |
| `test-builder` | Écrit les **tests avant** le code (TDD) |
| `test-runner` | **Lance et diagnostique** la suite de tests |
| `verifier` | **Rapport de fin de tâche** : demandé vs livré |
| `conventional-commit` | Messages **Conventional Commits**, commit + push prudent |

### ⚡ Commandes (`commands/`)

| Commande | Rôle |
|----------|------|
| `/flow <demande>` | Orchestrateur : plan, branche, PR, exécution TDD par tranches |

## Installation

```bash
# macOS / Linux
./install.sh

# Windows (PowerShell)
.\install.ps1
```

Copie `commands/`, `agents/` et `rules/` vers `~/.claude/`. `settings.json` n'est **pas** géré (perso par machine, hors repo).

## Modèle à deux niveaux

| Niveau | Emplacement | Pour quoi |
|--------|-------------|-----------|
| **Global** (ce repo) | `~/.claude/` | Méthodo **générique**, agnostique au projet |
| **Projet** | `<projet>/.claude/` + `CLAUDE.md` | Stack, scripts, conventions et règles **métier** propres au repo |

La config projet **étend** la globale : `settings` fusionnés en cascade, agents/commandes **ajoutés** (ou surchargés par nom), `CLAUDE.md` **additif**.

## Workflow de modification

1. **Édite dans ce repo** — jamais `~/.claude/` directement (écrasé au prochain install)
2. `./install.sh` pour activer
3. Vérifie dans `~/.claude/`
4. `git commit` ([Conventional Commits](https://www.conventionalcommits.org/)) + push

## Conventions

- Contenu des règles/agents en **français** ; messages de commit en **anglais** (Conventional Commits).
- **Une règle = un sujet** (SRF appliqué aux règles elles-mêmes) : pas de fichier fourre-tout.
