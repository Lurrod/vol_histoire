"""Range un JSON de recherche dans tools/lots/conflits/ (ajoute « war », copie l'.api.json).

Usage : python tools/lots/conflits_import.py <dossier_source> <slug> [<slug>…]
"""
import json
import shutil
import sys
from pathlib import Path

DEST = Path(__file__).resolve().parent / 'conflits'


def main() -> None:
    src = Path(sys.argv[1])
    for slug in sys.argv[2:]:
        api = json.loads((src / f'{slug}.api.json').read_text(encoding='utf-8'))
        data = json.loads((src / f'{slug}.json').read_text(encoding='utf-8'))
        data = {'war': api['name_fr'], **{k: v for k, v in data.items() if k != 'war'}}
        # Dates connues au mois (« 1950-12 ») ou à l'année (« 1950 ») : jour
        # fictif, la précision dit ce qu'on sait vraiment.
        for e in data.get('events', []):
            d = str(e.get('date', ''))
            if len(d) == 7:
                e['date'], e['precision'] = d + '-01', 'month'
            elif len(d) == 4:
                e['date'], e['precision'] = d + '-01-01', 'year'
        (DEST / f'{slug}.json').write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding='utf-8')
        shutil.copy(src / f'{slug}.api.json', DEST / f'{slug}.api.json')
        print('importé :', slug)


if __name__ == '__main__':
    main()
