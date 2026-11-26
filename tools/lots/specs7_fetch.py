"""Strate 7 — récupère le wikitexte des articles Wikipédia anglais du catalogue.

Lit .lots/specs7/catalogue.json (export de la base : id, name, wikipedia_en…)
et écrit .lots/specs7/raw/<titre normalisé>.wiki, une page par article, par
lots de 50 titres (une requête), redirections suivies. Une seule file.

  python -I tools/lots/specs7_fetch.py
"""
import json
import time
import urllib.parse
from pathlib import Path

import requests

RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
DOSSIER = RACINE / 'specs7'
RAW = DOSSIER / 'raw'
UA = {'User-Agent': 'VolHistoireCatalogue/1.0 (https://vol-histoire.titouan-borde.com; vdh@titouan-borde.com) python-requests'}
EN = 'https://en.wikipedia.org/w/api.php'


def titre(url):
    return urllib.parse.unquote(url.rsplit('/wiki/', 1)[1]).replace('_', ' ').split('#')[0]


def fichier(t):
    return RAW / (t.replace('/', '∕') + '.wiki')


def api(params):
    params.update(format='json', formatversion=2)
    for essai in range(10):
        try:
            r = requests.get(EN, params=params, headers=UA, timeout=60)
            if r.status_code == 200:
                time.sleep(1.5)
                return r.json()
            if r.status_code == 429:
                time.sleep(int(r.headers.get('retry-after') or 30) + 2)
                continue
        except requests.RequestException:
            pass
        time.sleep(5 * (essai + 1))
    raise RuntimeError('échec API')


def main():
    cat = json.loads((DOSSIER / 'catalogue.json').read_text(encoding='utf-8'))
    titres = sorted({titre(a['wikipedia_en']) for a in cat})
    manquants = [t for t in titres if not fichier(t).exists()]
    print(len(titres), 'articles,', len(manquants), 'à télécharger', flush=True)
    resolution = {}
    rpath = DOSSIER / 'redirections.json'
    if rpath.exists():
        resolution = json.loads(rpath.read_text(encoding='utf-8'))
    for i in range(0, len(manquants), 50):
        lot = manquants[i:i + 50]
        d = api({'action': 'query', 'prop': 'revisions', 'rvprop': 'content', 'rvslots': 'main',
                 'redirects': 1, 'titles': '|'.join(lot)})
        q = d['query']
        alias = {}
        for n in q.get('normalized', []):
            alias[n['to']] = alias.get(n['from'], n['from'])
        for rd in q.get('redirects', []):
            alias[rd['to']] = alias.get(rd['from'], rd['from'])
        for page in q['pages']:
            demande = page['title']
            while demande in alias and demande not in lot:
                demande = alias[demande]
            if page.get('missing'):
                print('  absent :', page['title'], flush=True)
                continue
            texte = page['revisions'][0]['slots']['main']['content']
            fichier(demande).write_text(texte, encoding='utf-8')
            resolution[demande] = page['title']
        print(f'  {min(i + 50, len(manquants))}/{len(manquants)}', flush=True)
    rpath.write_text(json.dumps(resolution, ensure_ascii=False, indent=1), encoding='utf-8')
    reste = [t for t in titres if not fichier(t).exists()]
    print('non récupérés :', reste)


if __name__ == '__main__':
    main()
