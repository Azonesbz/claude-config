---
description: Landing page orchestrator — /lp + ton brief ; marché, blueprint, design, build, revue
argument-hint: <offre, cible et objectif de conversion en langage naturel>
---

Tu appliques le pipeline **lp-builder**. Principe fondateur : **un beau site qui ne vend pas ne sert à rien** — la donnée marché précède le design, le design précède le code.

## Demande utilisateur

$ARGUMENTS

## Doctrine

La méthodo est livrée en **skills** par le plugin `lp-builder` — charger chacune **au moment où elle sert** :

| Phase | Skill |
|-------|-------|
| Analyse marché → blueprint | `market-blueprint` |
| Copy et structure qui vendent | `conversion-anatomy` |
| Direction artistique | `visual-references` |
| Composants pro | `ui-snapping` |
| Images, vidéos, icônes, typos | `asset-sourcing` |

Si le plugin `dev-methodology` est actif, ses règles s'appliquent au **code** produit ; pour la mécanique git (branche dédiée, PR, Conventional Commits), suivre sa skill `flow-pipeline`. Sinon, rester simple : commits atomiques en anglais.

## Tes obligations

1. **Brief métier** — extraire de la demande : l'**offre**, la **cible**, l'**objectif de conversion** (achat, lead, démo, inscription — **un seul**), le **différenciateur**, les **preuves disponibles** (chiffres, logos, témoignages, notes). S'il manque l'un des trois premiers : poser **une** série courte de questions (jamais un formulaire), puis enchaîner sans autre validation.
2. **Analyse concurrentielle** — déléguer à l'agent **market-analyst** (Agent tool) : 10 sites gagnants vs 10 qui rament dans la niche, extraction, scoring, synthèse. Sa sortie est le **blueprint** : ordre des sections, plan CTA, carte de preuve sociale, angles de copy, barre de score à atteindre.
3. **Direction artistique** — charger `visual-references` : 3-5 références réelles, palette, typo, ton. **Afficher blueprint + moodboard dans le fil**, puis **démarrer directement** — jamais de confirmation `ok`/`go`. Doute non bloquant → option la plus raisonnable, signalée en une ligne.
4. **Reconnaissance de la stack** — dépôt existant : respecter la stack en place (`package.json`, framework, Tailwind…). From scratch sans consigne : défaut **léger** (page statique + Tailwind ; un framework seulement s'il apporte quelque chose de réel).
5. **UI snapping** — déléguer à l'agent **ui-snapper**, section par section dans l'**ordre du blueprint** : composant pro (21st.dev, Magic UI, shadcn/ui, CodePen) choisi, licence vérifiée, adapté à la DA, contenu réel injecté. Jamais de section standard codée from scratch.
6. **Assets** — déléguer à l'agent **asset-curator** : sourcing licencié, optimisation (formats modernes, budget de poids, LCP protégé). Peut tourner **en parallèle** du snapping.
7. **Copy** — charger `conversion-anatomy` : hero 5 secondes, doctrine CTA, preuve sociale placée, objections traitées. Le copy suit le blueprint, pas l'humeur — chaque section a un job.
8. **Revue finale** (automatique, **sans** confirmation) — déléguer à l'agent **lp-reviewer** : la page est scorée avec la **même matrice** que les concurrents + checks techniques (mobile, poids, LCP, a11y). Score sous la barre des gagnants → corriger d'abord les critères discriminants, re-scorer, puis livrer.

## Sous-agents disponibles (via Agent tool)

- **market-analyst** — analyse 10v10 → blueprint de conversion
- **ui-snapper** — source et adapte les composants pro, section par section
- **asset-curator** — fournit les assets sourcés, licenciés, optimisés
- **lp-reviewer** — score final (matrice + technique) avant livraison

Si la demande est **trop vague** : poser **une** question courte de clarification, pas un formulaire.
