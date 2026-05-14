# `/flow` — pipeline d'orchestration

Règle globale **agnostique** : s'applique à tout dépôt (TypeScript, Python, Go, Rust…). L'agent **adapte** les commandes au gestionnaire de paquets et au framework détectés.

## Outils (paquets et verrouillage)

Lire la config racine du projet pour identifier l'écosystème :

- **JavaScript / TypeScript** : `package.json` (champ `packageManager` si présent) + fichier de lock (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb`). Utiliser l'invocation cohérente avec le lock (`npm run`, `pnpm`, `yarn`, `bun`).
- **Python** : `pyproject.toml` (poetry / uv / pip), `requirements.txt`, `Pipfile`. Lancer les commandes via l'outil détecté (`poetry run`, `uv run`, `pytest`, `python -m`).
- **Go** : `go.mod` ; commandes `go test`, `go build`, `go vet`.
- **Rust** : `Cargo.toml` ; commandes `cargo test`, `cargo build`, `cargo clippy`.
- **Monorepo multi-paquets** : utiliser les drapeaux du gestionnaire (`pnpm --filter`, `turbo run`, `nx run`) **uniquement** s'ils s'appliquent au dépôt courant.

**Ne jamais inventer** de commande qui ne figure pas dans la config — la lire d'abord, puis utiliser ce qui est exposé par l'équipe.

## Fichier de plan — interdit dans le dépôt

**`plan.json` (ou tout fichier de plan équivalent) ne doit jamais apparaître dans la codebase** : **pas** de création dans l'arbre de sources **versionné**, **pas** de `git add`, **pas** de commit, **pas** de push. Le fichier devrait être listé dans **`.gitignore`** ; toute création locale accidentelle reste **non suivie**.

Le **plan** (directive, périmètre, tâches, statuts, fichiers par tâche) vit **uniquement dans le fil de conversation Agent** (ou mémoire de session), structuré et mis à jour au fil des tâches.

## Portée `.claude/` et Git

Le dossier **`.claude/`** local au projet est en général **exclu du dépôt** (`.gitignore`). Règles, commandes et agents Claude Code locaux restent donc **propres à la machine**. Une tâche **limitée** à `.claude/` ne nécessite **pas** de branche ni de PR : appliquer les changements localement. Le workflow **branche → PR → commits** décrit ci-dessous vise le **code versionné**.

## Règles complémentaires (méthode)

| Fichier | Rôle |
|--------|------|
| `test-driven-development.md` | TDD, red-green-refactor, motif **Prove-It** ; **AAA** (Arrange–Act–Assert) sur tout test. |
| `code-organization.md` | Taille des fichiers, **SRF** (responsabilité unique), découpe ; voir agent **factorizer**. |
| `code-review-and-quality.md` | Revue selon **cinq axes** (comportement, sécurité, maintenabilité, performance, UX). |
| `incremental-implementation.md` | **Tranches petites et vérifiables**, alignées sur la granularité des tâches. |

L'agent s'appuie sur ces règles pendant la **boucle d'exécution** (tests d'abord, découpage, revue avant de conclure).

---

## Comment déclencher

**Dans le chat Agent** : **`/`** → commande **`flow`**, puis **la demande** en texte libre (même message) :

```text
/flow ajouter la pagination sur la liste des utilisateurs
/flow corriger le crash au login quand le réseau est coupé
```

**L'utilisateur ne saisit rien d'autre** (pas de ticket forcé, pas de `Feature:` / `Module:`, pas de zones entre crochets). **L'agent** déduit la nature du travail, **`perimeter.areas`**, la **`directive`**, les types Conventional et le découpage des tâches à partir de la demande et du dépôt.

Si la demande est **insuffisante pour un plan** : **une** question de clarification courte ; pas de taxonomie imposée à l'utilisateur.

**Après le plan** : attendre explicitement **`ok`** ou **`go`** avant toute suite (branche, PR, puis développement).

---

## Pull request

**Identifier la branche d'intégration** du dépôt :

1. Si le dépôt a une branche `dev` ou `develop` → **PR vers cette branche** ; `main` / `master` sont réservées au release.
2. Sinon → **PR vers `main`** (ou `master` / `trunk` selon le dépôt).

**Interdit** : ouvrir une PR vers `main` quand une branche d'intégration intermédiaire (`dev`, `develop`) existe.

**Ordre imposé** : la **pull request est ouverte avant le développement et les tests** (dès que le plan est validé), pas après la dernière tâche. Les commits et pushes suivants **mettent à jour** cette PR.

1. **Après `ok` / `go`** : partir d'une branche d'intégration **à jour** (`git fetch`, checkout, pull), puis créer une **branche** dédiée (ex. `feat/<sujet-court-kebab>`, `fix/<sujet-court-kebab>` — **déduit** du plan dans le fil). Ne pas committer directement sur la branche d'intégration / release sans accord.
2. **Pousser la branche** pour pouvoir ouvrir la PR : **commit vide** `git commit --allow-empty -m "chore: open PR for /flow workflow"` (ou équivalent d'équipe) — **sans** aucun fichier de plan. Puis `git push -u origin <branche>`.
3. **Ouvrir tout de suite la PR** vers la branche d'intégration : titre et description **alignés sur la `directive`** (résumé du plan, périmètre). **`gh pr create --base <integration-branch>`** ; **recommandé** : `--draft` tant que le travail n'est pas prêt à review. Sinon : lien de comparaison GitHub/GitLab avec la bonne base.
4. **Ensuite seulement** : boucle **tâches** (tests, implémentation, commits) — chaque commit reste sur **cette** branche ; **push après chaque commit** (la PR se met à jour automatiquement).
5. **Fin de cycle** : retirer le **draft** de la PR quand toutes les tâches du plan sont **terminées** et les critères de review sont remplis (si applicable) ; compléter la description si besoin (tests manuels, risques).

---

## Déclencheur

Le workflow s'active lorsque l'utilisateur utilise la **commande `/flow`** avec un **texte de demande** (éventuellement sur les lignes suivantes du même envoi).

→ Plan (fil) → **`ok` / `go`** → branche depuis la branche d'intégration → **PR vers cette branche** → développement & tests (tâches).

## Périmètre du dépôt (`perimeter.areas`)

Ne pas confondre avec **`scope`** du plan : le *scope* Conventional Commit = domaine métier / technique (`auth`, `api`, `ui`…), le **périmètre** = zones du dépôt touchées (noté dans le **plan en fil** → `perimeter.areas`), **choisi par l'agent** d'après la demande.

- La **`directive`** résume le *quoi* (fidèle à la demande utilisateur).
- **`perimeter.areas`** : liste d'alias **déduits du dépôt courant** (ex. pour une app web : `["app", "api", "components"]` ; pour un service Go : `["cmd", "internal/api", "pkg"]`). Préciser le sous-domaine dans la `description` des tâches si besoin. Si une tâche touche une autre zone, l'indiquer dans la liste **`files`** de la tâche et mettre à jour **`perimeter.areas`** dans le fil.

**Alias de zones** : déduire de la structure du dépôt (parcourir le top-level). Vérifier `ARCHITECTURE.md` si présent — il documente souvent les zones et leurs responsabilités. Sinon, utiliser des alias de bon sens (`src`, `app`, `lib`, `components`, `features`, `api`, `tests`, `migrations`, `config`, `assets`, `docs`).

En **boucle d'exécution**, cibler les commandes sur les fichiers réellement modifiés dans ces zones (tests, lint) ; les tâches **transversales** peuvent couvrir plusieurs zones explicitement.

## Conventional Commits

Les messages de commit **doivent** respecter [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

- **Langue** : **anglais** pour tout le texte versionné dans Git (titre, corps, footers). Description en **impératif anglais** (*add*, *fix*, *update*, …). La ligne **`commit`** prévue pour chaque tâche du plan suit la même règle (copier-coller direct dans `git commit -m`).
- **Titre** : `<type>[scope][!]: <description>` — une seule ligne ; description courte, impératif, minuscules sauf noms propres.
- **Types** : `feat`, `fix` (cœur de la spec) ; autres usuels : `refactor`, `perf`, `test`, `docs`, `chore`, `build`, `ci`, `style`.
- **Scope** : aligné sur `plan.scope` (domaine métier / technique) ou un sous-domaine stable (`feat(auth): …`) — **indépendant** de `perimeter.areas`.
- **Breaking change** : `type(scope)!: …` **ou** footer `BREAKING CHANGE: …` dans le corps du message si besoin.
- **Interdit** : titre hors format ; plusieurs intentions dans un même commit (déjà exclus par « une tâche = un commit »).

**Mapping indicatif** (`type` de tâche du plan → *type* Conventional) :

| Tâche `type` | Souvent |
|--------------|---------|
| `api`, `component`, `hook`, `model`, `migration`, `style` (fonctionnel) | `feat` |
| Correctif de comportement / bug | `fix` |
| Couverture ou specs uniquement | `test` |
| `docs`, dont `ARCHITECTURE.md` | `docs` |
| Config outillage / dépôt sans logique métier | `chore` ou `build` |

Champ optionnel par tâche dans le fil : **`commitType`** (ex. `"feat"`) pour figer le type avant de rédiger le message de **`commit`**.

## Document d'architecture : `ARCHITECTURE.md`

Fichier à la **racine**. **Créer** au premier plan qui impacte la structure ou un flux majeur, si absent. Squelette : **Contexte** → **Structure** (zones du dépôt, dossiers principaux) → **Flux** (auth, navigation, données) → **Intégrations** (services externes, BDD, CI…) → **Évolution** (changelog daté : *ajouté / modifié / déprécié*, chemins).

Quand la demande / le plan **modifie** la structure ou un flux documenté : **dernière tâche** du plan — inclure `ARCHITECTURE.md` dans **`files`**, `commit` en `docs(scope): …` (ex. `docs(architecture): …`). Option dans le fil : **`architectureImpact`** pour l'entrée *Évolution*.

**Agents Claude Code** : avant tout `git commit`, l'agent **`conventional-commit`** s'appuie sur l'agent **`architecture`** pour vérifier que les fichiers staged ont une **place cohérente** dans le dépôt (`ARCHITECTURE.md` + zones inférées). Verdict **Bloquant** → ne pas committer sans correction ou dérogation explicite.

Mettre à jour **`ARCHITECTURE.md`** si impact structurel (frontières, dossiers, flux) — souvent via une tâche `docs` finale, **décidée par l'agent** selon la demande.

## Étape 1 — Formuler le plan (dans le fil uniquement)

Avant toute implémentation, **présenter le plan structuré dans la conversation** : `directive`, `scope`, `perimeter.areas`, nom de branche envisagé, liste de **tâches** avec pour chacune : `id`, `title`, `type`, `description`, `tests`, liste **`files`** (chemins prévus), ligne de **`commit`** prévue, `status` (`pending` / `done`).

**Découpage** : préférer **plusieurs petites tâches** à une grosse (voir **Granularité**). Aucun export JSON obligatoire ; si un gabarit aide l'utilisateur, le montrer **en bloc de code dans le chat** seulement.

Champ optionnel dans le fil : **`branch`** — nom de branche prévu pour la PR ; fixé dès le plan validé.

## Granularité des tâches et des commits

Objectif : **revue et rollback faciles**, un problème par tâche.

### Règles de découpage

- **Une tâche = un axe** : logique pure + tests **ou** UI/composant + test **ou** migration SQL seule **ou** config seule **ou** doc seule. **Interdit** dans la même tâche : mélanger migration DB + écran + refacto transversal (sauf exception nommée dans `description`).
- **Taille** : viser **≤ 3 fichiers métier** par tâche (hors fichiers de lock de dépendances, snapshots, fichiers générés). Entre **4 et 5** : acceptable si même sujet très étroit ; au-delà → **scinder** en sous-tâches.
- **Couches** : séparer si possible **données / domaine** et **présentation** en tâches distinctes quand les deux évoluent.
- **Dépendances** : une migration ou un changement de schéma qui casse le client → enchaîner **migration (ou contrat)** puis **adaptation code** dans des tâches **numérotées consécutives**, sans tout fusionner.

### Fichiers et staging

- Pour chaque tâche, liste **`files`** **exhaustive** des chemins modifiés ou créés. Tout fichier pertinent hors liste ⇒ **nouvelle tâche** ou **mise à jour du plan dans le fil** avant de commiter.
- **Staging** : `git add` **uniquement** les chemins listés dans **`files`** de la tâche courante, plus le **fichier de lock** utilisé par l'équipe **seulement** si la tâche ajoute ou modifie une dépendance. **Interdit** : `git add -A` ; embarquer d'autres changements non couverts par la tâche.

Résumé : micro-tâches **atomiques** — une tâche = un comportement testable = **un commit** (sauf tâche **exclusivement** `docs` sur **`ARCHITECTURE.md`** sans code testable).

- Afficher le plan et attendre **`ok`** ou **`go`**.

## Étape 1bis — Pull request (avant dev & tests)

**Uniquement après `ok` / `go`**, et **avant** la première itération de la boucle ci-dessous :

1. Branche d'intégration à jour → création de la branche du plan → push initial (voir section **Pull request**).
2. **Ouvrir la PR** vers la branche d'intégration (`gh pr create --base <integration>`, idéalement en **draft**).

## Étape 2 — Boucle d'exécution (une tâche à la fois)

Pour chaque tâche du plan, **dans l'ordre** :

1. Annoncer : `→ Tâche N/X : [title]`
2. **Tests d'abord** — chaque cas en **Arrange – Act – Assert** (commentaires explicites, voir `test-driven-development.md`) — **sauf** tâche **exclusivement** `docs` sur **`ARCHITECTURE.md`** uniquement (pas de tests auto obligatoires).
3. **Tests ciblés** — depuis la **racine** du dépôt, lancer le script `test` (ou équivalent : `pnpm test`, `npm test`, `pytest`, `go test`, `cargo test`…) sur le chemin du fichier ou du dossier. Échec attendu d'abord si les tests existent déjà ; sinon les ajouter puis itérer.
4. Implémenter le minimum pour faire passer les tests.
5. Reprendre la même commande test → tout vert (ou ignorer les étapes 3–5 si tâche docs pure).
6. **Type-check** : commande adaptée (`npx tsc --noEmit`, `mypy`, `go vet`, `cargo check`…) selon l'écosystème ; zéro erreur avant commit.
7. **Recommandé** : `lint` du projet (script `lint` du `package.json`, `ruff`, `clippy`, etc.), sauf tâche uniquement `docs` sur **`ARCHITECTURE.md`** sans autre fichier code.
8. **Mettre à jour le plan dans le fil** : tâche courante `status` **`pending` → `done`**. Puis `git add` **ciblé** (chemins `files` + le **lock** des dépendances uniquement s'il a changé), puis `git commit -m "<commit de la tâche>"` (message **Conventional Commits**).
9. `git push` vers **`origin`** sur la **branche courante** (`HEAD`). Si pas d'upstream : `git push -u origin <nom-de-branche>`.
10. **Terminé** — tâche N commitée et poussée ; passage à N+1.

**Fin de cycle `/flow`** : la PR existe **déjà** ; après la dernière tâche, **finaliser** (retirer le draft si besoin, compléter la description : **`directive`**, `perimeter.areas`, tests manuels, risques).

## Règles absolues

- **Jamais** de `plan.json` (ni équivalent) **dans le dépôt versionné** : pas de création suivie, pas de commit de fichier de plan.
- Jamais d'implémentation sans tests **quand** la tâche exige un comportement testable.
- Jamais de commit si un test échoue ou si le type-checker erre.
- Un commit = une tâche ; message toujours conforme à **Conventional Commits**, rédigé en **anglais**.
- Blocage test : **expliquer** dans le chat avant de poursuivre.
- **Push** : après chaque commit réussi, **toujours** pousser la branche. **Interdit** : `git push --force` et `git push --force-with-lease` sans **demande explicite** de l'utilisateur.
- **Push refusé** (droits, branche protégée, conflit avec `origin`) : **stopper** le déroulé du plan, **expliquer** dans le chat, **ne pas** enchaîner la tâche suivante tant que le dépôt distant n'est pas aligné (sauf consigne contraire de l'utilisateur).
- Staging **ciblé** uniquement ; **jamais** `git add -A` pour ce workflow.
- Suivi du plan **dans le fil** ; **`ARCHITECTURE.md`** à jour lorsque le plan prévoit une tâche **docs** architecture (dernière tâche concernée du plan).
