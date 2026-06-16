# Code propre — granularité au niveau fonction

Cette règle **complète** `code-organization.md` (niveau fichier/module) en descendant au niveau **fonction et ligne** : chaque fonction doit être lisible en quelques secondes et porter **une seule intention**. La découpe d'un fichier trop gros relève de l'agent **factorizer** ; ici on vise la **forme interne** du code.

## 1. Fonctions courtes et focalisées

- **~20-30 lignes de corps maximum** (hors signature et accolades). Au-delà : extraire des sous-fonctions nommées.
- **Une fonction = une intention** et **un seul niveau d'abstraction** : ne pas mêler orchestration de haut niveau et détails bas niveau dans le même corps.
- Si tu écris un commentaire pour **titrer un bloc** (`// validation`, `// formatage`), c'est le signal d'**extraire** ce bloc dans une fonction au nom explicite.

## 2. Signature minimale

- **≤ 3 paramètres**. Au-delà, regrouper dans un **objet d'options nommé** (`createUser({ name, email, role })`).
- **Pas de paramètre booléen** qui pilote deux comportements (`render(true)`) → **deux fonctions** distinctes (`renderCompact()` / `renderFull()`).
- Pas d'argument **muté en sortie** : préférer **retourner** une valeur plutôt que modifier un paramètre.
- Ordre des paramètres stable et prévisible (obligatoires d'abord, options ensuite).

## 3. Flux de contrôle plat

- **Guard clauses / early return** : traiter cas limites et erreurs **en premier**, puis le chemin nominal sans imbrication.
- **Profondeur d'indentation ≤ 3**. Au-delà : extraire une fonction ou inverser une condition.
- Pas de `else` après un `return` ; éviter les **ternaires imbriqués** et les conditions à rallonge → extraire un **prédicat nommé** (`isEligible(user)`).

## 4. Nommage révélateur d'intention

- Noms **explicites et prononçables** ; pas d'abréviations obscures (`usr`, `tmp`, `d`, `data2`).
- **Verbes** pour les fonctions (`computeTotal`, `fetchInvoice`) ; **`is/has/should/can`** pour les booléens (`isExpired`, `hasAccess`).
- **Zéro magic number / magic string** dans la logique → **constante nommée** en tête de module (`const MAX_RETRIES = 3`).
- Vocabulaire **métier cohérent** : un seul mot par concept (pas `client` / `customer` / `user` pour la même entité).

## 5. Pureté et effets de bord

- Préférer les **fonctions pures** : mêmes entrées → même sortie, aucun effet observable. Testables et réutilisables sans contexte.
- **Isoler les effets de bord** (I/O, réseau, horloge, aléatoire, état global) aux **frontières** ; garder le cœur logique pur.
- **Immutabilité par défaut** : ne pas muter les arguments ni l'état partagé ; produire de nouvelles valeurs.
- Pas d'effet de bord **caché** dans ce qui ressemble à une lecture (un *getter* qui écrit, un `map` qui mute).

## 6. Commentaires et bruit

- Le **code** exprime le *comment* ; les **commentaires** expliquent le *pourquoi* (décision, contrainte, contournement).
- Pas de commentaire qui **paraphrase** le code ; pas de code mort ni de `console.log` laissés « au cas où ».

## Anti-patterns

- Fonction « fourre-tout » de 50+ lignes mêlant calcul, I/O et formatage.
- 4+ paramètres positionnels, ou un **flag booléen** de comportement.
- Imbrication profonde (`if` dans `for` dans `if`) au lieu de guard clauses.
- **Magic numbers/strings** disséminés ; noms génériques (`data`, `tmp`, `handle`, `doStuff`).
- Mutation d'un argument ou d'un état global ; effet de bord dans un accesseur.
- Commentaire-titre de bloc au lieu d'une fonction extraite.

## Signaux d'alarme

- Tu **scrolles** pour lire une seule fonction.
- Tu écris un commentaire pour expliquer **ce que** fait un bloc → extraire une fonction nommée.
- Un **booléen** apparaît dans une liste de paramètres.
- Tu hésites sur le nom parce que la fonction fait **deux choses**.
- Le même nombre « magique » apparaît à deux endroits.

## Lien avec les autres règles

- Niveau **fichier/module** (taille, SRF, placement) → `code-organization.md` ; découpe d'un gros fichier → agent **factorizer**.
- **Frontières, couplage et scalabilité** → `scalability-and-boundaries.md`.
- Chaque test en **Arrange – Act – Assert** → `test-driven-development.md`.
- Revue finale (5 axes) → `code-review-and-quality.md`.
