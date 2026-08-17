# Étape 05 — Revue scorée

**Sortie attendue** : score ≥ barre des gagnants, zéro bloquant — ou décision de livrer sous la barre, assumée et chiffrée.

C'est ici que la pipeline se distingue d'un exercice de style : la page est jugée avec la **même grille** que celle qui a classé les concurrents.

## Déléguer

Déléguer à `lp-reviewer` (Agent tool, `subagent_type="lp-reviewer"`) en lui passant **la matrice de l'étape 01** — mêmes critères, mêmes poids, même barème. C'est ce qui rend le verdict non arbitraire.

Sans matrice (étape 01 dégradée), le dire : le score existera toujours, mais **sans repère marché**, donc bien moins fiable.

## Ce qu'il contrôle

Conversion (hero 5 s, objectif unique, CTA constant, job par section, objections avant le CTA final, friction) · preuve (adossée à une objection, sourcée, **jamais fabriquée**) · cohérence visuelle (tokens partout, une seule échelle, frontière entre bibliothèques invisible) · technique (mobile 360 px, poids, **LCP**, **CLS**, JS différé, polices self-hostées) · accessibilité (contraste, focus, clavier, `alt`, `prefers-reduced-motion`) · conformité (licences, logos autorisés) · intégrité (zéro contenu de démo, zéro lien mort, formulaire branché ou signalé).

## Boucle de correction — bornée à deux tours

1. Prendre les corrections **classées par gain** du rapport.
2. Les faire exécuter par l'agent compétent : `ui-snapper` pour l'UI, `asset-curator` pour les médias, toi pour le copy.
3. **Re-scorer** — un score revendiqué sans nouvelle mesure ne vaut rien.

**Deux tours maximum.** Toujours sous la barre après deux tours : **arrêter**. Livrer avec le score réel, l'écart et ce qui le cause. Boucler indéfiniment coûte plus cher que de dire la vérité.

## Bloquants — ils interdisent la livraison

Preuve fabriquée · licence manquante · contenu de démo · page cassée en mobile · contraste sous le seuil. Ceux-là ne se négocient pas contre un score : ils se corrigent, quel que soit le nombre de tours déjà consommés.

## Mesurer, pas supposer

Servir la page et la **regarder** avec les outils navigateur, en desktop **et** en mobile (360 px). Mesurer le poids des fichiers plutôt que l'estimer. Toute assertion non vérifiée est marquée **« non vérifié »**, jamais présentée comme un constat.

## Porte

Score ≥ barre et zéro bloquant — ou décision explicite de livrer sous la barre, avec le chiffre et sa cause écrits dans la feuille de chantier.

Étape suivante : `etapes/etape-06-livraison.md`.
