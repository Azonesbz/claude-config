---
name: market-blueprint
description: Analyse concurrentielle d'une niche (10 sites gagnants vs 10 qui rament) puis extraction du blueprint de conversion — ordre des sections, plan CTA, matrice de scoring, placement de la preuve sociale. À charger avant toute décision de structure ou de copy sur une landing page, et pour arbitrer « pourquoi cette section ici ».
---

# Blueprint de conversion — la donnée avant le design

**Un beau site qui ne vend pas ne sert à rien.** Une landing page n'est pas une œuvre : c'est une **hypothèse de conversion** qu'on dérive de ce qui marche déjà dans la niche. Cette skill produit le **blueprint** : le document qui dicte l'ordre des sections, les CTA, la preuve sociale et la barre de qualité. Le design (`visual-references`), les composants (`ui-snapping`) et le copy (`conversion-anatomy`) **exécutent** ce blueprint.

## 1. Constituer l'échantillon 10 vs 10

Deux groupes dans la **même niche** et sur le **même type d'offre** (SaaS B2B ≠ e-commerce DTC ≠ infoproduit ≠ agence de services) :

- **10 gagnants** — leaders assumés, acteurs financés, pages qui tournent en publicité payante depuis des mois (un budget qui dure est une preuve de rentabilité), pages citées comme références de conversion.
- **10 qui rament** — même niche, trafic ou traction faible, pages jamais actualisées, annuaires et pages 2ᵉ/3ᵉ page de résultats.

**Sourcer via les tools disponibles** — WebSearch, WebFetch, et les MCP de veille (SimilarWeb pour le trafic quand il est connecté) ; les bibliothèques publicitaires (Meta Ad Library, TikTok Creative Center) révèlent quelles pages sont **payées durablement**. **Rien d'inventé** : chaque site du panel a une URL réelle et consultable. Si moins de 10 sites solides par groupe sont trouvables, **le dire** et travailler avec l'échantillon réel (6v6 honnête > 10v10 fabriqué).

**Le groupe qui rame n'est pas décoratif** : il donne les **contre-signaux**. Un pattern présent chez les gagnants ET chez les perdants n'explique rien — seul le **différentiel** compte.

## 2. Extraire — la même grille pour les 20

Pour chaque page, relever factuellement :

| Dimension | Ce qu'on relève |
|-----------|-----------------|
| **Séquence** | Liste ordonnée des sections, de haut en bas |
| **Hero** | Promesse (verbatim), sous-titre, visuel, CTA above the fold |
| **CTA** | Nombre total, libellés exacts, position, primaire vs secondaire |
| **Preuve sociale** | Type (logos, chiffres, témoignages, notes, études de cas), **position dans la page** |
| **Objections** | FAQ, garantie, sécurité, tarif visible ou non |
| **Friction** | Champs de formulaire, étapes avant conversion, obligation de compte |
| **Rythme** | Nombre de sections, longueur, densité de texte |
| **Technique** | Poids, mobile, vitesse ressentie |

Relever le **verbatim** (titres, libellés de CTA) : la formulation exacte est le matériau du copy.

## 3. Comparer — chercher le différentiel

Le blueprint sort de l'écart entre les deux groupes, pas de la liste des gagnants :

- **Pattern gagnant** : fréquent chez les gagnants, rare chez les perdants → **à reprendre**.
- **Anti-pattern** : fréquent chez les perdants, rare chez les gagnants → **à éviter explicitement**.
- **Neutre** : présent des deux côtés → **ignorer** (aucun pouvoir explicatif — souvent la simple convention du secteur).

Écarts classiques : preuve sociale dans le premier écran vs reléguée en bas ; un CTA répété à l'identique vs cinq CTA concurrents ; promesse chiffrée et spécifique vs slogan abstrait ; tarif assumé vs « nous contacter » ; démonstration du produit en image vs stock photo de gens qui rient.

## 4. Produire le blueprint

Le livrable, **dans le fil** (jamais un fichier versionné) :

1. **Ordre des sections** — la séquence retenue, chaque section avec **son job en une phrase** et la **fréquence observée** chez les gagnants. Une section sans job ne rentre pas.
2. **Plan CTA** — action unique, libellé (dérivé des verbatims gagnants), points de répétition, hiérarchie primaire/secondaire.
3. **Carte de preuve sociale** — quel type de preuve, à quel endroit, adossé à quelle objection. Les gagnants placent la preuve **au moment du doute**, pas en vrac dans un carrousel.
4. **Matrice de scoring** — les critères discriminants observés, pondérés par leur pouvoir de séparation gagnants/perdants, avec le **score moyen des gagnants** comme barre à franchir.
5. **Angles de copy** — les promesses qui reviennent chez les gagnants, reformulées pour l'offre du client. **Jamais** de copie littérale d'un concurrent.

## 5. La matrice de scoring

Elle sert **deux fois** : pour classer le panel, puis pour scorer la page produite (agent `lp-reviewer`). Même grille, même barème — c'est ce qui rend le verdict final non arbitraire.

Construire **6 à 10 critères**, tirés de l'analyse (pas d'une liste générique), chacun noté **0-5** avec un poids proportionnel à son pouvoir discriminant. Une page qui score sous la moyenne des gagnants **n'est pas prête** : corriger d'abord les critères où l'écart est le plus grand.

## Anti-patterns

- **Design d'abord, marché ensuite** : choisir un template puis y couler le contenu.
- **Panel de gagnants seul** : sans contre-groupe, on prend des conventions de secteur pour des facteurs de conversion.
- **Panel hors niche** : copier la structure de Stripe pour un artisan local.
- **Analyse inventée** : citer des « tendances » sans URL vérifiable.
- **Blueprint ignoré** au moment du build : sections ajoutées « parce que ça fait joli ».
- **Copie littérale** d'un concurrent : juridiquement risqué, stratégiquement stérile.

## Signaux d'alarme

- Tu écris une section sans savoir à quelle **objection** elle répond.
- Tu ne peux pas nommer le **différentiel** qui justifie l'ordre choisi.
- La matrice de scoring pourrait s'appliquer telle quelle à n'importe quelle niche.
- Le CTA change de libellé d'une section à l'autre.
- Tu conclus « les gagnants ont un hero » — un pattern à 100 % des deux côtés ne dit rien.

## Lien avec les autres skills

- Traduction du blueprint en **copy et hiérarchie** → `conversion-anatomy`.
- **Direction artistique** cohérente avec le positionnement → `visual-references`.
- **Composants** pour chaque section du blueprint → `ui-snapping`.
- Exécution de l'analyse → agent **market-analyst** ; scoring final → agent **lp-reviewer**.
