---
name: asset-sourcing
description: Sourcer, licencier et optimiser les assets d'une landing page — images, vidéos, icônes, polices, illustrations, mockups. Où trouver du libre de droits, quelles licences vérifient quoi, quels formats et quel budget de poids, comment protéger le LCP. À charger dès qu'une image, une vidéo ou une police entre dans la page.
---

# Assets — licenciés, pertinents, légers

Les assets décident de la **crédibilité** (est-ce un vrai produit ?), de la **vitesse** (ils forment l'essentiel du poids) et du **risque juridique** (une image mal licenciée se facture des milliers d'euros). Trois exigences, dans cet ordre : **le droit de l'utiliser**, **la pertinence**, **le poids**.

## 1. Hiérarchie de pertinence

| Rang | Type | Pourquoi |
|------|------|----------|
| 1 | **Assets réels du client** — produit, équipe, locaux, captures | Rien ne convertit mieux que le vrai |
| 2 | **Captures produit mises en scène** (mockups appareils) | Montre le résultat, reste honnête |
| 3 | **Illustrations / 3D cohérentes avec la DA** | Neutre, identitaire, sans risque de banalité |
| 4 | **Photo de stock choisie avec soin** | Acceptable en appui |
| 5 | **Stock générique** (gens en réunion qui sourient) | Signal de page vide de contenu — à éviter |

**Toujours demander les assets du client avant d'aller chercher du stock.** S'ils manquent : le signaler explicitement et marquer les emplacements dans le livrable.

## 2. Où sourcer (libre de droits)

| Source | Contenu | Licence |
|--------|---------|---------|
| **Unsplash**, **Pexels**, **Pixabay** | Photos | Usage commercial libre — vérifier les cas particuliers |
| **Coverr**, **Mixkit**, **Pexels Video** | Vidéos de fond | Libre, souvent sans attribution |
| **unDraw**, **Storyset**, **Open Doodles** | Illustrations | Libre, recolorable sur la palette |
| **Lucide**, **Heroicons**, **Phosphor**, **Tabler** | Icônes | MIT / ISC |
| **Simple Icons** | Logos de marques | Marques déposées — usage nominatif seulement |
| **Google Fonts**, **Fontshare** | Polices | Libre, self-hostable |
| **Shots.so**, **Screely**, **Mockuuups** | Mockups d'appareils | Vérifier les conditions |

**Interdits sans licence** : image trouvée via une recherche web, asset d'un concurrent, logo de client non autorisé, photo de personne sans droit à l'image, capture d'un service tiers utilisée pour suggérer un partenariat inexistant.

**Logos clients** : n'afficher que ceux dont le client confirme l'autorisation. Un faux logo de référence est une pratique trompeuse.

## 3. Formats et poids

- **Photos** → **AVIF** en priorité, **WebP** en repli, JPEG en dernier recours.
- **Logos, icônes, formes** → **SVG**, nettoyé (SVGO) ; icônes en composants inline plutôt qu'une police d'icônes complète.
- **Vidéo** → **MP4 (H.264)** + **WebM** si possible ; jamais de GIF au-delà de quelques kilo-octets (un MP4 muet en boucle pèse dix fois moins).
- **Dimensions réelles** : ne jamais servir du 4000 px pour un rendu à 800 px. Fournir un `srcset` par palier.
- **Budget indicatif** : **image hero < 200 ko**, **page complète < 1,5 Mo** hors vidéo. Au-delà, justifier.

## 4. Protéger le LCP

L'image du hero est presque toujours l'élément **LCP** — l'indicateur qui décide de la vitesse perçue.

- **Précharger** l'image du hero ; **ne jamais** la mettre en `loading="lazy"`.
- **`loading="lazy"` et `decoding="async"`** pour tout ce qui est sous la ligne de flottaison.
- **`width` et `height` explicites** (ou `aspect-ratio`) sur chaque média : sans eux, la page saute au chargement (CLS).
- **Vidéo de fond** : `poster` obligatoire, `muted` + `playsinline`, **pas d'autoplay sur mobile** (coût data, souvent bloqué) — servir l'image `poster` à la place.
- **Polices** : **self-hostées**, `font-display: swap`, sous-ensembles de caractères, **2 familles maximum**, préchargement de la police du hero.

## 5. Accessibilité et conformité

- **`alt` descriptif** sur toute image porteuse de sens ; `alt=""` sur le purement décoratif. L'`alt` décrit **la fonction**, pas le fichier.
- **Sous-titres** pour toute vidéo parlée ; contrôles clavier accessibles.
- **Pas de texte incrusté** dans une image : illisible pour les lecteurs d'écran, non traduisible, flou en zoom.
- **Respecter `prefers-reduced-motion`** : vidéos et animations de fond coupées.
- **Traçabilité** : garder la liste source + licence de chaque asset, livrée avec la page. C'est ce qui permet un audit six mois plus tard.

## Anti-patterns

- Image récupérée via une recherche web « parce qu'elle est bien ».
- Stock générique de gens en costume qui applaudissent.
- **PNG de 3 Mo** en fond de hero.
- GIF animé lourd là où un MP4 ferait dix fois moins.
- Hero en `lazy` → LCP effondré.
- Police chargée depuis un CDN tiers, quatre graisses inutilisées.
- Logos clients affichés **sans autorisation**.
- `alt` vide ou `alt="image1.png"` partout.

## Signaux d'alarme

- Tu ne peux pas nommer la **licence** d'un asset intégré.
- Une image dépasse 500 ko sans raison.
- La page saute pendant le chargement (dimensions manquantes).
- Le hero contient du texte incrusté dans une image.
- Une vidéo démarre seule sur mobile avec du son.
- Aucun asset ne vient réellement du client.

## Lien avec les autres skills

- Style et traitement de l'imagerie → `visual-references`.
- Rôle de preuve des visuels → `conversion-anatomy`.
- Coût des dépendances d'affichage → `ui-snapping`.
- Sourcing et optimisation → agent **asset-curator** ; contrôle du poids et du LCP → agent **lp-reviewer**.
