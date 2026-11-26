"""Applique une liste de corrections de fiche (texte brut, apostrophes simples).

Usage : python -X utf8 appliquer_fix.py <fix.json> <lot> "<raison>"
Valide tout avant d'écrire, reporte chaque correction dans les réécritures
complètes (E'…') de 001 situées avant le repère, puis appelle conflits_retirer.py.
"""
import json, subprocess, sys
ROOT = __import__('pathlib').Path(__file__).resolve().parents[2].as_posix()
sys.path.insert(0, ROOT + '/tools/lots')
from conflits_retirer import fiche_of, q, SENTINEL  # noqa: E402

src, lot, why = sys.argv[1], sys.argv[2], sys.argv[3]
fixes, errs = [], []
for e in json.load(open(src, encoding='utf-8')):
    if e.get('skip'):
        continue
    fx = {'name': e['name'], 'fr': [q(x) for x in e['fr']], 'en': [q(x) for x in e['en']]}
    f = fiche_of(e['name'])
    if not f:
        errs.append(('fiche introuvable', e['name'])); continue
    t = open(f, encoding='utf-8', newline='').read()
    for k in ('fr', 'en'):
        o, n = fx[k]
        if chr(10) in o + n or chr(92) in o + n: errs.append(('saut ou antislash', e['name'], k))
        if o in n: errs.append(("le nouveau contient l'ancien", e['name'], k))
        if t.count(o) != 1: errs.append((f'ancien présent {t.count(o)} fois', e['name'], k, o[:70]))
    fixes.append(fx)
if errs:
    sys.exit('ERREURS : ' + repr(errs))
m = ROOT + '/backend/migrations/001_mise_a_niveau.sql'
s = open(m, encoding='utf-8', newline='').read()
head, tail = s.split(SENTINEL, 1)
lines = head.split('\r\n')
for fx in fixes:
    for k in ('fr', 'en'):
        o, n = fx[k]
        for i, l in enumerate(lines):
            if o in l and "E'" in l:
                lines[i] = l.replace(o, n)
                print('001 : réécriture complète alignée', fx['name'], k, 'ligne', i + 1)
open(m, 'w', encoding='utf-8', newline='').write('\r\n'.join(lines) + SENTINEL + tail)
spec = {'lot': lot, 'date': '2026-11-23', 'why': why, 'remove': {}, 'fix': fixes}
sp = src.replace('.json', '.spec.json')
json.dump(spec, open(sp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
subprocess.run([sys.executable, '-X', 'utf8', ROOT + '/tools/lots/conflits_retirer.py', sp], check=True)
