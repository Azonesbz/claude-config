---
name: incremental-implementation
description: Découpe du travail en tranches petites et vérifiables — un objectif unique par tranche, une preuve (test ciblé ou vérification manuelle documentée), peu de fichiers métier, ordre contrat → logique → présentation. À charger quand tu planifies une feature, un refactor ou une PR, ou quand une tâche commence à mélanger plusieurs intentions.
---

# Implémentation incrémentale

## Principe

Découper le travail en **tranches petites**, chacune **vérifiable** seule : tests verts, comportement observable, ou critère d'acceptation explicite. Éviter les gros blocs « tout d'un coup » difficiles à reviewer et à annuler.

## Une tranche = quoi ?

- **Objectif unique** : une intention claire (ex. « valider le formulaire », pas « refonte complète du module »).
- **Preuve** : au moins un test ciblé, ou une vérification manuelle documentée si la tâche est purement docs/outillage.
- **Limite de surface** : préférer peu de fichiers métier par tranche (voir **Granularité** dans la skill `flow-pipeline`).

## Ordre recommandé

1. Contrat ou données (types, helpers purs, schémas) **avec tests** si possible.
2. Logique métier / hooks / services.
3. Présentation (composants, écrans, endpoints) branchée sur l'existant.

Les tranches peuvent être **verticales** (une fine fonctionnalité bout-en-bout) tant que chaque pas reste petit et testable.

## Lien avec TDD

Pour chaque tranche : appliquer le motif **Prove-It** (skill `test-driven-development`) — test qui échoue, puis implémentation minimale. Tout cas de test produit en **Arrange – Act – Assert** avec commentaires explicites (`// Arrange`, etc.) comme dans la même règle.

## Signaux d'alarme

- Plusieurs intentions dans le même commit ou la même PR sans découpage.
- « On verra les tests à la fin » pour du code métier nouveau ou modifié.
- Refactor massif mélangé à un correctif ou une feature : **séparer** les tranches.
