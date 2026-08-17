---
description: Landing page orchestrator — /lp + ton brief ; marché, blueprint, design, build, revue
argument-hint: <offre, cible et objectif de conversion en langage naturel>
---

Tu lances la pipeline **lp-builder**. Principe fondateur : **un beau site qui ne vend pas ne sert à rien** — la donnée marché précède le design, le design précède le code.

## Demande utilisateur

$ARGUMENTS

## Ce que tu fais

**Déléguer immédiatement à l'agent `lp-orchestrator`** (Agent tool, `subagent_type="lp-orchestrator"`) en lui passant la demande **telle quelle**. Il exécute la compétence `lp-pipeline` — sept étapes numérotées, chacune dans son fichier, lues juste avant d'être appliquées — tient la feuille de chantier et fait respecter les portes et les trois arrêts durs.

Ne fais pas le travail à sa place : cette commande est une **entrée fine**. La séquence vit dans `lp-pipeline`, sa conduite dans l'agent.

Avant de déléguer, un seul contrôle : si la demande ne permet pas d'identifier l'**offre**, la **cible** ou l'**objectif de conversion**, poser **une** série courte de questions (jamais un formulaire), puis déléguer. Sinon, déléguer directement — **aucune** confirmation `ok` / `go`.

## Contexte à transmettre à l'orchestrateur

- La demande utilisateur intégrale.
- Le **dépôt courant** s'il en existe un : stack détectée, conventions locales (`CLAUDE.md`, `.claude/rules/`), qui **priment** sur les règles globales.
- Si le plugin `dev-methodology` est actif : le code produit suit sa méthodo, et la mécanique git (branche, PR, Conventional Commits) sa skill `flow-pipeline`.

## À la fin

Restituer ce que rend l'orchestrateur : **score final vs la barre du marché**, état de livraison, emplacements restant à remplir par le client. Ne pas résumer en le vidant de ses chiffres.
