"""Réconcilie les relations des fiches des lots 39 à 43 et contrôle les noms.

  python -I tools/lots/reconcilier.py [--ecrire]

Les rédacteurs ont nommé un appareil d'un autre lot par son titre Wikipédia
(colonne `enwiki` du manifeste). On le remplace par le `name` de sa fiche.
Ensuite, chaque valeur de relation (relations, relations_existantes) doit être
le nom EXACT d'une fiche existante (backend/db_backup/*.sql) ou d'une fiche
des lots : sinon la sous-requête de zz renverrait NULL sans erreur.
Contrôle aussi l'unicité des noms et des images.
"""
import json
import re
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
DEPOT = RACINE.parent
LOTS = {str(n) for n in range(44, 54)}


def noms_existants() -> set[str]:
    noms = set()
    motif = re.compile(r"INSERT INTO airplanes \([^)]*\)\s*VALUES\s*\(\s*'((?:[^']|'')*)'", re.S)
    for p in (DEPOT / 'backend' / 'db_backup').glob('*.sql'):
        if p.name in ('db.sql', 'zz_backfill_relations.sql', 'timeline_events.sql'):
            continue
        m = motif.search(p.read_text(encoding='utf-8'))
        if m:
            noms.add(m.group(1).replace("''", "'"))
    return noms


def main() -> None:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    ecrire = '--ecrire' in sys.argv
    lignes = [l.split('\t') for l in (RACINE / 'manifest.tsv').read_text(encoding='utf-8').splitlines()[1:] if l.strip()]
    slugs = {l[1]: l for l in lignes if l[0] in LOTS}
    fiches = {}
    for slug in slugs:
        p = RACINE / 'json' / f'{slug}.json'
        if p.exists():
            fiches[slug] = json.loads(p.read_text(encoding='utf-8'))
    enwiki = {slugs[s][2]: f['name'] for s, f in fiches.items()}
    existants = noms_existants()
    neufs = {f['name'] for f in fiches.values()}
    erreurs = 0

    # Unicité
    for nom in neufs & existants:
        print(f'!! nom déjà au catalogue : {nom}')
        erreurs += 1
    vus, images = {}, {}
    for s, f in fiches.items():
        if f['name'] in vus:
            print(f"!! nom en double : {f['name']} ({vus[f['name']]}, {s})")
            erreurs += 1
        vus[f['name']] = s
        if f['image'] in images:
            print(f"!! image en double : {f['image']} ({images[f['image']]}, {s})")
            erreurs += 1
        images[f['image']] = s
        if (DEPOT / 'frontend' / 'assets' / 'airplanes' / f"{f['image']}.jpg").exists():
            print(f"!! image déjà publiée : {f['image']} ({s})")
            erreurs += 1

    connus = existants | neufs
    for s, f in sorted(fiches.items()):
        modifie = False
        for champ, val in list(f['relations'].items()):
            if val in enwiki and val not in connus:
                f['relations'][champ] = enwiki[val]
                print(f'   {s}: {champ} {val!r} -> {enwiki[val]!r}')
                modifie = True
            v = f['relations'][champ]
            if v is not None and v not in connus:
                print(f'!! {s}: {champ} = {v!r} inconnu')
                erreurs += 1
            if v == f['name']:
                print(f'!! {s}: {champ} pointe sur elle-même')
                erreurs += 1
        for r in f.get('relations_existantes') or []:
            if r['valeur'] in enwiki and r['valeur'] not in connus:
                print(f"   {s}: relation existante {r['fiche']}.{r['champ']} {r['valeur']!r} -> {enwiki[r['valeur']]!r}")
                r['valeur'] = enwiki[r['valeur']]
                modifie = True
            for cle in ('fiche', 'valeur'):
                if r[cle] not in connus:
                    print(f"!! {s}: relation existante, {cle} = {r[cle]!r} inconnu")
                    erreurs += 1
        if modifie and ecrire:
            (RACINE / 'json' / f'{s}.json').write_text(json.dumps(f, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    manquants = sorted(set(slugs) - set(fiches))
    print(f'{len(fiches)} fiches lues, {len(manquants)} manquantes {manquants if manquants else ""}, {erreurs} erreur(s)'
          + ('' if ecrire else ' — relecture seule, --ecrire pour appliquer'))


if __name__ == '__main__':
    main()
