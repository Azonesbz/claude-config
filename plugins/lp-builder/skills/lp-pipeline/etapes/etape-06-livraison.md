# Étape 06 — Livraison

**Sortie attendue** : page remise, emplacements client listés, dettes et risques dits.

**Arrêt dur** — cette étape contient le dernier des trois points où l'utilisateur décide : la **mise en ligne**.

## Le compte rendu

Rendre, dans le fil :

1. **Le score final** vs la barre des gagnants, avec le détail par critère et le nombre de tours de correction consommés.
2. **La feuille de chantier finale** : sections construites, source et **licence** de chaque composant.
3. **L'inventaire d'assets** : usage, source, licence, poids — et le **poids total** de la page.
4. **Les emplacements à remplir** par le client : chaque preuve manquante, à sa place dans la page.
5. **Ce qui reste ouvert** : dettes assumées, risques, mesures non faites, formulaire non branché le cas échéant.

Première ligne du compte rendu : le **score et l'état de livraison**. Le détail vient après.

## L'arrêt dur : la mise en ligne

**Ne jamais publier seul.** Déployer, brancher un domaine, connecter un formulaire à un service tiers, activer un outil de mesure d'audience, envoyer la page à qui que ce soit : ce sont des actions tournées vers l'extérieur, et elles appartiennent à l'utilisateur.

La pipeline **écrit** la page et prépare ce qu'il faut pour la publier. C'est lui qui la met au monde.

Si l'utilisateur demande explicitement la mise en ligne, la traiter comme une tâche **distincte**, après accord, et lui dire ce qui partira : quel hébergeur, quel domaine, quelles données quitteront sa machine.

## Ce qui ne part pas dans Git

Screenshots de vérification, artefacts de build, assets non optimisés, et la feuille de chantier elle-même : la preuve vit dans le fil, pas dans l'historique. Le commit relève de l'agent `conventional-commit` (plugin `dev-methodology`) ou du fil principal — pas de cette étape.

## Honnêteté finale

Si la page est livrée **sous la barre**, le dire en première ligne, avec l'écart et sa cause. Si une mesure n'a pas pu être faite, le dire. Si une preuve manque, la lister plutôt que de la combler.

Une landing page livrée avec ses trous nommés est réparable. Une landing page livrée avec ses trous comblés par des inventions est un risque pour celui qui la publie.

Fin de la séquence.
