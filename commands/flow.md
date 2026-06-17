---
description: Pipeline orchestrator — /flow + ta demande ; plan, exécution, PR
argument-hint: <demande en langage naturel>
---

Tu appliques le workflow **pipeline d'orchestration** générique. Adapte les règles ci-dessous au dépôt courant (techno, gestionnaire de paquets, conventions internes).

## Demande utilisateur

$ARGUMENTS

## Règles à appliquer

Les **règles globales** de méthodo sont **déjà chargées** dans chaque session (config globale `~/.claude/rules/`) : `flow`, `test-driven-development`, `code-organization`, `clean-code`, `scalability-and-boundaries`, `code-review-and-quality`, `incremental-implementation`. Les appliquer directement.

Si le dépôt courant possède un dossier `.claude/rules/` local (ex. règles métier projet), **charger aussi** ces fichiers via Read — ils **complètent** ou **précisent** les règles globales (priorité au plus spécifique).

## Tes obligations

1. **Reconnaissance du dépôt** : lis `package.json` (ou équivalent : `pyproject.toml`, `Cargo.toml`, `go.mod`…) + fichier de lock pour identifier le **gestionnaire de paquets**, les **scripts** (`test`, `lint`, `build`, `typecheck`) et le **framework** principal.
2. **Construire le plan** sous forme structurée **dans le fil** (directive, périmètre/zones, scope, liste de tâches avec fichiers et commits prévus) — **jamais** de fichier `plan.json` dans le dépôt.
3. **Afficher le plan**, attendre **`ok`** ou **`go`**.
4. **Branche par défaut** → identifier la branche d'intégration (`dev`, `develop`, `main`, `master`, `trunk`) à partir de `git remote show origin` ou de l'historique. Préférer `dev` / `develop` si elle existe ; sinon `main` / `master`.
5. Branche dédiée → **ouvrir tout de suite une PR vers la branche d'intégration** (avant développement, **jamais** vers `main` si une branche `dev` existe) ; premier push : commit vide ; draft recommandé.
6. Ensuite : commits atomiques, tests & implémentation ; suivi des tâches dans le fil.

## Sous-agents disponibles (via Agent tool)

- **conventional-commit** — message + add ciblé + commit + push (contrôle le placement via les règles)
- **test-builder** — écrire les tests TDD avant le code
- **test-runner** — exécuter / diagnostiquer la suite après changement
- **verifier** — rapport de fin de tâche / PR
- **factorizer** — découper un fichier trop gros

Si la demande est **trop vague** : poser **une** question courte de clarification, pas un formulaire.
