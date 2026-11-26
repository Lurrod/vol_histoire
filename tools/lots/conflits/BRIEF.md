# Brief — pages de conflit de Vol d'Histoire

Tu rédiges le contenu sourcé d'une page « conflit » pour Vol d'Histoire, une encyclopédie bilingue (français/anglais) de l'aviation militaire depuis 1945. Ton message de mission te donne le conflit, le slug et le fichier à produire.

La liste des appareils du catalogue rattachés à ce conflit (nom exact | pays de conception | type | premier vol | mise en service) est dans le fichier `lotN.txt` du même dossier que ce brief (ton message de mission le nomme), section `[<slug>]`.

## Ce que tu dois produire

Un fichier JSON valide (UTF-8), de cette forme exacte :

```json
{
  "slug": "<slug>",
  "outcome": {"fr": "une phrase : issue du conflit (ou situation actuelle s'il est en cours)", "en": "..."},
  "context": {"fr": "Markdown, 2 à 3 paragraphes : causes, enjeux, forces en présence", "en": "..."},
  "narrative": {"fr": "Markdown, 3 à 5 paragraphes : la guerre AÉRIENNE (phases, doctrine, moments marquants, bilan aérien chiffré si sourcé)", "en": "..."},
  "sides": [
    {"key": "clé-courte-en-minuscules", "name": {"fr": "…", "en": "…"}, "members": {"fr": "pays ou forces de ce camp", "en": "…"}}
  ],
  "events": [
    {"date": "AAAA-MM-JJ", "precision": "day", "title": {"fr": "…", "en": "…"}, "body": {"fr": "1 à 2 phrases", "en": "…"}, "aircraft": "nom exact du catalogue ou null", "source": "URL"}
  ],
  "aircraft": [
    {"name": "nom exact du catalogue", "side": "clé du camp, ou null s'il a servi dans plusieurs camps", "attested": true, "role": {"fr": "1 à 2 phrases, 300 caractères max", "en": "..."}, "sources": ["URL", "..."], "note": "vide, ou explication si attested=false ou doute"}
  ],
  "sources": ["URL des sources générales du contexte et du récit"]
}
```

Si ton message de mission dit que tu ne traites qu'une **partie des appareils**, produis seulement `{"slug": "…", "aircraft": [...]}` pour ces appareils-là.

## Règles

- **Recherche externe obligatoire** pour chaque appareil : Wikipédia EN et FR (article de l'appareil ET article des opérations aériennes du conflit), sites officiels (National Museum of the USAF, NHHC/US Navy, RAF Museum, ministères de la Défense, Armée de l'air et de l'espace), Air & Space Forces Magazine, Oryx (pertes documentées en Ukraine et en Syrie), ACIG. Cite au moins une URL par appareil, réellement consultée.
- **N'invente rien.** Un chiffre (sorties, victoires, pertes, exemplaires engagés) seulement s'il est dans une source citée. Si les sources divergent, dis-le (« selon X… ; selon Y… ») ou reste qualitatif. Les bilans de guerre en cours (Ukraine, Syrie) sont toujours attribués à leur source et datés.
- Chaque rôle dit **ce que cet appareil a concrètement fait dans CE conflit** (missions, unités ou pays utilisateurs, faits marquants), pas une description générale de l'appareil. Exemple de ton : « Le F-117 frappe dès la première nuit les centres de commandement et de défense aérienne de Bagdad, seul appareil engagé au-dessus du centre-ville. »
- `attested: false` si tu ne trouves AUCUNE source montrant que cet appareil (ou sa version militaire décrite par le catalogue) a été engagé dans ce conflit : entré en service après la fin du conflit, retiré avant, jamais livré à un belligérant, simple présence sans engagement… Explique dans `note`, avec la date ou le fait qui le prouve. Ne force jamais un rôle. Un engagement très marginal mais réel reste `attested: true`, avec une `note` qui le dit.
- **Doublons de fiches** : plusieurs fiches peuvent désigner le même avion. Une fiche nationale (« Mirage IIICJ Shahak », « F-4E Kurnass », « F-16I Soufa », « F-15I Ra'am », « Panavia Tornado Italien », « Eurofighter Typhoon Anglais », « … Allemand »…) décrit l'usage de CE pays ; la fiche générique décrit les autres utilisateurs. Si la fiche générique n'a, dans ce conflit, aucun autre utilisateur que celui qui a sa propre fiche, mets-la en `attested: false` avec `note: "doublon de <fiche nationale>"`.
- Un appareil employé par plusieurs camps : `side: null` et le rôle décrit chaque camp.
- Camps : 2 à 4, avec des clés courtes stables (ex. `etats-unis`, `nord-vietnam`, `russie`, `ukraine`, `otan`, `israel`, `pays-arabes`). Un camp « soutiens » (fournisseurs d'armes, ponts aériens) seulement si des appareils de la liste y appartiennent.
- `events` : 8 à 14 dates clés du conflit, centrées sur l'aérien, triées par date ; `precision` = "day", "month" ou "year" selon ce qu'on sait réellement (date au mois : `"1965-03"` accepté ; à l'année : `"1948"`) ; `aircraft` = nom exact du catalogue si l'événement concerne un appareil de la liste, sinon null. **Un événement ne peut viser qu'un appareil de la liste que tu marques `attested: true`.**
- Français soigné, phrases complètes, pas de jargon non expliqué, pas de liste à puces dans le récit ; noms d'opérations en italique Markdown (*Rolling Thunder*). Anglais naturel (pas du mot à mot). Typographie : guillemets « » en français, " " en anglais.
- Les noms d'appareils dans `aircraft[].name` et `events[].aircraft` doivent être **exactement** ceux de la liste (copier-coller), et chaque appareil de ta liste doit apparaître une fois et une seule dans `aircraft`.
- Vérifie que le JSON se parse : `python -c "import json;json.load(open(r'<fichier>',encoding='utf-8'))"`.

- Un conflit qui en recouvre un autre ayant sa propre page : ne raconte ici que ce qui relève de CE conflit, et nomme l'autre page si besoin.

Termine par un compte rendu court : nombre d'appareils attestés / non attestés (avec la raison pour chacun des non attestés), doublons signalés, et les points où les sources divergent.
