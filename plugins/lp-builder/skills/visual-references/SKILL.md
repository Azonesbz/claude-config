---
name: visual-references
description: Direction artistique d'une landing page à partir de références visuelles réelles — où chercher (Mobbin, Land-book, Godly, Awwwards, Dribbble, Refero), comment lire une référence, et comment en tirer un moodboard actionnable (palette, typo, densité, motion, ton). À charger avant d'écrire la moindre ligne de style.
---

# Références visuelles — décider avant de styler

Une landing page sans **direction artistique explicite** dérive : chaque section adopte le style du composant collé le plus récemment. Cette skill fixe la DA **avant** le build, à partir de références **réelles et consultables** — jamais d'une idée vague de « moderne et épuré ».

## 1. Où chercher

| Source | Ce qu'on y trouve |
|--------|-------------------|
| **Mobbin** | Parcours réels d'apps et de sites, écran par écran — la meilleure source de patterns **éprouvés en production** |
| **Land-book**, **Lapa Ninja**, **Onepagelove** | Landing pages entières, classées par secteur |
| **Godly**, **Awwwards**, **SiteInspire** | Haut de gamme et audace formelle — inspiration, rarement à copier tel quel |
| **Refero**, **Page Flows** | Patterns d'interface et de conversion en contexte |
| **Dribbble**, **Behance** | Concepts graphiques — beaux, souvent **non implémentables** : à utiliser pour l'ambiance, pas pour la structure |
| **Concurrents du panel** | Le repère qui compte : ce que la cible voit déjà |

Rechercher via les tools disponibles (WebSearch, WebFetch, browser). **Chaque référence retenue a une URL vérifiable.** Ne jamais décrire une référence qu'on n'a pas réellement consultée.

## 2. Choisir 3 à 5 références

- **Retenir 3-5**, pas 15 : au-delà, la DA devient un patchwork.
- **Rester dans le registre du positionnement** : premium ≠ mass market ≠ technique ≠ ludique. Une DA de luxe sur une offre à bas prix crée une dissonance qui coûte des conversions.
- **Vérifier la faisabilité** : une référence primée qui repose sur du WebGL et six mois de motion design n'est pas une référence — c'est un piège de planning.
- **Ne jamais copier une page entière** : on emprunte des **partis pris** (rythme, contraste, traitement typographique), jamais une identité. Marque, logo et illustrations propriétaires sont hors-limite.

## 3. Lire une référence — les six axes

Pour chaque référence, extraire ce qui est **transposable** :

1. **Palette** — dominante, accent, neutres, mode sombre/clair. Combien de couleurs portent réellement l'identité (souvent deux).
2. **Typographie** — familles, contraste titre/corps, échelle, graisse, hauteur de ligne.
3. **Densité et espacement** — aéré vs compact, rythme vertical, largeur de contenu.
4. **Formes** — rayons, ombres, bordures, profondeur, cartes vs pleine largeur.
5. **Imagerie** — produit, illustration, 3D, photo, abstrait. Traitement (masques, dégradés, mockups).
6. **Motion** — ce qui bouge, quand, avec quelle retenue. Le motion **guide** l'attention ; il ne décore pas.

## 4. Produire le moodboard

Livrable **dans le fil**, avant tout code :

- **3-5 références** avec URL et, pour chacune, **ce qu'on lui emprunte précisément** (« à celle-ci : le rythme vertical généreux et le contraste titre/corps » — pas « l'ambiance »).
- **Tokens de design** : palette (rôles sémantiques, pas noms de couleurs), échelle typographique, échelle d'espacement, rayons, ombres. Ces tokens deviennent la **source de vérité** du build.
- **Ton éditorial** en trois adjectifs (« direct, technique, rassurant ») — il cadre le copy autant que le style.
- **Contraintes** : mode sombre ou non, contraste minimal, budget motion.

Les tokens ne sont pas décoratifs : ils sont ce qui empêche chaque composant collé d'imposer **son** style. Tout composant sourcé par `ui-snapping` est remappé sur eux.

## 5. Accessibilité — non négociable

- **Contraste texte/fond ≥ 4.5:1** (≥ 3:1 pour le grand texte). Le gris clair sur blanc est le défaut le plus courant des DA « épurées » — et il exclut des acheteurs.
- **Focus visible** sur tous les interactifs ; jamais d'`outline: none` sans remplacement.
- **La couleur ne porte jamais seule l'information** (erreur, succès, état).
- **Respecter `prefers-reduced-motion`** : animation coupée ou fortement réduite.
- **Taille de police de corps ≥ 16 px** sur mobile.

## Anti-patterns

- « Moderne et épuré » comme direction artistique — ça ne décide rien.
- Référence **jamais consultée**, décrite de mémoire.
- Copie d'une page concurrente à l'identique.
- DA en **dissonance** avec le prix et le positionnement.
- Six polices, cinq accents : l'identité se dissout.
- Motion **partout** : chaque section qui s'anime = plus rien ne guide l'œil.
- Contraste sacrifié à l'esthétique.

## Signaux d'alarme

- Tu ne peux pas nommer **ce que tu empruntes** à une référence.
- Deux sections n'ont visiblement pas la même origine stylistique.
- La palette compte plus de deux couleurs identitaires.
- Une couleur est écrite en dur dans une section au lieu d'un token.
- La référence choisie exige une techno absente du projet.

## Lien avec les autres skills

- Composants remappés sur les tokens → `ui-snapping`.
- Imagerie conforme à la DA → `asset-sourcing`.
- Ton éditorial et hiérarchie → `conversion-anatomy`.
- Cohérence DA / positionnement → `market-blueprint`.
