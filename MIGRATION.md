# Migration depuis `install.sh`

**Concerne uniquement** les machines où l'ancien `install.sh` de ce repo a été
lancé. Si tu découvres ce repo aujourd'hui, cette page ne te concerne pas :
va directement à l'[installation](README.md#installation).

## Pourquoi

L'ancien `install.sh` **installait** `rules/`, `agents/`, `commands/` et
`hooks/` dans `~/.claude/` sans jamais rien supprimer. Ces copies sont toujours
là, **figées** à leur version du jour de l'install, et Claude Code charge
`~/.claude/rules/` **d'office dans chaque session**.

Si tu installes le plugin sans nettoyer, tout tourne **en double** : les 7
anciennes règles chargées en permanence (~10k tokens) *plus* l'index du plugin
*plus* la skill ; les gardes de `~/.claude/hooks/` *plus* ceux du plugin. Le
bénéfice du plugin est annulé, la version qui s'applique est l'ancienne, et
**rien ne te le signale** — l'install a l'air réussie.

## 1. Supprimer les fichiers déployés

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

## 2. Décâbler les gardes de ton `settings.json`

Le plugin les câble désormais lui-même. Retire de `~/.claude/settings.json` le
bloc `hooks.PreToolUse` qui pointe vers `~/.claude/hooks/guard-*.sh` — sinon
les gardes tournent deux fois, et ceux qui répondent sont les copies périmées.
Le reste du fichier (`permissions`, etc.) ne bouge pas : ce repo ne gère pas ton
`settings.json`.

Rien n'est perdu : ces fichiers sont l'ancien contenu de ce repo, récupérable
dans l'historique git. À faire **sur chaque machine** ayant lancé `install.sh`.
