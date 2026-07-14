# Méthodo d'équipe — règles actives

Plugin `dev-methodology`. Ces règles s'appliquent à **tout travail de code** dans cette session. Ce bloc est un **index** : le détail de chaque règle vit dans une **skill** à charger au moment où elle sert.

## Non-négociables

- **Tests d'abord.** Pas d'implémentation d'un comportement testable sans un test qui échoue d'abord (motif Prove-It). Tout cas de test en **Arrange – Act – Assert**, avec les commentaires `// Arrange` / `// Act` / `// Assert` visibles dans le source. → skill `test-driven-development`
- **~100 lignes max par fichier**, une fonctionnalité = un module, fichiers d'entrée (routes, écrans, controllers, handlers) **fins**. → skill `code-organization`
- **Fonctions courtes** (~20-30 lignes), une seule intention, ≤3 paramètres, pas de flag booléen, guard clauses, zéro magic number. → skill `clean-code`
- **Le domaine ne dépend pas de l'infra**, zéro import circulaire, pagination par défaut sur toute liste, pas de N+1. → skill `scalability-and-boundaries`
- **Tranches petites et vérifiables** : une intention par tranche, ≤3 fichiers métier par tâche. → skill `incremental-implementation`
- **Revue en 5 axes** avant de déclarer une tâche terminée : comportement, sécurité, maintenabilité, performance, UX. → skill `code-review-and-quality`
- **Conventional Commits en anglais**, un commit = une tâche, staging ciblé (jamais `git add -A`), jamais de `plan.json` versionné. → skill `flow-pipeline`

## Réflexes

- Une règle propre au dépôt (`.claude/rules/`, `CLAUDE.md`) **prime** sur ces règles globales : priorité au plus spécifique.
- **Charger la skill** avant de trancher un point de méthode — ce résumé ne suffit pas pour le détail.
- Agents disponibles : `factorizer` (découpe d'un fichier trop gros), `test-builder` (tests avant code), `test-runner` (exécution et diagnostic), `verifier` (rapport de fin de tâche), `conventional-commit` (commit et push).
- Pipeline complet plan → PR → exécution : commande `/flow <demande>`.
