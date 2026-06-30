---
description: Pipeline orchestrator — /flow + ta demande ; plan, exécution, PR
argument-hint: <demande en langage naturel>
---

Tu appliques le workflow **pipeline d'orchestration** générique. Adapte les règles ci-dessous au dépôt courant (techno, gestionnaire de paquets, conventions internes).

## Demande utilisateur

$ARGUMENTS

## Règles à appliquer (à charger via Read avant le plan)

Lis et applique les règles globales suivantes, installées dans le dossier `~/.claude/rules/` (sous Windows : `%USERPROFILE%\.claude\rules\`) — chemins portables, valables dans tout projet :

- `~/.claude/rules/flow.md`
- `~/.claude/rules/test-driven-development.md`
- `~/.claude/rules/code-organization.md`
- `~/.claude/rules/code-review-and-quality.md`
- `~/.claude/rules/incremental-implementation.md`

Si le dépôt courant possède un dossier `.claude/rules/` local (ex. règles métier projet), **charger aussi** ces fichiers — ils **complètent** ou **précisent** les règles globales (priorité au plus spécifique).

## Tes obligations

0. **Source Linear (optionnel)** : si `$ARGUMENTS` contient une référence Linear (identifiant `ABC-123` ou URL `linear.app/.../issue/...`), déléguer d'abord à l'agent **linear** (Agent tool, `subagent_type="linear"`) pour **lire le ticket** et en tirer la `directive`, les critères d'acceptation et les références. Si aucun outil Linear n'est disponible, continuer en mode normal (la demande texte sert de directive).
1. **Reconnaissance du dépôt** : lis `package.json` (ou équivalent : `pyproject.toml`, `Cargo.toml`, `go.mod`…) + fichier de lock pour identifier le **gestionnaire de paquets**, les **scripts** (`test`, `lint`, `build`, `typecheck`) et le **framework** principal.
2. **Construire le plan** sous forme structurée **dans le fil** (directive, périmètre/zones, scope, liste de tâches avec fichiers et commits prévus) — **jamais** de fichier `plan.json` dans le dépôt.
3. **Afficher le plan**, attendre **`ok`** ou **`go`**.
4. **Branche par défaut** → identifier la branche d'intégration (`dev`, `develop`, `main`, `master`, `trunk`) à partir de `git remote show origin` ou de l'historique. Préférer `dev` / `develop` si elle existe ; sinon `main` / `master`.
5. Branche dédiée → **ouvrir tout de suite une PR vers la branche d'intégration** (avant développement, **jamais** vers `main` si une branche `dev` existe) ; premier push : commit vide ; draft recommandé. **Si une issue Linear est la source** : déléguer à l'agent **linear** pour passer le ticket à *In Progress* et y poster le lien de la PR.
6. Ensuite : commits atomiques, tests & implémentation ; suivi des tâches dans le fil.
7. **Fin de 