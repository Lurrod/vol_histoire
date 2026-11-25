# Brief — compléter les fiches d'appareils (Vol d'Histoire)

Vol d'Histoire est une encyclopédie bilingue (FR/EN) de l'aviation militaire. Règle du site : un appareil n'est rattaché à un conflit que si **sa propre fiche raconte l'engagement**. Les pages de conflit sont rédigées et sourcées ; mais certaines fiches d'appareils ne disent pas un mot de conflits auxquels l'appareil est rattaché. Tu complètes ces fiches.

## Entrée

Ton message de mission nomme un fichier `lotN.json` : une liste de fiches, chacune avec
- `name` : nom exact de l'appareil ;
- `description_fr`, `description_en` : le récit Markdown actuel de la fiche (sections `## Genèse`, `## Carrière opérationnelle`… / `## Genesis`, `## Operational career`…) ;
- `conflits` : les conflits que la fiche ne semble pas mentionner, avec `role_fr` / `role_en` (ce que l'appareil y a fait, **déjà vérifié et sourcé**) et `sources`.

La détection est automatique (par mots-clés) : elle peut se tromper.

## Ce que tu produis

Un fichier JSON (UTF-8) `lotN.fix.json` dans le même dossier : une liste, **une entrée par fiche** de ton lot, dans l'ordre :

```json
[
  {"name": "nom exact",
   "skip": false,
   "conflits": ["Guerre du Golfe", "Guerre d'Irak"],
   "fr": ["ancien texte exact", "nouveau texte"],
   "en": ["old exact text", "new text"],
   "note": ""}
]
```

- `skip: true` (sans `fr`/`en`) si la fiche raconte **déjà** l'engagement sous une autre formulation (ex. « Desert Storm », « opération Chammal », « 1973 » pour le Kippour…). Dis où dans `note`. Si elle n'en raconte qu'une partie, ne traite que les conflits manquants et liste-les dans `conflits`.
- `fr` / `en` : un seul remplacement par langue et par fiche, qui ajoute **tous** les conflits manquants de cette fiche.

## Règles du remplacement (impératives, contrôlées par script)

1. L'ancien texte est une **sous-chaîne exacte** de `description_fr` (resp. `description_en`), présente **une seule fois**.
2. Ni l'ancien ni le nouveau ne contiennent de saut de ligne : on travaille à l'intérieur d'un paragraphe.
3. **Le nouveau texte ne doit pas contenir l'ancien** (sinon chaque rejeu de la migration rajouterait la phrase). Techniques :
   - ancrer sur la fin d'une phrase **et le début de la suivante** : ancien `… au Yémen. Plus de` → nouveau `… au Yémen. <phrase ajoutée>. Plus de` ;
   - ou reformuler une phrase qui énumère des conflits : ancien `Engagé au Vietnam et lors des conflits du Moyen-Orient.` → nouveau `Engagé au Vietnam, lors des conflits du Moyen-Orient et dans la **guerre de l'Ogaden** (1977-1978), où …` ;
   - si l'ancre est la dernière phrase d'un paragraphe, ancre plutôt sur la phrase **qui la précède + le début** de la dernière, et insère avant.
4. Place l'ajout dans la section de carrière opérationnelle (ou celle qui raconte l'emploi au combat), à l'endroit où la chronologie le veut.
5. Apostrophe droite `'` (comme dans les fiches), **jamais doublée** : j'échappe moi-même pour le SQL. Guillemets « » en français, " " en anglais. Pas d'échappement `\n`.

## Contenu

- **Uniquement des faits présents dans `role_fr` / `role_en`.** Tu peux condenser, jamais ajouter (aucun chiffre, unité ou date qui n'y est pas).
- Une phrase (deux au plus) par conflit, dans le ton de la fiche : français soigné, phrases complètes, nom du conflit en gras Markdown comme dans les fiches (`**guerre du Golfe**`, `**Gulf War**`), opérations en italique (`*Desert Storm*`). Pas de liste à puces.
- Si un rôle dit qu'un fait est contesté ou attribué (« selon X »), garde la prudence.
- L'anglais dit la même chose que le français, en anglais naturel.
- Une fiche nationale (« F-16I Soufa », « Eurofighter Typhoon Anglais »…) raconte l'usage de CE pays.

## Vérification

Avant de rendre, vérifie par un petit script Python, pour chaque entrée non ignorée : ancien présent exactement une fois dans le texte correspondant ; pas de `\n` ; ancien non contenu dans le nouveau ; le JSON se parse. Ne touche à aucun fichier du dépôt.

Termine par un compte rendu court : fiches complétées, fiches ignorées (avec la raison), et les rôles qui t'ont semblé faibles ou incohérents avec la fiche.
