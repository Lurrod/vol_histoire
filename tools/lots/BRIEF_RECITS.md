# Brief — réécrire les récits courts des fiches (Vol d'Histoire)

Vol d'Histoire est une encyclopédie bilingue (FR/EN) de l'aviation militaire de 1945 à aujourd'hui. Chaque fiche d'appareil porte un récit Markdown. La plupart font environ 2 000 caractères et suivent une trame soignée ; 64 fiches de l'ancien jeu n'en font que 500 à 1 000, en style télégraphique (« Version ultra-modernisée du Su-27… »), et l'une d'elles contenait une erreur grave (des « F-15 ukrainiens » qui n'ont jamais existé). Tu réécris entièrement les récits FR et EN des fiches de ton lot.

## Entrée

Ton message de mission nomme un fichier `lotN.json` (dans le même dossier que ce brief) : une liste de fiches, chacune avec
- `name` : nom exact de l'appareil (ne le change pas) ;
- `fichier` : chemin de la fiche SQL dans le dépôt `C:\Users\titou\Documents\vol_histoire` — lis-la pour connaître les données déjà publiées (dates de premier vol et de mise en service, constructeur, pays, vitesses, production, variantes, armement…) ;
- `description_fr`, `description_en` : le récit actuel ;
- `conflits` : les conflits auxquels l'appareil est rattaché sur le site, avec `role_fr` / `role_en` (ce qu'il y a fait, **déjà vérifié et sourcé**) et `sources`.

## Ce que tu produis

Un fichier JSON (UTF-8) `lotN.out.json` dans le même dossier : une liste, **une entrée par fiche**, dans l'ordre du lot :

```json
[
  {"name": "nom exact",
   "description_fr": "## Genèse\nTexte…\n\n## Conception\nTexte…\n\n## Carrière opérationnelle\nTexte…\n\n## Place dans l'histoire\nTexte…",
   "description_en": "## Genesis\n…\n\n## Design\n…\n\n## Operational career\n…\n\n## Place in history\n…",
   "sources": ["https://…", "https://…"],
   "note": ""}
]
```

## Trame (celle des 700 autres fiches)

- Français : `## Genèse` / `## Conception` / `## Essais` (facultatif) / `## Carrière opérationnelle` / `## Place dans l'histoire`.
- Anglais : `## Genesis` / `## Design` / `## Testing` (facultatif) / `## Operational career` / `## Place in history`.
- Appareil jamais entré en service (en développement, prototype) : pas de `Carrière opérationnelle` ; termine par `Essais` et `Place dans l'histoire`.
- Longueur : **1 600 à 2 600 caractères** en français (titres compris), l'anglais à l'avenant. Paragraphes séparés par une ligne vide, aucune liste à puces.
- Fiche nationale (« MiG-29 Allemand », « Eurofighter Typhoon Anglais », « AMX A-1 Brésilien », « F-8E (FN) Crusader »…) : elle raconte **l'appareil dans ce pays** (acquisition, unités, emploi, retrait), pas l'histoire générale du type, qui a sa propre fiche.

## Faits et sources (règles du propriétaire)

- **Recherche externe** : Wikipédia FR et EN au minimum, puis sources plus solides quand elles existent (constructeur, armée de l'air, ministère, musées, ouvrages et revues de référence, think tanks comme IISS, RUSI, CSIS). Mets toutes les URL utilisées dans `sources`.
- **Aucun chiffre, aucune date sans source.** En cas de divergence entre sources, dis-le dans le texte (« entre 300 et 340 selon les sources ») ou retiens la plus solide et signale-le dans `note`.
- Garde ce qui est juste dans le récit actuel, corrige ce qui est faux (et dis-le dans `note`).
- **Conflits** : la règle du site veut qu'un appareil rattaché à un conflit voie cet engagement **raconté dans sa fiche**. Chaque conflit de `conflits` doit donc figurer dans la `Carrière opérationnelle`, en cohérence avec `role_fr` / `role_en` (tu peux en reprendre les faits et en ajouter d'autres, sourcés ; ne les contredis jamais en silence — si un rôle te semble faux, dis-le dans `note`). N'ajoute pas d'engagement dans un conflit absent de la liste sans le signaler dans `note` (le propriétaire décidera du rattachement).
- Ne contredis pas les données de la fiche (dates, chiffres) ; si l'une te semble fausse, signale-le dans `note` sans la reprendre.
- Prudence sur l'actualité (Ukraine, exportations récentes, programmes en cours) : ce qui n'est pas vérifié reste au conditionnel ou dit « selon ».

## Style

- Français soigné, phrases complètes, ton d'encyclopédie vivante — ni télégraphique, ni emphatique, ni publicitaire. Le récit raconte : pourquoi l'avion naît, ce qui le distingue, ce qu'il a fait, ce qu'il laisse.
- Noms propres clés en gras Markdown (`**Irbis-E**`, `**Dassault**`), opérations en italique (`*Desert Storm*`), conflits souvent en gras (`**guerre du Golfe**`).
- Apostrophe droite `'`, **jamais doublée** (j'échappe pour le SQL) ; guillemets « » en français, " " en anglais. Espaces ordinaires : la typographie française (insécables) est ajoutée à l'affichage.
- L'anglais dit la même chose que le français, en anglais naturel (pas une traduction mot à mot).
- Exemple de ton (fiche Lockheed A-12, extrait) : « À Mach 3,2, le frottement de l'air porte la peau à plus de trois cents degrés : l'aluminium fond, il faut du **titane**. Or le principal producteur mondial est l'Union soviétique — la CIA en achète par sociétés-écrans. »

## Vérification avant de rendre

Par un petit script Python : le JSON se parse ; une entrée par fiche, dans l'ordre, `name` identique ; titres de la trame présents dans les deux langues ; longueur FR entre 1 600 et 2 600 ; pas d'apostrophe doublée ; chaque conflit de la liste est nommé (ou clairement désigné) dans la carrière de la fiche. **Ne modifie aucun fichier du dépôt** : tu ne fais qu'écrire `lotN.out.json`.

Termine par un compte rendu court : fiches rendues, erreurs corrigées dans l'ancien récit, rôles ou données de fiche qui te semblent faux, conflits que tu aurais ajoutés.
