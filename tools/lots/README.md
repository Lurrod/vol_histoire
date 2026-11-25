# tools/lots — chaîne de contenu

Outils Python qui produisent les fiches et les fichiers SQL « générés » de
`backend/db_backup/`. Ils sont versionnés ici pour que ces fichiers restent
régénérables et relisibles en revue.

## Ce qui est versionné, ce qui ne l'est pas

| Emplacement | Contenu | Git |
|---|---|---|
| `tools/lots/*.py`, `valider.sh` | générateurs et contrôles | oui |
| `tools/lots/conflits/<slug>.json` | sources des 61 pages de conflit | oui |
| `tools/lots/conflits/<slug>.api.json` | réponse de `/api/wars/<slug>` (appareils rattachés) | oui |
| `tools/lots/conflits/BRIEF*.md` | consignes de recherche | oui |
| `.lots/json`, `.lots/photos`, `.lots/review`, `.lots/specs7`, `.lots/wiki`, `.lots/valid` | données de travail volumineuses, journaux, caches | non |

Les outils lisent les données de travail dans `.lots/` à la racine du dépôt
(`RACINE` dans chaque script) et écrivent dans `backend/`.

## Fichiers générés

| Fichier | Générateur | Sources |
|---|---|---|
| `backend/db_backup/zz_conflits.sql` | `conflits_build.py` | `tools/lots/conflits/*.json` |
| `backend/db_backup/zz_specs_strate7.sql` | `specs7_build.py` | `.lots/specs7/` (hors git) |
| `backend/db_backup/<fiche>.sql` | `gen_fiche.py` | `.lots/json/<slug>.json` (hors git) |

Ne jamais éditer ces fichiers à la main : corriger la source puis régénérer.
La CI régénère `zz_conflits.sql` et échoue s'il diffère de la version committée.

## Commandes courantes

```bash
python -X utf8 tools/lots/conflits_build.py --check   # valide les JSON sans écrire
python -X utf8 tools/lots/conflits_build.py           # régénère zz_conflits.sql
python -X utf8 tools/lots/conflits_retirer.py <spec.json>
python -X utf8 tools/lots/conflits_completer.py <fix.json> <lot> "<raison>"
python -I tools/lots/gen_fiche.py --check <slug>
bash tools/lots/valider.sh                            # installation neuve vs migration (PostgreSQL local)
```

Les repères textuels écrits dans `db.sql`, `001_mise_a_niveau.sql` et
`zz_backfill_relations.sql` citent encore l'ancien chemin `.lots/tools/…` :
ce sont des ancres que les outils recherchent, à ne pas modifier.
