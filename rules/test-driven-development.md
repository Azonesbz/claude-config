# Développement piloté par les tests (TDD)

## Cycle Red → Green → Refactor

1. **Red** : ajouter un test qui exprime le comportement voulu ; il **doit échouer** pour la bonne raison (pas d'erreur de syntaxe ou de mock incomplet).
2. **Green** : écrire le **minimum** de code pour faire passer le test.
3. **Refactor** : simplifier le code et les tests **sans** changer le comportement ; relancer les tests à chaque pas.

## Motif Prove-It (« prouver d'abord »)

Avant d'implémenter une fonctionnalité ou un correctif :

- Formuler une **preuve observable** : *« qu'est-ce qui doit être vrai quand c'est correct ? »*
- L'encoder dans un test (unitaire, intégration légère, ou test de composant selon le dépôt).
- **Ne pas** coder la solution tant que la preuve n'échoue pas de façon **explicite** (échec = spécification clarifiée).

Objectif : éviter l'implémentation spéculative et verrouiller le contrat avant le détail.

## Pattern AAA (obligatoire pour tout test)

Chaque cas de test (`it` / `test` / `def test_…` / `func Test…`) doit appliquer **Arrange – Act – Assert** de façon explicite dans le texte source :

- **Arrange** : état initial, fixtures, mocks, paramètres d'entrée. Un seul bloc logique (éviter de mélanger l'exécution ici).
- **Act** : l'**unique** opération qu'on veut prouver (un appel de fonction, un `render`, un événement utilisateur) — en général **une** ligne ou un court enchaînement ciblé.
- **Assert** : toutes les `expect` / `assert` (et `waitFor` côté assert si besoin) **après** l'acte, sans intercaler de nouvel acte significatif.

**Dans le fichier** : repérer les trois blocs par des commentaires `// Arrange`, `// Act`, `// Assert` (ou `# Arrange` etc. selon le langage). Les **commentaires** suffisent — pas d'obligation de `describe` supplémentaires par phase. En cas de setup partagé (`beforeEach`, fixtures pytest), le **Arrange** du cas peut s'appuyer dessus ; le cas doit quand même rendre l'enchaînement **Act / Assert** lisible.

Contre ce pattern (à éviter) : plusieurs actions « métier » dans le même test sans séparation claire ; assertions mélangées avec la préparation ; `expect` avant l'appel testé (sauf préconditions sur des doubles).

## Règles pratiques (à adapter au dépôt)

- **Emplacement des tests** : convention du dépôt courant (`**/__tests__/**`, `tests/`, `*_test.go`, `tests/`…). Lire la config du framework de test pour confirmer le pattern.
- **Framework de test** : déduit du `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` (Jest, Vitest, pytest, Go test, Cargo test, etc.).
- **Exécution ciblée** : depuis la racine du dépôt, lancer le script `test` du gestionnaire de paquets avec le chemin du test (ex. `pnpm test -- <chemin>`, `pytest <chemin>`, `go test ./<pkg>`, `cargo test <name>`).
- Pour une tâche **testable** du pipeline `/flow` : **tests d'abord**, puis implémentation (voir `pipeline-orchestration.md`, Étape 2).

## Anti-patterns

- Cas de test **sans** les trois parties **Arrange / Act / Assert** rendues visibles (commentaires) — sauf tâches purement docs/outillage sans tests requis.
- Implémenter puis « ajouter des tests après » sans laisser le test rouge guider le design.
- Tests trop larges (tout l'écran d'un coup) : préférer des cas **petits et nommés**.
- Mocks qui masquent le comportement réel au point que le test ne prouve plus rien.
