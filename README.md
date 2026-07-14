# claude-config

Marketplace **privée** de plugins [Claude Code](https://docs.claude.com/en/docs/claude-code) pour l'équipe. Elle expose un plugin, **`dev-methodology`** : la méthodo de dev partagée (règles, agents, pipeline `/flow`).

> Ce repo est la **source de vérité versionnée**. Claude Code le clone lui-même quand un membre installe le plugin — plus rien à copier à la main dans `~/.claude/`.

## ⚠️ Migration — à faire d'abord si tu as déjà lancé `install.sh`

L'ancien `install.sh` **installait** `rules/`, `agents/`, `commands/` et `hooks/` dans `~/.claude/` sans jamais rien supprimer. Ces copies sont toujours là, **figées** à leur version du jour de l'install, et Claude Code charge `~/.claude/rules/` **d'office dans chaque session**.

Si tu installes le plugin sans nettoyer, tout tourne **en double** : les 7 anciennes règles chargées en permanence (~10k tokens) *plus* l'index du plugin *plus* la skill ; les gardes de `~/.claude/hooks/` *plus* ceux du plugin. Le bénéfice du plugin est annulé, la version qui s'applique est l'ancienne, et **rien ne te le signale** — l'install a l'air réussie.

**1. Supprimer les fichiers déployés**

```bash
# macOS / Linux
rm -rf ~/.claude/rules ~/.claude/hooks
rm -f ~/.claude/commands/flow.md
rm -f ~/.claude/agents/{conventional-commit,factorizer,test-builder,test-runner,verifier,linear,mobile-preview,store-deployer}.md
```

```powershell
# Windows (PowerShell)
Remove-Item -Recurse -Force ~/.claude/rules, ~/.claude/hooks
Remove-Item -Force ~/.claude/commands/flow.md
'conventional-commit','factorizer','test-builder','test-runner','verifier','linear','mobile-preview','store-deployer' |
  ForEach-Object { Remove-Item -Force "~/.claude/agents/$_.md" -ErrorAction SilentlyContinue }
```

**2. Décâbler les gardes de ton `settings.json`**

Le plugin les câble désormais lui-même. Retire de `~/.claude/settings.json` le bloc `hooks.PreToolUse` qui pointe vers `~/.claude/hooks/guard-*.sh` — sinon les gardes tournent deux fois, et ceux qui répondent sont les copies périmées. Le reste du fichier (`permissions`, etc.) ne bouge pas : ce repo ne gère pas ton `settings.json`.

Rien n'est perdu : ces fichiers sont l'ancien contenu de ce repo, récupérable dans l'historique git. À faire **sur chaque machine** ayant lancé `install.sh`.

## Installation (chaque membre de l'équipe)

**Prérequis** : avoir accès au repo (repo privé) et être authentifié auprès de GitHub — `gh auth login`, ou une clé SSH chargée dans `ssh-agent`. Claude Code réutilise tes identifiants git existants, il n'y a **aucun token à saisir**.

Dans Claude Code :

```
/plugin marketplace add Azonesbz/claude-config
/plugin install dev-methodology@claude-config
```

En SSH plutôt qu'en HTTPS :

```
/plugin marketplace add git@github.com:Azonesbz/claude-config.git
```

Vérifier :

```
/plugin list
```

## Ce que le plugin apporte

### 📐 Règles — livrées en **skills**

Chargées **à la demande**, quand la règle sert. Un hook `SessionStart` injecte en plus un **index compact** (~500 tokens) des non-négociables, pour qu'aucune règle ne passe à la trappe.

| Skill | Couvre |
|-------|--------|
| `flow-pipeline` | Doctrine `/flow` : plan → PR → exécution ; Conventional Commits, granularité, staging |
| `incremental-implementation` | Découpe en **tranches petites et vérifiables** |
| `test-driven-development` | TDD Red-Green-Refactor, motif Prove-It, **AAA** |
| `code-organization` | Taille fichier (~100 l.), **responsabilité unique** (SRF), fichiers d'entrée fins |
| `clean-code` | Granularité **fonction** : fn courtes, ≤3 params, flux plat, nommage, pureté |
| `scalability-and-boundaries` | **Frontières** & échelle : couplage, dépendances dirigées, N+1, pagination |
| `code-review-and-quality` | Revue finale en **5 axes** (comportement, sécurité, maintenabilité, perf, UX) |

### 🤖 Sous-agents

| Agent | Rôle |
|-------|------|
| `linear` | **Pont ticket Linear ↔ plan** : lit le ticket source, met à jour le statut, poste le lien de la PR |
| `factorizer` | **Découpe** les fichiers trop gros (≤100 l., 1 module = 1 responsabilité) |
| `test-builder` | Écrit les **tests avant** le code (TDD) |
| `test-runner` | **Lance et diagnostique** la suite de tests |
| `verifier` | **Rapport de fin de tâche** : demandé vs livré |
| `conventional-commit` | Messages **Conventional Commits**, commit + push prudent |
| `mobile-preview` | **Dev mobile** : boot simulateur/émulateur (Expo / RN) + **screenshot-preuve** (jamais commitée) |
| `store-deployer` | **Soumet l'app aux stores** (Google Play / App Store) via EAS Submit |

### ⚡ Commandes

| Commande | Rôle |
|----------|------|
| `/flow <demande>` | Orchestrateur : plan, branche, PR, exécution TDD par tranches |

`/flow` accepte aussi une **référence Linear** (`ABC-123` ou URL `linear.app/.../issue/...`) comme source du plan, via l'agent `linear` (nécessite un connecteur MCP Linear ; sinon repli en mode texte). Voir la skill `flow-pipeline`.

### 🛡️ Garde-fous — hooks `PreToolUse`

Ils transforment des **règles** de `flow-pipeline` en **blocages** réels (sortie `permissionDecision: deny`). Livrés et câblés **par le plugin** : plus rien à ajouter dans ton `settings.json`, ils s'activent avec le plugin.

| Garde | Bloque | Règle source |
|-------|--------|--------------|
| `guard-git-add.sh` | `git add -A` / `--all` / `.` | staging ciblé |
| `guard-git-push.sh` | `git push --force` / `--force-with-lease` | pas de force-push sans accord |
| `guard-plan-file.sh` | écrire `plan.json` / `plan.yaml` / `plan.yml` | pas de fichier de plan versionné |

Chaque garde a un test AAA (`*.test.sh`, cas bloqué + cas passant) qui reste dans le repo. Lancer : `bash plugins/dev-methodology/hooks/<nom>.test.sh`.

> **Prérequis, y compris Windows.** Les gardes sont des scripts bash qui parsent le JSON du hook avec `jq`, sinon Python 3 — cherché sous `python3` **puis** `python`, parce que l'installeur Windows ne pose que le second. Aucun des deux n'est fourni avec Claude Code. Sans l'un d'eux, ou sans `bash` accessible sur Windows (Git Bash / WSL), les gardes **laissent passer** plutôt que de casser ton workflow — mais ils **l'écrivent sur stderr au premier appel**, une fois par session. Un garde muet serait pire que pas de garde : l'équipe se croirait protégée.

## Structure du repo

```
.claude-plugin/marketplace.json   ← la marketplace
plugins/dev-methodology/
├── .claude-plugin/plugin.json    ← le manifeste du plugin
├── skills/<nom>/SKILL.md         ← une règle = une skill
├── agents/<nom>.md               ← auto-découverts
├── commands/flow.md              ← auto-découverte
└── hooks/
    ├── hooks.json                ← déclare SessionStart + les 3 gardes PreToolUse
    ├── methodology-index.md      ← l'index injecté (éditer ici)
    ├── _lib.sh                   ← helpers partagés des gardes
    ├── guard-*.sh                ← les gardes
    └── *.test.sh                 ← leurs tests (restent dans le repo)
```

Le hook `SessionStart` est un simple `cat` de l'index : c'est l'un des trois événements où le **stdout brut** est ajouté au contexte, donc aucun script ni runtime n'est nécessaire. `cat` existe aussi bien dans bash que dans PowerShell (alias de `Get-Content`), ce qui couvre macOS, Linux et Windows.

## Workflow de modification

1. **Édite dans ce repo**, sur une branche
2. `claude plugin validate .` si le CLI est installé
3. PR → merge sur `main`
4. Côté équipe, la mise à jour arrive via `/plugin marketplace update claude-config`

`plugin.json` ne déclare **pas** de `version` : c'est volontaire. Sans ce champ, chaque commit compte comme une nouvelle version et les mises à jour partent toutes seules. Si tu l'ajoutes, il faudra le **bumper à chaque release**, sinon l'équipe ne recevra plus rien silencieusement.

Pour tester en local avant de pousser, ajoute le repo comme marketplace par chemin :

```
/plugin marketplace add ./chemin/vers/claude-config
```

Avant de pousser, lancer les tests des gardes :

```bash
for t in plugins/dev-methodology/hooks/*.test.sh; do bash "$t" || echo "ÉCHEC: $t"; done
```

## Modèle à deux niveaux

| Niveau | Emplacement | Pour quoi |
|--------|-------------|-----------|
| **Global** (ce plugin) | Installé par Claude Code | Méthodo **générique**, agnostique au projet |
| **Projet** | `<projet>/.claude/` + `CLAUDE.md` | Stack, scripts, conventions et règles **métier** propres au repo |

La config projet **étend** la globale et **prime** sur elle : priorité au plus spécifique.

## Conventions

- Contenu des règles/agents en **français** ; messages de commit en **anglais** (Conventional Commits).
- **Une règle = une skill** (SRF appliqué aux règles elles-mêmes) : pas de fichier fourre-tout.
- `settings.json` n'est **pas** géré par ce repo (perso par machine). L'activation du plugin reste un choix explicite de chaque membre.
