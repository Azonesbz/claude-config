# J'ai publié une méthodo de dev pour Claude Code. 92 % ne s'exécute pas.

Elle fait 1 633 lignes : sept règles de code, huit agents, un pipeline `/flow`.
J'ai compté ce qui, là-dedans, **refuse** vraiment quelque chose.

**102 lignes.** Le reste — 1 255 lignes — est de la prose adressée au modèle.
Sur 46 règles inventoriées, **3 bloquent**. Les autres sont des vœux bien
écrits.

Ce n'est pas un aveu d'échec, c'est la chose la plus utile que j'aie apprise en
six mois : *une règle qu'on écrit et une règle qui refuse ne sont pas le même
objet.* La première, ton agent la lira et l'oubliera au troisième tour. La
seconde l'arrête.

Voilà la différence, en trois blocs. Puis un exercice.

---

## 1. À quoi ressemble une règle qui refuse

Le pipeline exige un staging ciblé : on stage les fichiers de la tâche en
cours, jamais l'arbre entier. C'est une règle de prose comme une autre — sauf
qu'elle a un exécuteur, un hook `PreToolUse` de 19 lignes.

Quand l'agent tente `git add -A`, il reçoit ceci :

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Blocked by flow rules: stage only this task's files with git add <path>, never git add -A / --all / . (see the flow-pipeline skill)."
  }
}
```

L'appel n'a pas lieu. L'agent lit la raison et corrige de lui-même :
`git add src/lib/auth.ts` passe, sortie vide, pas de commentaire.

Aucune discussion, aucun rappel à la règle, aucun « pense bien à ». Le geste
est simplement impossible.

## 2. Le mur a des portes

Voici le garde en entier — [`guard-git-add.sh`](../plugins/dev-methodology/hooks/guard-git-add.sh).
C'est tout ce qu'il y a : une expression régulière et un `if`.

```bash
readonly WHOLE_TREE_ADD='git[[:space:]]+add[[:space:]]+([^&|;]*[[:space:]])?(-A|--all|\.|:/)([[:space:]]|$)'

HOOK_INPUT="$(cat)"
command_str="$(hook_field command)" || exit 0  # pas de parseur JSON -> on laisse passer

if printf '%s' "${command_str}" | grep -Eq "${WHOLE_TREE_ADD}"; then
  hook_deny "Blocked by flow rules: stage only this task's files with git add <path>..."
fi
exit 0
```

Regarde le motif, puis regarde ce que j'obtiens en lui soumettant huit
commandes :

| Commande | Verdict |
| --- | --- |
| `git add -A` | **DENY** |
| `git add --all` | **DENY** |
| `git add .` | **DENY** |
| `git commit -am "wip"` | passe |
| `git commit -a -m wip` | passe |
| `git add -u` | passe |
| `git stage -A` | passe |
| `git add src/lib/auth.ts` | passe |

Les quatre derniers sont voulus. Les quatre du milieu, non : `git commit -am`
stage et committe l'arbre suivi d'un seul geste, exactement ce que la règle
interdit. Le motif cherche `git add` — il ne peut structurellement pas voir un
`commit -a`.

Ça se corrige en une ligne. Ce n'est pas le sujet.

Le sujet est que j'ai vécu des mois avec ce garde en croyant la règle tenue,
parce qu'un garde qui refuse trois fois par semaine **ressemble** à un garde
qui marche. Un garde ne protège que ce que son auteur a pensé à écrire — et il
ne te dit jamais ce qu'il a laissé passer.

## 3. L'exercice

Dans [`flow-pipeline`](../plugins/dev-methodology/skills/flow-pipeline/SKILL.md),
sous un titre qui dit littéralement **« Règles absolues »**, il y a cette ligne :

> Jamais de commit si un test échoue ou si le type-checker erre.

Absolue. Et **rien ne l'exécute.** Aucun hook, aucun `pre-commit`, rien. C'est
de la prose, comme 41 autres règles de ce dépôt. Je l'ai écrite, je l'ai
publiée, j'avais trois gardes fonctionnels sous les yeux depuis mai — et je ne
l'ai jamais écrite.

Écris-la. Pour ton dépôt à toi, pas pour le mien.

Le patron est là, sous licence MIT :
[`guard-plan-file.sh`](../plugins/dev-methodology/hooks/guard-plan-file.sh)
fait 19 lignes,
[son test](../plugins/dev-methodology/hooks/guard-plan-file.test.sh)
en fait 44 — un cas bloqué, un cas passant.

Fais écrire le bash par ton agent. C'est le comportement qu'on cherche, pas de
la triche. Ce que tu fais toi, et que lui ne fera pas à ta place, c'est
**choisir la règle**.

Parce que la vraie question n'a jamais été de taper vingt lignes de shell. Elle
est : parmi tout ce que tu t'es promis de faire proprement, **qu'est-ce qui
mérite de te refuser réellement** — et pourquoi tout le reste peut rester un
vœu.

Chez moi, cette réponse a mis six mois à venir, et elle m'a coûté une soirée à
chercher quel commit avait cassé quoi, dans un historique de `wip` et de `fix`
dont aucun ne s'annulait seul.

## 4. Si tu l'écris

[Ouvre une issue](https://github.com/Azonesbz/claude-config/issues/new) avec le
lien. Pas de compte à créer ailleurs, pas de formulaire, rien à installer, je
ne collecte rien.

Je veux juste savoir si quelqu'un le fait.

---

*Le protocole entier est dans ce dépôt : sept règles de code, huit agents,
trois gardes, MIT. La moitié se discute — et maintenant tu sais laquelle des
deux moitiés refuse vraiment.*
