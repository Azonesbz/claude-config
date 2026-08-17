# Étape 04 — Build : sections et assets

**Sortie attendue** : toutes les sections du blueprint construites, inventaire d'assets livré.

**Arrêt dur** — cette étape contient l'un des trois points où l'utilisateur doit répondre : les **preuves et assets du client**.

## Deux voies en parallèle

Lancer `ui-snapper` et `asset-curator` en parallèle dès que le blueprint et les tokens existent : le sourcing d'assets n'attend pas la fin du build.

## Le copy vient avant le composant

**Charger la skill `conversion-anatomy`** et écrire le copy réel de chaque section **avant** de déléguer sa construction. Un agent de build sans copy réel produit du remplissage, et le remplissage finit en production.

Pour chaque section : hero lisible en **5 secondes** (quoi, pour qui, quelle action), titres orientés bénéfice, CTA au **libellé constant**, preuve **adossée à l'objection** qu'elle lève.

## Déléguer la construction

Déléguer à `ui-snapper` (Agent tool, `subagent_type="ui-snapper"`), **section par section, dans l'ordre du blueprint**, en passant à chaque appel :

- le **job** de la section (blueprint) ;
- son **copy réel** ;
- les **tokens** (étape 02) ;
- la **stack** et les dépendances déjà présentes (étape 03).

Il source chez 21st.dev, Magic UI, shadcn/ui, Aceternity, HyperUI ou CodePen, **vérifie la licence**, remappe sur les tokens, élague et contrôle mobile, clavier, contraste.

## Déléguer les assets

Déléguer à `asset-curator` (Agent tool, `subagent_type="asset-curator"`) l'inventaire des besoins visuels : visuel de hero, captures produit, portraits, logos, icônes, illustrations, vidéo de fond, polices.

## L'arrêt dur : les preuves du client

Demander à l'utilisateur, en **un seul tour** :

- les **logos clients** qu'il est **autorisé** à afficher ;
- les **témoignages** avec nom, fonction, et accord ;
- les **chiffres** sourçables (résultats, volumes, ancienneté) ;
- les **captures produit** ou accès pour les réaliser.

Ce qu'il ne fournit pas devient un **emplacement marqué** dans la page, listé à la livraison. **Jamais** un faux logo, un témoignage fictif ou un chiffre inventé : c'est trompeur, et cela l'expose.

## Porte

Toutes les sections du blueprint sont `done`, l'inventaire d'assets (usage, source, **licence**, poids) est livré, aucun contenu de démo ne subsiste. Un garde bloque le lorem ipsum à l'écriture, mais il ne voit pas « Client 1 » : c'est à toi de vérifier.

Étape suivante : `etapes/etape-05-revue.md`.
