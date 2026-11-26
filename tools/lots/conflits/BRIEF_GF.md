# Complément au brief — page « Guerre froide »

Lis d'abord le brief général : `tools/lots/conflits/BRIEF.md`. Ce complément le précise pour la guerre froide (1947-1991), page à 262 appareils traitée par six agents. Chacun reçoit une partie de la liste (`gf_pN.txt`, même dossier que ce complément ; format : `n°. nom exact | pays de conception | type | 1er vol | en service`).

## Ce qui compte comme engagement dans la guerre froide

La guerre froide n'a pas de front : un appareil y est **attesté** si une source montre un rôle concret dans la confrontation Est-Ouest, par exemple :
- alerte et dissuasion nucléaires (alerte au sol du SAC, *Chrome Dome*, forces aériennes stratégiques, *Quick Reaction Alert* de l'OTAN, régiments soviétiques à long rayon d'action) ;
- interception d'appareils du bloc adverse, police du ciel face à l'adversaire (Tu-95 escortés au large de l'Écosse, de l'Islande ou de l'Alaska…) ;
- reconnaissance stratégique, survols et vols périphériques, renseignement électronique, et les incidents qui en découlent (U-2 du 1er mai 1960, RB-47 de 1960, EC-121 de 1969, Lockheed P2V abattus…) ;
- lutte anti-sous-marine contre la flotte adverse, pistage des sous-marins ;
- crises : pont aérien de Berlin (1948-1949), crise de Berlin (1961), crise de Cuba (1962), Able Archer (1983)… ;
- déploiements avancés liés à la confrontation (Allemagne de l'Ouest, *REFORGER*), défection d'un pilote (MiG-25 de Belenko, 1976), etc.

**N'est pas un engagement** : avoir simplement été en service pendant la période, dans l'armée d'un des blocs, sans rôle documenté lié à la confrontation (cas fréquent des avions d'école, de liaison, de recherche, des prototypes). → `attested: false`, avec une `note` qui le dit (« simple présence en service, aucun rôle documenté »). Entré en service après le 26 décembre 1991, ou retiré avant 1947 → `attested: false` avec la date. Un appareil d'école ou de transport peut être attesté s'il a un rôle documenté (ex. transport du pont aérien de Berlin, avion d'entraînement armé en alerte).

**Les guerres « chaudes » ont leur propre page** (Corée, Vietnam, Suez, Afghanistan soviétique, Six Jours, Kippour, Malouines, guerres indo-pakistanaises, Angola/frontière sud-africaine, Ogaden, etc.) : ne les raconte pas ici. Un appareil qui n'a combattu que dans ces guerres, sans autre rôle dans la confrontation elle-même, est `attested: false` avec `note: "engagement raconté dans la page <conflit>"`.

## Camps (clés imposées, communes aux six agents)

- `occident` : États-Unis, OTAN et alliés occidentaux ;
- `bloc-sovietique` : URSS, pacte de Varsovie et alliés ;
- `neutres` : pays non alignés dont l'aviation a joué un rôle documenté dans la confrontation (ex. Suède : interceptions des avions de reconnaissance des deux blocs).
- `side: null` si l'appareil a servi dans plusieurs camps (le rôle décrit chacun).

## Rôles

Une à deux phrases, 300 caractères max en français, **concrètes** : unité ou force, base, type de mission, incident daté. Exemple : « Les B-52 du Strategic Air Command tiennent l'alerte nucléaire en vol de 1961 à 1968 (opération *Chrome Dome*), jusqu'à l'accident de Thulé en janvier 1968. » Une source au moins par appareil, réellement consultée ; aucun chiffre sans source.

## Sortie

- Partie 1 (agent principal) : le fichier complet `guerre-froide.json` (gabarit du brief : `slug`, `outcome`, `context`, `narrative`, `sides` avec les trois clés ci-dessus, `events`, `aircraft` pour SA partie seulement, `sources`). Le récit couvre toute la guerre froide **aérienne** (dissuasion, reconnaissance, interceptions, crises, course technologique), en renvoyant aux pages des guerres chaudes sans les raconter. `events` : 10 à 14 dates ; un événement ne vise qu'un appareil de SA partie, marqué attesté (sinon `null`).
- Parties 2 à 6 : `guerre-froide.pN.json` = `{"slug": "guerre-froide", "aircraft": [...]}` pour les appareils de ta partie seulement.
- Fichiers dans le dossier de ce complément. Noms copiés exactement depuis ta liste, chacun une fois. Vérifie par script : JSON valide, noms exacts, couverture complète de ta liste, rôles ≤ 300 caractères, `side` parmi les trois clés ou null. Ne touche à aucun fichier du dépôt.

Termine par un compte rendu : attestés / non attestés (avec la raison résumée), doublons (fiches nationales), divergences de sources.
