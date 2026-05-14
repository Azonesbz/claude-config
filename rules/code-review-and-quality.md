# Revue et qualité — cinq axes

Avant de considérer une modification **terminée** (ou avant de résumer une PR), parcourir **les cinq axes** ci-dessous. Une case « non » doit être **corrigée** ou **justifiée** explicitement (risque accepté, follow-up ticket).

## 1. Comportement et correction

- Le changement fait-il ce que la demande décrit ? Cas limites et erreurs gérées ?
- Les tests (auto ou manuels décrits) **couvrent-ils** le chemin critique ?
- **Tests automatisés** : structure **Arrange – Act – Assert** (commentaires explicites par cas) et intention lisible.
- Régressions possibles sur les flux voisins ?

## 2. Sécurité et données

- Pas d'exposition de secrets, tokens ou données personnelles dans le code ou les logs.
- Validation des entrées utilisateur / réseau ; pas de confiance aveugle dans le client.
- Alignement avec les **politiques d'accès** (RLS Supabase, IAM, ACL) si la donnée est concernée.
- Pas d'injection SQL, XSS, traversal de chemin ou autre vulnérabilité OWASP top 10.

## 3. Maintenabilité

- Lisibilité, noms cohérents, responsabilités claires (voir aussi `code-organization.md`).
- Pas de duplication inutile ; réutilisation des utilitaires existants quand c'est pertinent.
- Types **honnêtes** dans les langages typés (éviter `any` / `interface{}` / `Object` sans raison).

## 4. Performance et ressources

- Re-renders, requêtes ou boucles inutiles ; chargements et listes raisonnables sur la cible (mobile, edge, batch…).
- Pas d'effets de bord coûteux dans des chemins fréquents sans mesure ou besoin clair.

## 5. UX, accessibilité et cohérence

- Cohérence avec les patterns UI du projet (thème, espacements, i18n).
- États de chargement / erreur / vide compréhensibles pour l'utilisateur.
- Charte / design system du projet quand l'écran ou le composant est visible.

## Usage avec le pipeline `/flow`

- **Fin de tâche** : passage rapide sur les cinq axes avant de marquer la tâche comme terminée dans le fil.
- **PR** : la description peut résumer les axes touchés (ex. surtout sécurité + UX si écran sensible).
