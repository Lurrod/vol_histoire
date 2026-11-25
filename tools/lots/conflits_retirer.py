"""Retire des liaisons appareil-conflit non attestées et corrige des récits de fiche.

Une décision du propriétaire, après le bilan d'un lot de pages de conflit, touche
toujours les mêmes fichiers :
  - la fiche (ligne de son INSERT INTO airplane_wars) ;
  - zz_backfill_relations.sql (nom retiré du bloc « WHERE w.name = … AND a.name IN (…) ») ;
  - 001_mise_a_niveau.sql : insertion « INSERT … NOT EXISTS » retirée s'il en existe
    une, bloc DELETE + UPDATE replace() ajouté avant le repère SENTINEL (section 6) ;
  - tools/lots/conflits/<slug>.json et .api.json (appareil retiré, date clé détachée).

Spécification (JSON) :
  {"lot": "3", "date": "2026-11-23", "why": "ligne de commentaire",
   "remove": {"Nom FR du conflit": ["Nom exact de l'appareil", …]},
   "fix": [{"name": "Nom exact", "fr": ["ancien", "nouveau"], "en": ["ancien", "nouveau"]}]}
Les textes de "fix" s'écrivent tels qu'en SQL (apostrophes doublées). Le nouveau
texte ne doit pas contenir l'ancien (sinon chaque rejeu rajouterait la phrase).

Usage : python -X utf8 tools/lots/conflits_retirer.py <spec.json>
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DB = ROOT / 'backend' / 'db_backup'
M001 = ROOT / 'backend' / 'migrations' / '001_mise_a_niveau.sql'
CONFLITS = Path(__file__).resolve().parent / 'conflits'
SENTINEL = '-- (fin des corrections issues des pages de conflit : .lots/tools/conflits_retirer.py)'  # repère historique matché dans 001 : ne pas modifier
SKIP = ('db.sql', 'zz_', 'timeline_events.sql')

q = lambda s: s.replace("'", "''")


def fiche_of(name):
    """Fiche qui insère l'appareil (son nom en 1re valeur de l'INSERT INTO airplanes)."""
    needle = f"\n    '{q(name)}',\n"
    for f in sorted(DB.glob('*.sql')):
        if f.name.startswith(SKIP):
            continue
        s = open(f, encoding='utf-8', newline='').read().replace('\r\n', '\n')
        if 'INSERT INTO airplanes' in s and needle in s:
            return f
    return None


def drop_from_fiche(path, plane, wars):
    raw = open(path, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in raw else '\n'
    lines = raw.replace('\r\n', '\n').split('\n')
    try:
        start = next(i for i, l in enumerate(lines) if l.startswith('INSERT INTO airplane_wars'))
    except StopIteration:
        return 0
    end = start + 1
    while not lines[end].rstrip().endswith(';'):
        end += 1
    vals = lines[start + 1:end + 1]
    keep = [v for v in vals if not any(f"wars WHERE name = '{q(w)}')" in v for w in wars)]
    removed = len(vals) - len(keep)
    if not removed:
        return 0
    keep = [v.rstrip().rstrip(',;') for v in keep]
    if keep:
        keep = [v + ',' for v in keep[:-1]] + [keep[-1] + ';']
        lines = lines[:start + 1] + keep + lines[end + 1:]
    else:
        s = start - 1 if lines[start - 1].strip().startswith('-- Conflits') else start
        e = end + 1
        if e < len(lines) and lines[e].strip() == '' and s > 0 and lines[s - 1].strip() == '':
            e += 1
        lines = lines[:s] + lines[e:]
    open(path, 'w', encoding='utf-8', newline='').write(nl.join(lines))
    return removed


def drop_from_zz(remove):
    p = DB / 'zz_backfill_relations.sql'
    raw = open(p, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in raw else '\n'
    s = raw.replace('\r\n', '\n')
    found = {}
    for war, names in remove.items():
        pat = re.compile(r"(WHERE w\.name = '" + re.escape(q(war)) + r"' AND a\.name IN \(\n)(.*?)(\n\)\nON CONFLICT DO NOTHING;)", re.S)
        drop = {f"'{q(n)}'" for n in names}
        for m in reversed(list(pat.finditer(s))):
            items = [x.strip().rstrip(',') for x in m.group(2).split('\n') if x.strip()]
            new = [x for x in items if x not in drop]
            if len(new) == len(items):
                continue
            for x in items:
                if x in drop:
                    found.setdefault(war, set()).add(x[1:-1].replace("''", "'"))
            assert new, f'bloc vide pour {war} : retirer tout le bloc à la main'
            body = '\n'.join('  ' + x + (',' if i < len(new) - 1 else '') for i, x in enumerate(new))
            s = s[:m.start(2)] + body + s[m.end(2):]
    open(p, 'w', encoding='utf-8', newline='').write(s.replace('\n', nl))
    return found


def patch_001(spec):
    s = open(M001, encoding='utf-8', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    # Insertions anciennes qui recréeraient la liaison avant le DELETE
    for war, names in spec['remove'].items():
        for n in names:
            ins = ("INSERT INTO airplane_wars (id_airplane, id_wars)" + nl + "SELECT a.id, r.id FROM airplanes a, wars r" + nl
                   + f"WHERE a.name = '{q(n)}' AND r.name = '{q(war)}'" + nl
                   + "  AND NOT EXISTS (SELECT 1 FROM airplane_wars x WHERE x.id_airplane = a.id AND x.id_wars = r.id);" + nl)
            if ins in s:
                s = s.replace(ins, '')
                print('001 : insertion retirée', n, '/', war)
    if SENTINEL not in s:
        anchor = '-- Récits corrigés (CONT-001, CONT-002).'
        assert s.count(anchor) == 1
        s = s.replace(anchor, SENTINEL + nl + nl + anchor)
    conds = [f"(w.name = '{q(w)}' AND a.name IN ({', '.join(chr(39) + q(n) + chr(39) for n in ns)}))"
             for w, ns in spec['remove'].items()]
    blk = [f"-- Pages de conflit, lot {spec['lot']} ({spec['date']}) : {spec['why']}"]
    if conds:
        blk += ["DELETE FROM airplane_wars l USING airplanes a, wars w",
                " WHERE l.id_airplane = a.id AND l.id_wars = w.id",
                "   AND (" + (nl + "     OR ").join(conds) + ");"]
    for fx in spec.get('fix', []):
        (ofr, nfr), (oen, nen) = fx['fr'], fx['en']
        blk += ["UPDATE airplanes SET description = replace(description,", f"    '{ofr}',", f"    '{nfr}'),",
                "  description_en = replace(description_en,", f"    '{oen}',", f"    '{nen}')",
                f" WHERE name = '{q(fx['name'])}'", "   AND (description, description_en)", "      IS DISTINCT FROM",
                f"      (replace(description, '{ofr}', '{nfr}'),", f"       replace(description_en, '{oen}', '{nen}'));"]
    s = s.replace(SENTINEL, nl.join(blk) + nl + nl + SENTINEL)
    open(M001, 'w', encoding='utf-8', newline='').write(s)


def fix_texts(fixes):
    for fx in fixes:
        (ofr, nfr), (oen, nen) = fx['fr'], fx['en']
        assert ofr not in nfr and oen not in nen, f"{fx['name']} : le nouveau texte contient l'ancien"
        f = fiche_of(fx['name'])
        assert f, f"fiche introuvable : {fx['name']}"
        t = open(f, encoding='utf-8', newline='').read()
        assert t.count(ofr) == 1 and t.count(oen) == 1, f"{f.name} : texte ancien absent ou en double"
        open(f, 'w', encoding='utf-8', newline='').write(t.replace(ofr, nfr).replace(oen, nen))
        print('récit corrigé :', f.name)


def update_json(remove):
    for pj in CONFLITS.glob('*.json'):
        if pj.name.endswith('.api.json'):
            continue
        d = json.loads(pj.read_text(encoding='utf-8'))
        names = remove.get(d.get('war'))
        if not names:
            continue
        for e in d.get('events', []):
            if e.get('aircraft') in names:
                print('date clé détachée :', d['war'], e['date'], e['aircraft'])
                e['aircraft'] = None
        d['aircraft'] = [a for a in d['aircraft'] if a['name'] not in names]
        pj.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        pa = pj.with_name(pj.name.replace('.json', '.api.json'))
        a = json.loads(pa.read_text(encoding='utf-8'))
        a['airplanes'] = [x for x in a['airplanes'] if x['name'] not in names]
        a['count'] = len(a['airplanes'])
        pa.write_text(json.dumps(a, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print('JSON :', d['war'], '— non attestés restants :', [x['name'] for x in d['aircraft'] if not x.get('attested')])


def main():
    spec = json.loads(Path(sys.argv[1]).read_text(encoding='utf-8'))
    remove = spec.get('remove', {})
    planes = {}
    for war, names in remove.items():
        for n in names:
            planes.setdefault(n, []).append(war)
    in_fiche = {}
    for plane, wars in planes.items():
        f = fiche_of(plane)
        assert f, f'fiche introuvable : {plane}'
        n = drop_from_fiche(f, plane, wars)
        if n:
            print(f'fiche {f.name} : {n} liaison(s) retirée(s)')
        in_fiche[plane] = n
    found = drop_from_zz(remove)
    for war, names in found.items():
        print('zz_backfill :', war, '→', sorted(names))
    # Chaque liaison doit avoir été trouvée quelque part (fiche ou zz)
    for war, names in remove.items():
        for n in names:
            ok = n in found.get(war, set()) or in_fiche.get(n)
            if not ok:
                print('ATTENTION : liaison introuvable dans les fiches et zz :', n, '/', war)
    fix_texts(spec.get('fix', []))
    patch_001(spec)
    update_json(remove)
    print('001 : bloc du lot', spec['lot'], 'ajouté')


if __name__ == '__main__':
    main()
