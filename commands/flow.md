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

0. **Source Linear (optionnel)** : si `$ARGUMENTS` contient une référence Linear (identifiant `ABC-123` ou URL `linear.app/.../issue/...`), déléguer d'abord à l'agent **linear** (Agent tool, `subagent_type="linear"`) pour **lire le ticket** et en tirer la `directive`, les critères d'acceptation et les références. Si aucun outil Linear n'est disponible, continuer en mode normal (la demande texte sert de directive).
1. **Reconnaissance du dépôt** : lis `package.json` (ou équivalent : `pyproject.toml`, `Cargo.toml`, `go.mod`…) + fichier de lock pour identifier le **gestionnaire de paquets**, les **scripts** (`test`, `lint`, `build`, `typecheck`) et le **framework** principal.
2. **Construire le plan** sous forme structurée **dans le fil** (directive, périmètre/zones, scope, liste de tâches avec fichiers et commits prévus) — **jamais** de fichier `plan.json` dans le dépôt.
3. **Afficher le plan**, attendre **`ok`** ou **`go`**.
4. **Branche par défaut** → identifier la branche d'intégration (`dev`, `develop`, `main`, `master`, `trunk`) à partir de `git remote show origin` ou de l'historique. Préférer `dev` / `develop` si elle existe ; sinon `main` / `master`.
5. Branche dédiée → **ouvrir tout de suite une PR vers la branche d'intégration** (avant développement, **jamais** vers `main` si une branche `dev` existe) ; premier push : commit vide ; draft recommandé. **Si une issue Linear est la source** : déléguer à l'agent **linear** pour passer le ticket à *In Progress* et y poster le lien de la PR.
6. Ensuite : commits atomiques, tests & implémentation ; suivi des tâches dans le fil.
7. **Fin de cycle** : si une issue Linear est la source, l'agent **linear** propose de passer le ticket à *In Review* / *Done* (passage en état terminal **uniquement** sur accord explicite).

## Sous-agents disponibles (via Agent tool)

- **linear** — pont ticket Linear ↔ plan : lit le ticket source, met à jour le statut (*In Progress* / *In Review*), poste le lien de la PR en commentaire
- **conventional-commit** — message + add ciblé + commit + push (contrôle le placement via les règles)
- **test-builder** — écrire les tests TDD avant le code
- **test-runner** — exécuter / diagnostiquer la suite après changement
- **verifier** — rapport de fin de tâche / PR
- **factorizer** — découper un fichier trop gros

Si la demande est **trop vague** : poser **une** question courte de clarification, pas un formulaire.
