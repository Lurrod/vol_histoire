"""Reporte les filiations des lots 29 à 38 dans zz_backfill_relations.sql.

  python -I tools/lots/zz.py

- Nouvelles fiches : un bloc UPDATE (prédécesseur, successeur, rival) par
  fiche, d'après `relations` de son JSON, entre deux marqueurs placés à la fin
  de la section « Filiations et rivalités ». Rejouable : le bloc est réécrit.
- Fiches existantes : seules les propositions `relations_existantes` retenues
  ci-dessous (REFUSEES les écarte) modifient le bloc de la fiche en place ; une
  fiche sans bloc en reçoit un dans la zone générée.
Toute nouvelle requête suit la forme du fichier : garde IS DISTINCT FROM.
"""
import json
import re
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent.parent
ZZ = RACINE / 'backend' / 'db_backup' / 'zz_backfill_relations.sql'
DEBUT = '-- >>> Lots 29 à 53 : nouvelles fiches (généré par .lots/tools/zz.py)'  # repère historique matché dans zz_backfill_relations.sql : ne pas modifier
FIN = '-- <<< Lots 29 à 53'
ANCRE = '-- ── Rattachement aux conflits'
CHAMPS = ('predecessor', 'successor', 'rival')

# (fiche, champ) écartés à la revue, avec la raison.
REFUSEES = {
    ('Avro Shackleton', 'predecessor'): 'filiation de conception, pas un remplacement en service',
    ('F-101 Voodoo', 'predecessor'): "le XF-88 n'a jamais servi : filiation de conception",
    ('Douglas C-124 Globemaster II', 'predecessor'): 'en service, le C-124 remplace le C-54 (déjà renseigné)',
    ('SOCATA TB-30 Epsilon', 'successor'): 'source unique (article FR), remplacement non établi',
    ('Blackburn Beverley', 'successor'): "remplacé surtout par le Hercules ; l'Andover dans un seul escadron",
    # Lots 44 à 53
    ('Bell XV-15', 'predecessor'): 'filiation de conception (démonstrateur), pas un remplacement en service',
    ('F-117 Nighthawk', 'predecessor'): 'Have Blue est le démonstrateur du F-117 : filiation de conception',
    ('Boeing X-45', 'predecessor'): 'Bird of Prey : autre programme, filiation de conception',
    ('Vickers VC10', 'predecessor'): 'source unique (article FR)',
    ('Mystère IV', 'predecessor'): "en service, le Mystère IV remplace l'Ouragan (déjà renseigné)",
    ('Iliouchine Il-20', 'successor'): 'remplacement par le Tu-214R non établi par les textes',
    ('Antonov An-32', 'successor'): "l'An-178 n'est pas encore en service",
    ('Short SC.1', 'predecessor'): "banc d'essai d'un autre constructeur : filiation de conception",
}

BLOC = re.compile(r"UPDATE airplanes SET\n  predecessor_id = (.*?),\n  successor_id   = (.*?),\n"
                  r"  rival_id       = (.*?)\nWHERE name = '((?:[^']|'')*)'\n  AND \(predecessor_id, successor_id, rival_id\)\n"
                  r"      IS DISTINCT FROM\n      \(.*?\);\n", re.S)


def q(nom: str) -> str:
    return nom.replace("'", "''")


def ref(nom: str | None) -> str:
    return 'NULL' if nom is None else f"(SELECT id FROM airplanes WHERE name = '{q(nom)}')"


def lire(expr: str) -> str | None:
    m = re.fullmatch(r"\(SELECT id FROM airplanes WHERE name = '((?:[^']|'')*)'\)", expr.strip())
    return m.group(1).replace("''", "'") if m else None


def bloc(nom: str, p: str | None, s: str | None, r: str | None) -> str:
    return (f'UPDATE airplanes SET\n  predecessor_id = {ref(p)},\n  successor_id   = {ref(s)},\n'
            f"  rival_id       = {ref(r)}\nWHERE name = '{q(nom)}'\n"
            f'  AND (predecessor_id, successor_id, rival_id)\n      IS DISTINCT FROM\n'
            f'      ({ref(p)}, {ref(s)}, {ref(r)});\n')


def main() -> None:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    s = ZZ.read_text(encoding='utf-8')
    s = re.sub(re.escape(DEBUT) + r'.*?' + re.escape(FIN) + r'\n\n', '', s, flags=re.S)
    existants = {m.group(4).replace("''", "'"): m for m in BLOC.finditer(s)}
    fiches = [json.loads(p.read_text(encoding='utf-8')) for p in sorted((RACINE / '.lots' / 'json').glob('*.json'))]

    # Relations des fiches existantes à modifier : nom -> {champ: valeur}
    modifs: dict[str, dict[str, str]] = {}
    for f in fiches:
        for r in f.get('relations_existantes') or []:
            if (r['fiche'], r['champ']) in REFUSEES:
                continue
            modifs.setdefault(r['fiche'], {})[r['champ']] = r['valeur']

    # Une proposition qui vise une fiche NEUVE se fond dans les relations de
    # cette fiche : deux blocs pour un même appareil se réécriraient à chaque rejeu.
    neuves = {f['name']: f for f in fiches}
    for nom in [n for n in modifs if n in neuves]:
        for c, v in modifs.pop(nom).items():
            neuves[nom]['relations'][c] = v
            print(f'fusionné {nom}: {c} = {v}')

    hors_bloc: dict[str, list[str | None]] = {}
    for nom, champs in modifs.items():
        if nom in existants:
            m = existants[nom]
            vals = [lire(m.group(i)) for i in (1, 2, 3)]
            for c, v in champs.items():
                vals[CHAMPS.index(c)] = v
            s = s.replace(m.group(0), bloc(nom, *vals), 1)
            print(f'modifié  {nom}: {champs}')
        else:
            vals = [None, None, None]
            for c, v in champs.items():
                vals[CHAMPS.index(c)] = v
            hors_bloc[nom] = vals
            print(f'nouveau bloc pour une fiche existante : {nom}: {champs}')

    nouveaux = [bloc(f['name'], *(f['relations'].get(c) for c in CHAMPS)) for f in sorted(fiches, key=lambda f: f['name'])]
    nouveaux += [bloc(n, *v) for n, v in sorted(hors_bloc.items())]
    zone = DEBUT + '\n\n' + '\n'.join(nouveaux) + FIN + '\n\n'
    i = s.index(ANCRE)
    s = s[:i] + zone + s[i:]
    ZZ.write_text(s, encoding='utf-8', newline='\n')
    print(f'{len(nouveaux)} blocs générés')


if __name__ == '__main__':
    main()
