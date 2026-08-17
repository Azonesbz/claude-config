---
name: ui-snapping
description: Assembler une landing page à partir de composants professionnels existants (21st.dev, Magic UI, shadcn/ui, Aceternity, Tailwind UI, CodePen, Mobbin) plutôt que de coder chaque section from scratch — sourcing, vérification de licence, adaptation aux tokens, intégration et budget de performance. À charger dès qu'il faut produire une section d'interface.
---

# UI snapping — assembler, pas réinventer

Une section standard (hero, tarifs, témoignages, FAQ) a déjà été conçue, testée et raffinée mille fois par des professionnels. **La recoder from scratch produit systématiquement un résultat inférieur**, plus lent à obtenir. Le snapping consiste à **sourcer un composant pro, vérifier sa licence, le remapper sur la DA du projet et y injecter le contenu réel**.

Ce n'est pas du copier-coller : le composant sourcé est un **point de départ**, jamais le livrable.

## 1. Bibliothèques par usage

| Source | Nature | Bon pour |
|--------|--------|----------|
| **21st.dev** | Composants React + Tailwind communautaires | Sections marketing complètes, variantes de hero |
| **Magic UI** | Composants animés React/Tailwind (MIT) | Effets à fort impact : marquee, beams, texte animé |
| **shadcn/ui** | Primitives accessibles, copiées dans le repo (MIT) | Socle : boutons, formulaires, dialogues, accordéons |
| **Aceternity UI** | Sections animées spectaculaires | Hero premium, effets de profondeur |
| **Tailwind UI / Tailwind Plus** | Sections marketing officielles — **licence payante** | Structures éprouvées **si la licence est détenue** |
| **CodePen** | Démos isolées | Une micro-interaction précise, une idée d'effet |
| **Mobbin** | Captures de parcours réels | **Référence visuelle**, pas du code |
| **HyperUI**, **Flowbite**, **daisyUI** | Blocs Tailwind libres | Alternatives sans dépendance React |

**Mobbin ne fournit pas de code** : c'est une source de patterns (cf. `visual-references`). Ne jamais prétendre en « importer un composant ».

## 2. Vérifier la licence — avant d'intégrer

- **MIT / Apache / domaine public** : intégration libre, conserver les mentions requises.
- **Licence payante** (Tailwind UI, thèmes commerciaux) : n'utiliser que si le **client détient la licence**. Sinon, s'en inspirer et **reconstruire** avec des blocs libres.
- **CodePen** : sans licence explicite, un pen est « tous droits réservés » par défaut. S'en servir pour **comprendre la technique**, puis réécrire.
- **Polices et icônes** : vérifier séparément (cf. `asset-sourcing`).

En cas de doute sur une licence : **le dire** et prendre l'alternative libre. Un doute non levé est un risque juridique transmis au client.

## 3. Boucle de snapping — section par section

Pour **chaque** section du blueprint, dans l'ordre :

1. **Job de la section** (issu de `conversion-anatomy`) — il détermine le type de composant, pas l'inverse.
2. **Sourcer 2-3 candidats** dans les bibliothèques ci-dessus.
3. **Trancher** sur : cohérence avec la DA, compatibilité de stack, coût en dépendances, poids et impact perf, accessibilité de base.
4. **Remapper sur les tokens** du projet (palette, typo, espacement, rayons) — **jamais** de couleur ou de taille en dur héritée de la démo.
5. **Injecter le contenu réel** — copy et preuves du client. **Zéro lorem ipsum, zéro « Client 1 / Client 2 »** dans un livrable.
6. **Élaguer** : retirer variantes, props et états inutilisés du composant importé.
7. **Vérifier** : mobile, clavier, focus, `prefers-reduced-motion`, contraste.

## 4. Cohérence d'ensemble

Le risque n° 1 du snapping est le **patchwork** : dix sections excellentes, dix styles différents.

- **Tokens partagés** obligatoires — le remapping (étape 4) n'est pas optionnel.
- **Une seule échelle** d'espacement et de rayons sur toute la page.
- **Un seul vocabulaire de motion** : mêmes durées et courbes partout.
- **Un seul style de bouton primaire** dans toute la page.

Avant de livrer : faire défiler la page **entière** et vérifier qu'on ne devine pas la frontière entre deux bibliothèques.

## 5. Budget de performance

Un composant animé importé traîne souvent une dépendance lourde.

- **Compter le coût** de chaque ajout (bibliothèque d'animation, icônes, polices). Réutiliser une dépendance déjà présente plutôt qu'en ajouter une seconde du même type.
- **Le hero ne dépend d'aucun JS lourd** : le premier écran doit rendre vite (LCP).
- **Animations en `transform`/`opacity`** ; éviter celles qui déclenchent des reflows.
- **Charger en différé** ce qui vit sous la ligne de flottaison.
- Un effet spectaculaire qui coûte 300 ko et une seconde de LCP **détruit plus de conversions qu'il n'en crée**.

## 6. Quand coder from scratch

Le snapping n'est pas un dogme. Écrire soi-même quand :

- La section est **spécifique au métier** et n'a pas d'équivalent (configurateur, simulateur, calculateur de ROI).
- Aucun candidat n'est licencié correctement.
- L'adaptation d'un composant importé coûterait **plus** que l'écrire.

Dans ce cas, respecter les règles de code du projet (plugin `dev-methodology` s'il est actif).

## Anti-patterns

- Recoder un hero standard from scratch « pour faire propre ».
- Coller un composant **sans remapper** ses couleurs et sa typo.
- Livrer avec le **contenu de démo** de la bibliothèque.
- Importer trois bibliothèques d'animation dans la même page.
- Utiliser un composant sous licence payante non détenue.
- Empiler les effets : chaque section anime, plus rien ne ressort.
- Garder tout le composant importé alors que 20 % servent.

## Signaux d'alarme

- Une couleur hexadécimale en dur apparaît dans une section.
- Deux sections ont des rayons ou des ombres visiblement différents.
- Le mot « Lorem » existe encore dans le livrable.
- `package.json` a gagné une dépendance dont tu ne peux pas nommer l'usage.
- Le hero ne s'affiche qu'après le chargement d'un gros bundle JS.
- Tu ne sais pas dire sous quelle licence est le composant que tu viens d'intégrer.

## Lien avec les autres skills

- Tokens et DA de référence → `visual-references`.
- Job et contenu de chaque section → `conversion-anatomy` et `market-blueprint`.
- Images, vidéos, icônes, polices → `asset-sourcing`.
- Exécution section par section → agent **ui-snapper** ; contrôle final → agent **lp-reviewer**.
