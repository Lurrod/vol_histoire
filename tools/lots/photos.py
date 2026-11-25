"""Télécharge, dans une seule file, la photo retenue par chaque fiche JSON.

  python -I tools/lots/photos.py [slug ...]     # sans argument : toutes les fiches

Pour chaque `.lots/json/<slug>.json` dont `.lots/photos/<image>.jpg` manque,
demande à Commons une vignette de 1 920 px (taille standard de Commons) (la chaîne d'images du site la
ramène ensuite à 1 600 px) — plus légère que l'original et moins exposée aux
refus de débit. Les réponses 429 sont honorées (Retry-After).
"""
import json
import sys
import time
from pathlib import Path

import requests

RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
API = 'https://commons.wikimedia.org/w/api.php'
UA = {'User-Agent': 'VolHistoireCatalogue/1.0 (https://vol-histoire.titouan-borde.com; vdh@titouan-borde.com) python-requests'}
LARGEUR = 1920
PAUSE = 3.0


def obtenir(url: str, **kw) -> requests.Response:
    for essai in range(12):
        try:
            r = requests.get(url, headers=UA, timeout=120, **kw)
            if r.status_code == 200:
                time.sleep(PAUSE)
                return r
            if r.status_code == 429:
                # Retry-After seul relance trop tôt : le serveur d'images
                # prolonge le refus à chaque tentative. Recul exponentiel, ≤ 20 min.
                attente = min(max(int(r.headers.get('retry-after') or 60), 120) * 2 ** min(essai, 3), 1200)
                print(f'   429, pause {attente} s', flush=True)
                time.sleep(attente)
                continue
        except requests.RequestException:
            pass
        time.sleep(10 * (essai + 1))
    raise RuntimeError(f'échec {url}')


def telecharger(slug: str) -> None:
    f = json.loads((RACINE / 'json' / f'{slug}.json').read_text(encoding='utf-8'))
    sortie = RACINE / 'photos' / f"{f['image']}.jpg"
    if sortie.exists():
        return
    titre = f['photo']['titre']
    d = obtenir(API, params={'action': 'query', 'titles': titre, 'prop': 'imageinfo', 'iiprop': 'url|size|mime',
                             'iiurlwidth': LARGEUR, 'format': 'json', 'formatversion': 2}).json()
    page = d['query']['pages'][0]
    if 'imageinfo' not in page:
        print(f'!! {slug}: fichier introuvable sur Commons : {titre}', flush=True)
        return
    ii = page['imageinfo'][0]
    url = ii['thumburl'] if ii.get('width', 0) > LARGEUR else ii['url']
    r = obtenir(url)
    if r.content[:2] not in (b'\xff\xd8', b'\x89P'):
        print(f'!! {slug}: réponse qui n\'est pas une image ({url})', flush=True)
        return
    sortie.parent.mkdir(exist_ok=True)
    sortie.write_bytes(r.content)
    print(f'ok {slug:22} {f["image"]}.jpg  {len(r.content) // 1024} Ko', flush=True)


def main() -> None:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    slugs = sys.argv[1:] or sorted(p.stem for p in (RACINE / 'json').glob('*.json'))
    for s in slugs:
        try:
            telecharger(s)
        except Exception as exc:  # noqa: BLE001 — on poursuit la file
            print(f'!! {s}: {exc}', flush=True)


if __name__ == '__main__':
    main()
