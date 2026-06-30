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
| `scalability-and-boundaries.md` | **Frontières** & échelle : couplage, dépendances dirigées, N+1, pagination, ouvert/fermé |
| `code-review-and-quality.md` | Revue finale en **5 axes** (comportement, sécurité, maintenabilité, perf, UX) |

### 🤖 Sous-agents (`agents/`)

| Agent | Rôle |
|-------|------|
| `linear` | **Pont ticket Linear ↔ plan** : lit le ticket source, met à jour le statut, poste le lien de la PR |
| `factorizer` | **Découpe** les fichiers trop gros (≤100 l., 1 module = 1 responsabilité) |
| `test-builder` | Écrit les **tests avant** le code (TDD) |
| `test-runner` | **Lance et diagnostique** la suite de tests |
| `verifier` | **Rapport de fin de tâche** : demandé vs livré |
| `conventional-commit` | Messages **Conventional Commits**, commit + push prudent |
| `store-deployer` | **Soumet l'app aux stores** (Google Play / App Store) via EAS Submit |

### ⚡ Commandes (`commands/`)

| Commande | Rôle |
|----------|------|
| `/flow <demande>` | Orchestrateur : plan, branche, PR, exécution TDD par tranches |

`/flow` accepte aussi une **référence Linear** (`ABC-123` ou URL `linear.app/.../issue/...`) comme source du plan, via l'agent `linear` (nécessite un connecteur MCP Linear ; sinon repli en mode texte). Voir `rules/flow.md`.

### 🛡️ Hooks (`hooks/`) — garde-fous d'enforcement

Hooks `PreToolUse` qui transforment des **règles** de `flow.md` en **blocages** réels (sortie `permissionDecision: deny`). Scripts shell autonomes, sans dépendance forte (`jq`, sinon `python3` ; **fail-open** si aucun n'est présent — jamais de workflow cassé).

| Hook | Bloque | Règle source |
|------|--------|--------------|
| `guard-git-add.sh` | `git add -A` / `--all` / `.` | staging ciblé (`flow.md`) |
| `guard-git-push.sh` | `git push --force` / `--force-with-lease` | pas de force-push sans accord (`flow.md`) |
| `guard-plan-file.sh` | écrire `plan.json` / `plan.yaml` / `plan.yml` | pas de fichier de plan versionné (`flow.md`) |

Chaque garde a un test AAA (`*.test.sh`, cas bloqué + cas passant) qui **reste dans le repo** et n'est pas déployé. Lancer : `bash hooks/<nom>.test.sh`.

## Installation

```bash
# macOS / Linux
./install.sh

# Windows (PowerShell)
.\install.ps1
```

Installe `commands/`, `agents/`, `rules/` et `hooks/` dans `~/.claude/` par **lien symbolique** (éditer le repo met à jour la config instantanément) ; repli automatique sur la **copie** si les liens ne sont pas supportés (Windows sans « Mode développeur » ni admin — relancer alors le script après chaque modif). `settings.json` n'est **pas** géré (perso par machine, hors repo).

### Activer les hooks (une fois, opt-in)

Les hooks ne se déclenchent qu'une fois **enregistrés** dans ton `settings.json` perso — le repo n'y touche pas, tu actives toi-même. Fusionne ce bloc dans `~/.claude/settings.json` :

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "$HOME/.claude/hooks/guard-git-add.sh" },
          { "type": "command", "command": "$HOME/.claude/hooks/guard-git-push.sh" }
        ]
      },
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "$HOME/.claude/hooks/guard-plan-file.sh" }
        ]
      }
    ]
  }
}
```

> Windows : les hooks `.sh` requièrent un `bash` accessible (Git Bash / WSL).

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
