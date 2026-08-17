# Étape 03 — Stack

**Sortie attendue** : stack décidée et annoncée en une ligne, conventions du dépôt relevées.

Étape courte, mais elle évite la faute la plus coûteuse de l'étape 04 : sourcer des composants React dans un projet qui n'en a pas.

## Dépôt existant — lire, ne rien imposer

1. **`package.json`** (ou `pyproject.toml`, `composer.json`, `Gemfile`) : framework, gestionnaire de paquets déduit du **lock**, scripts `dev` / `build` / `test` / `lint`.
2. **CSS** : Tailwind et sa version, CSS modules, styled-components, fichier de tokens existant.
3. **Dépendances déjà présentes** : bibliothèque d'animation, d'icônes, de composants. **Les réutiliser** plutôt qu'en ajouter une équivalente.
4. **Conventions locales** : `CLAUDE.md`, `.claude/rules/`, structure des dossiers, nommage. Elles **priment** sur toute règle globale — priorité au plus spécifique.

Si un système de design existe déjà dans le dépôt, les tokens de l'étape 02 s'y **alignent** au lieu de le concurrencer. Le signaler en une ligne.

## From scratch — défaut léger

Sans consigne contraire : **page statique + Tailwind**. Une landing page n'a presque jamais besoin d'un framework applicatif.

Un framework ne se justifie que par un besoin **réel et nommé** : rendu serveur pour le SEO sur un catalogue, contenu piloté par un CMS, intégration dans un produit existant. « C'est plus moderne » n'est pas un besoin.

## Formulaire et destination des conversions

L'objectif de conversion arrêté à l'étape 00 doit **atterrir** quelque part : service de formulaire, CRM, webhook, page de paiement. Relever ce qui existe déjà. Si rien n'est disponible, le noter : la page sera livrée avec un formulaire **non branché**, signalé comme tel — jamais un formulaire qui fait semblant de fonctionner.

## Méthodo de code

Si le plugin `dev-methodology` est actif, le code produit suit ses règles (fichiers ~100 lignes, fonctions courtes, une responsabilité par module) et la mécanique git sa skill `flow-pipeline`. Sinon, rester simple et cohérent avec le dépôt.

## Porte

La stack est décidée et **annoncée en une ligne** dans le fil, avec la raison si elle s'écarte du défaut.

Étape suivante : `etapes/etape-04-build.md`.
