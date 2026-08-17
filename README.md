# claude-config

Marketplace de plugins [Claude Code](https://docs.claude.com/en/docs/claude-code). Elle expose deux plugins :

| Plugin | Pour quoi |
|--------|-----------|
| **`dev-methodology`** | Méthodologie de développement opinionée : règles chargées à la demande, agents dédiés, pipeline `/flow` et trois garde-fous qui **refusent** réellement certaines commandes |
| **`lp-builder`** | Création de **landing pages qui vendent** : analyse concurrentielle 10 gagnants vs 10 qui rament, blueprint de conversion, UI snapping et score final contre la barre du marché |

Ils s'installent séparément et fonctionnent indépendamment. Elle est publique et réutilisable telle quelle : `/plugin marketplace add Azonesbz/claude-config` suffit, sans compte ni token.

> Ce repo est la **source de vérité versionnée**. Claude Code le clone lui-même à l'installation — rien à copier à la main dans `~/.claude/`.

**Tu as déjà lancé l'ancien `install.sh` ?** Fais d'abord le [nettoyage de migration](MIGRATION.md) : sans lui, tout tourne en double et c'est l'ancienne version, figée, qui s'applique — sans que rien ne te le signale.

---

📄 **[92 % de cette méthodo ne s'exécute pas](docs/le-garde-manquant.md)** — le décompte honnête de ce qui, dans ces 1 633 lignes, refuse vraiment quelque chose : 3 règles sur 46. Avec un exercice à faire sur ton propre dépôt.

## Installation

**Prérequis** : être authentifié auprès de GitHub — `gh auth login`, ou une clé SSH chargée dans `ssh-agent`. Claude Code réutilise tes identifiants git existants, il n'y a **aucun token à saisir**.

Dans Claude Code :

```
/plugin marketplace add Azonesbz/claude-config
/plugin install dev-methodology@claude-config
/plugin install lp-builder@claude-config
```

En SSH plutôt qu'en HTTPS :

```
/plugin marketplace add git@github.com:Azonesbz/claude-config.git
```

Vérifier :

```
/plugin list
```

## `dev-methodology` — ce que le plugin apporte

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

> **Ce que les gardes ne couvrent pas.** Ils reconnaissent une forme de commande, pas une intention. `guard-git-add.sh` refuse bien `git add -A`, mais `git commit -am`, `git add -u` et `git stage -A` **passent** — le motif ne peut structurellement pas voir un `commit -a`. De même, `guard-plan-file.sh` ne surveille que les outils `Write` et `Edit` : un `cat > plan.json` en bash n'est pas couvert, et la comparaison de nom est sensible à la casse. Ces gardes réduisent les gestes réflexes, ils ne ferment pas le sujet.

> **Prérequis, y compris Windows.** Les gardes sont des scripts bash qui parsent le JSON du hook avec `jq`, sinon `python3`. Aucun des deux n'est fourni avec Claude Code. Sans l'un d'eux, ou sans `bash` accessible sur Windows (Git Bash / WSL), les gardes **laissent passer** plutôt que de casser ton workflow — mais ils **l'écrivent sur stderr au premier appel**, une fois par session. Un garde muet serait pire que pas de garde : on se croirait protégé.

## `lp-builder` — ce que le plugin apporte

Postulat : **un beau site qui ne vend pas ne sert à rien.** La donnée marché précède le design, le design précède le code. La structure d'une page n'est pas un goût, elle se **dérive** de ce qui marche déjà dans la niche.

### 📊 Skills

| Skill | Couvre |
|-------|--------|
| `market-blueprint` | Analyse **10 gagnants vs 10 qui rament** → ordre des sections, plan CTA, **matrice de scoring**, placement de la preuve |
| `conversion-anatomy` | Job de chaque section, **règle des 5 secondes**, CTA unique, objections, friction, hiérarchie |
| `visual-references` | DA décidée avant le style : Mobbin, Land-book, Godly, Awwwards → **tokens** actionnables |
| `ui-snapping` | Assembler depuis **21st.dev, Magic UI, shadcn/ui, Aceternity, CodePen** : licences, remapping, budget perf |
| `asset-sourcing` | Images, vidéos, icônes, polices : licences, formats modernes, budget de poids, **LCP protégé** |

### 🤖 Sous-agents

| Agent | Rôle |
|-------|------|
| `lp-orchestrator` | **Conduit toute la pipeline** : six phases, portes de passage, feuille de chantier, boucle de correction |
| `market-analyst` | Constitue le panel **10v10**, extrait, compare, produit le **blueprint** |
| `ui-snapper` | Construit les sections depuis des **composants pro**, licence vérifiée, remappés sur les tokens |
| `asset-curator` | Assets **sourcés, licenciés, optimisés** + inventaire source/licence/poids |
| `lp-reviewer` | **Score final** avec la matrice du marché + checks mobile, poids, LCP, a11y |

Chaque phase a une **porte** : pas de build sans blueprint, pas de composant sans tokens, pas de livraison sans score. Une porte non franchie se **dit** — elle ne se contourne pas en silence. La boucle de correction est bornée à **deux tours** : toujours sous la barre après ça, l'orchestrateur livre avec le score réel et ce qui l'explique, plutôt que de boucler.

### ⚡ Commande

| Commande | Rôle |
|----------|------|
| `/lp <brief>` | Point d'entrée **fin** : délègue à `lp-orchestrator`, qui conduit marché → blueprint → DA → build → revue scorée |

### 🛡️ Garde-fou

| Garde | Bloque | Règle source |
|-------|--------|--------------|
| `guard-placeholder-copy.sh` | Écrire du **lorem ipsum** dans un fichier de page | zéro contenu de démo livré |

> **Portée du garde.** Il ne s'applique qu'aux fichiers qui **rendent quelque chose au visiteur** : `.html`, `.jsx`, `.tsx`, `.vue`, `.svelte`, `.astro` — et il s'écarte des fichiers de test, `.stories.*`, `__tests__/`, `__mocks__/`, `fixtures/`, `mocks/`. Ailleurs, le lorem ipsum est de la donnée d'exemple parfaitement légitime, et le plugin s'installe globalement : un garde non scopé refuserait d'écrire une fixture Python ou cette page même de documentation.

> **Ce que ce garde ne couvre pas.** Il reconnaît une chaîne, pas une intention. Le contenu de démo d'un composant (« Client 1 », « Jane Doe », avatars de la bibliothèque) **passe** — un motif ne peut pas distinguer un faux témoignage d'un vrai. Du lorem ipsum dans un `.ts` ou un `.md` de contenu passe aussi, par choix de portée. Il attrape la forme la plus courante de remplissage, il ne garantit pas que la page contient du contenu réel : c'est le job de l'agent `lp-reviewer`.

Le **code** produit suit `dev-methodology` si le plugin est actif ; sinon `lp-builder` reste autonome.

## Structure du repo

```
.claude-plugin/marketplace.json   ← la marketplace (déclare les 2 plugins)
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
plugins/lp-builder/
├── .claude-plugin/plugin.json
├── skills/<nom>/SKILL.md         ← market-blueprint, conversion-anatomy, visual-references,
│                                    ui-snapping, asset-sourcing
├── agents/<nom>.md               ← market-analyst, ui-snapper, asset-curator, lp-reviewer
├── commands/lp.md
└── hooks/
    ├── hooks.json                ← SessionStart + le garde placeholder
    ├── lp-index.md               ← l'index injecté (éditer ici)
    ├── _lib.sh
    ├── guard-placeholder-copy.sh
    └── guard-placeholder-copy.test.sh
```

Le hook `SessionStart` est un simple `cat` de l'index : c'est l'un des trois événements où le **stdout brut** est ajouté au contexte, donc aucun script ni runtime n'est nécessaire. `cat` existe aussi bien dans bash que dans PowerShell (alias de `Get-Content`), ce qui couvre macOS, Linux et Windows.

## Workflow de modification

1. **Édite dans ce repo**, sur une branche
2. `claude plugin validate .` si le CLI est installé
3. PR → merge sur `main`
4. Côté utilisateur, la mise à jour arrive via `/plugin marketplace update claude-config`

`plugin.json` ne déclare **pas** de `version` : c'est volontaire. Sans ce champ, chaque commit compte comme une nouvelle version et les mises à jour partent toutes seules. Si tu l'ajoutes, il faudra le **bumper à chaque release**, sinon plus personne ne recevra rien, silencieusement.

Pour tester en local avant de pousser, ajoute le repo comme marketplace par chemin :

```
/plugin marketplace add ./chemin/vers/claude-config
```

Avant de pousser, lancer les tests des gardes (les deux plugins) :

```bash
for t in plugins/*/hooks/*.test.sh; do bash "$t" || echo "ÉCHEC: $t"; done
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
- `settings.json` n'est **pas** géré par ce repo (perso par machine). L'activation du plugin reste un choix explicite.

## Licence

[MIT](LICENSE). Fork, adapte, garde ce qui te sert : ces règles sont des choix, pas des vérités — la moitié d'entre elles se discute, et c'est très bien.
