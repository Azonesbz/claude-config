# Organisation du code (taille, factorisation, responsabilité)

## Taille et factorisation

Lors de l'édition ou de l'ajout de code, respecter :

1. **~100 lignes max par fichier** (sauf exception documentée en en-tête : config, schéma, généré). Adapter le seuil aux conventions du dépôt si celles-ci sont explicites (`.editorconfig`, lint rules, `ARCHITECTURE.md`).
2. **Une fonctionnalité = un module** (un composant, un hook, un service, un package). Ne pas mélanger plusieurs blocs logiques distincts dans le même fichier.

Si un fichier dépasse 100 lignes ou regroupe plusieurs fonctionnalités : extraire en sous-modules, hooks ou utils (voir l'agent **factorizer** pour la méthode).

## Fichier à responsabilité unique (SRF)

Objectif : **un fichier = un axe de changement principal** (une surface API cohérente), pas un agrégat de fonctionnalités ou de domaines mélangés.

### Règles

1. **Un module/composant « principal » par fichier** : en général **un seul export nommé** (ou un default export) qui est l'entité principale. Les sous-morceaux du même fichier doivent rester **privés** et **courts** (quelques dizaines de lignes, pas de logique métier lourde).
2. **Plusieurs exports** : acceptable seulement s'ils sont **triviaux et indissociables** (ex. variantes d'une même primitive). Sinon : **fichiers séparés** ou dossier dédié avec un fichier d'index.
3. **Types, constantes, hooks/helpers** : si le fichier grossit, extraire `*.types.ts`, `constants.ts`, `use-*.ts`, `*_helpers.py` **colocalisés** dans le même dossier plutôt que tout empiler dans un seul fichier.

## Fichiers d'entrée (routes, écrans, controllers, handlers)

Les fichiers situés aux **points d'entrée** du framework (routes web, écrans mobiles, controllers HTTP, handlers de message, commandes CLI) doivent rester **fins** : composition, layout, câblage des dépendances, transformation entrée/sortie. Ils **ne doivent pas** contenir :

- **Fonctions utilitaires pures** (formatters, helpers de calcul, prédicats) → extraire vers un module utilitaire colocalisé (`<feature>/<sujet>-helpers.ts`, `services/<feature>.py`).
- **Composants présentationnels réutilisables** ou **sous-blocs** → extraire vers le dossier `components/` adapté.
- **Logique métier réutilisable** (parsers, mappers, fusion de listes, règles métier) → extraire vers une couche dédiée (`features/<domaine>/`, `domain/`, `usecases/`, `services/`).

Le fichier d'entrée reste un **point de câblage** : il importe les hooks/services/composants ; il **ne définit pas** de fonction `formatX`, ni de composant `XIcon`, ni de prédicat `showY` à l'intérieur.

## État local (composants UI, machines à état)

Réduire le nombre d'états locaux indépendants autant que possible — chaque état séparé est un point de re-render (côté UI) ou de complexité (côté machine à état).

Ordre de préférence :

1. **Constante locale** : si la valeur ne dépend que des props/context et ne change pas à l'usage, c'est une `const` (pas d'état).
2. **Valeur dérivée** : si la valeur est calculable depuis d'autres états (ex. `unreadCount` à partir de `messages`), la dériver (`useMemo`, propriété calculée). **Ne pas** la stocker dans un état synchronisé via effet — c'est une duplication de source de vérité.
3. **Objet d'état consolidé** : si plusieurs champs **changent ensemble** (ex. métadonnées chargées en bloc : `id`, `participants`, `linkedEvent`), **un seul** état avec un objet plutôt que 4-5 états séparés. Le set est atomique et économise des renders.
4. **Réducteur / machine à état** : si la transition d'état devient un automate (chargement → succès → erreur → retry), préférer un reducer / state machine à plusieurs états couplés.

Anti-pattern fréquent : 6+ `useState` (ou équivalents) qui sont tous remplis dans la même fonction `loadX()` — à consolider en un seul état.

## Anti-patterns

- Fichiers **plusieurs gros modules exportés** ou **> ~500 lignes** mélangeant logique, présentation, helpers et variantes — les nouvelles contributions **ne doivent pas** aggraver le fichier ; préférer **extraire** dans des modules voisins.
- **Définir un module utilitaire ou un sous-composant dans un fichier d'entrée** (route, écran, handler) — voir section dédiée ci-dessus.
- **Doublonner un état dérivé** dans un état synchronisé par effet — utiliser une valeur calculée directement.

## Lors d'une modification

- Si tu ajoutes un nouveau module réutilisable : **nouveau fichier** (ou sous-dossier) plutôt qu'un second export massif dans le même module.
- Si tu étends une primitive existante : **extraire** d'abord la partie stable (types, hook, layout) si le diff devient difficile à relire.
- Si tu touches un fichier d'entrée qui contient des fonctions utilitaires ou des sous-composants : **extraire d'abord** (commit séparé), puis appliquer le changement.
