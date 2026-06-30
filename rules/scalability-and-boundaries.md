# Scalabilité & frontières — pensé pour grandir

Cette règle **complète** `code-organization.md` (placement) et `clean-code.md` (fonction) au niveau **module / dépendances / données** : chaque fichier doit pouvoir **grandir sans casser** ses voisins. On vise les **frontières** entre modules et le **coût à l'échelle** (équipe, données, trafic).

## 1. Couplage faible, cohésion forte

- Un module **change pour une seule raison** ; ce qui change ensemble vit ensemble, le reste est séparé.
- Minimiser les **points de contact** : exposer une **API publique étroite**, garder l'interne privé.
- Communiquer par **contrats explicites** (types, interfaces) plutôt que par accès direct aux détails d'un autre module.

## 2. Direction des dépendances

- Les dépendances pointent **vers le stable** : le **domaine métier ne dépend pas** de l'infra (DB, réseau, framework, UI) — c'est l'**inverse** (inversion de dépendances).
- **Zéro import circulaire** : un cycle = deux modules qui n'en font qu'un → fusionner ou scinder par une abstraction.
- Le **framework est un détail** : isoler son API derrière une frontière (adapter) pour pouvoir le remplacer ou le tester.

## 3. Frontières par domaine

- Organiser **par feature / domaine métier** (`features/billing/`) plutôt que par couche technique (`controllers/`, `services/`) dès que le projet grandit — la colocation bat la dispersion.
- **API publique via un `index`** (barrel) ; le reste du dossier est **interne**, non importable de l'extérieur.
- Une frontière est un **point d'extension** : on se branche dessus, on ne la contourne pas.

## 4. Abstraction au bon moment

- **Règle de 3** : n'abstrais qu'à la **3ᵉ** répétition réelle ; deux occurrences se tolèrent.
- **DRY porte sur la connaissance**, pas sur la ressemblance : deux bouts identiques **par hasard** (qui évolueront séparément) **ne** doivent **pas** être fusionnés.
- Éviter l'**abstraction spéculative** (« on en aura besoin un jour ») : c'est du couplage et de la dette en avance.

## 5. Scalabilité des données et du temps

- **Pagination / limite par défaut** sur toute liste : jamais de `SELECT *` non borné ni de `findAll()` sur une table qui grossit.
- **Anti N+1** : charger en **lot** (jointure, `IN`, dataloader) au lieu d'une requête par élément dans une boucle.
- **Complexité algorithmique consciente** : repérer les `O(n²)` cachés (boucle imbriquée, `.find()` dans un `.map()`) → indexer par `Map` / `Set`.
- **Gros volumes** : streaming / traitement par lot plutôt que tout charger en mémoire ; **index** sur les colonnes d'accès fréquent.

## 6. Extension sans modification

- **Ouvert/fermé** : ajouter un cas **par extension** (nouvelle implémentation, nouveau handler) plutôt que par un `switch` qui gonfle à chaque variante.
- Préférer la **composition / configuration** à la modification invasive d'un cœur partagé.

## Anti-patterns

- Module « **dieu** » importé partout, ou import **circulaire** entre deux modules.
- **Domaine couplé au framework** (entités qui héritent de l'ORM, logique métier dans un contrôleur HTTP).
- Organisation **par couche technique** sur un gros projet → un changement métier touche 5 dossiers.
- **Abstraction prématurée** / DRY accidentel qui force deux besoins divergents dans le même code.
- `findAll()` sans pagination ; **N+1** ; `.find()` dans une boucle sur une grande collection.
- `switch` géant modifié à chaque nouveau cas.

## Signaux d'alarme

- Un changement « simple » oblige à toucher **beaucoup de fichiers** dispersés.
- Tu ne peux pas tester un module sans démarrer la **DB / le réseau / le framework**.
- Le temps de réponse **croît avec le nombre de lignes** en base (N+1, absence d'index).
- Tu ajoutes un `if` de plus dans un `switch` central pour chaque nouvelle variante.
- Deux modules s'**importent mutuellement**.

## Lien avec les autres règles

- Niveau **fonction/ligne** → `clean-code.md` ; niveau **fichier/placement** → `code-organization.md` ; découpe → agent **factorizer**.
- Axe **Performance & ressources** de la revue → `code-review-and-quality.md`.
- Livraison **par tranches** vérifiables → `incremental-implementation.md`.
