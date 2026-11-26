"""Fusionne <slug>.partB.json (rôles seuls) dans <slug>.json, puis contrôle la
couverture : chaque appareil de <slug>.api.json une fois et une seule.

Usage : python -X utf8 tools/lots/conflits_merge.py <dossier_du_lot> <slug> [<slug>…]
(avant conflits_import.py ; le dossier contient <slug>.json, <slug>.partB.json, <slug>.api.json)
"""
import json
import sys
from pathlib import Path



def load(p):
    return json.loads(p.read_text(encoding='utf-8'))


def main():
    HERE = Path(sys.argv[1])
    for slug in sys.argv[2:]:
        main_p = HERE / f'{slug}.json'
        part_p = HERE / f'{slug}.partB.json'
        data = load(main_p)
        if part_p.exists():
            extra = load(part_p).get('aircraft', [])
            have = {a['name'] for a in data['aircraft']}
            data['aircraft'] += [a for a in extra if a['name'] not in have]
            main_p.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding='utf-8')
        api = {a['name'] for a in load(HERE / f'{slug}.api.json')['airplanes']}
        names = [a['name'] for a in data['aircraft']]
        missing = sorted(api - set(names))
        unknown = sorted(set(names) - api)
        dupes = sorted({n for n in names if names.count(n) > 1})
        keys = {s['key'] for s in data.get('sides', [])}
        bad_side = sorted({a['name'] for a in data['aircraft'] if a.get('side') and a['side'] not in keys})
        print(f'{slug}: {len(names)}/{len(api)} appareils, manquants={missing}, inconnus={unknown}, doublons={dupes}, camp inconnu={bad_side}')


if __name__ == '__main__':
    main()
