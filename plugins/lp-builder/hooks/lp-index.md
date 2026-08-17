# Landing pages — doctrine active

Plugin `lp-builder`. Ces règles s'appliquent à **tout travail de landing page** dans cette session. Ce bloc est un **index** : le détail vit dans une **skill** à charger au moment où elle sert.

## Non-négociables

- **La donnée avant le design.** Pas de structure choisie sans analyse concurrentielle 10 gagnants vs 10 qui rament ; le blueprint (ordre des sections, plan CTA, matrice de scoring) commande le build. → skill `market-blueprint`
- **Une section = un job.** Hero lisible en 5 s, **un seul** objectif de conversion, CTA au libellé constant, preuve sociale placée au moment du doute. → skill `conversion-anatomy`
- **DA décidée avant le style** : 3-5 références réelles avec URL, tokens (palette, typo, espacement) comme source de vérité. → skill `visual-references`
- **Assembler, pas réinventer** : sections standard sourcées chez les pros (21st.dev, Magic UI, shadcn/ui, CodePen), licence vérifiée, remappées sur les tokens. → skill `ui-snapping`
- **Assets licenciés, pertinents, légers** : réels du client d'abord, formats modernes, hero < 200 ko jamais en `lazy`. → skill `asset-sourcing`
- **Zéro preuve fabriquée** : ni faux logo, ni témoignage fictif, ni chiffre non sourcé. Emplacement vide **signalé**, jamais bouché.
- **Scorer avant de livrer** : même matrice que les concurrents, sous la barre des gagnants = pas prêt.

## Réflexes

- Une règle propre au dépôt (`.claude/rules/`, `CLAUDE.md`) **prime** sur ces règles globales : priorité au plus spécifique.
- **Charger la skill** avant de trancher — ce résumé ne suffit pas pour le détail.
- **La séquence** : compétence `lp-pipeline` — sept étapes numérotées dans `etapes/etape-NN-*.md`, lues **juste avant** d'être appliquées, jamais préchargées. Trois **arrêts durs** où seul l'utilisateur répond : cadrage (00), preuves et assets du client (04), mise en ligne (06).
- **La conduite** : agent `lp-orchestrator` — exécute `lp-pipeline`, tient la feuille de chantier, délègue à `market-analyst` (blueprint 10v10), `ui-snapper` (sections depuis composants pro), `asset-curator` (assets sourcés et optimisés) et `lp-reviewer` (score final).
- Point d'entrée : commande `/lp <brief>` — elle délègue à l'orchestrateur, elle ne conduit rien elle-même.
- Le **code** produit suit la méthodo du plugin `dev-methodology` s'il est actif.
