"""Présélection des photos Wikimedia Commons d'un appareil, pour revue à l'œil.

  python -I tools/lots/commons.py candidats <slug> [...]   # -> review/<slug>/
  python -I tools/lots/commons.py telecharger <slug> "<File:...>" <image-name>
                                                           # -> photos/<image-name>.jpg + credit

`candidats` parcourt la catégorie Commons de l'appareil (P373, relevée par
wiki.py) et ses sous-catégories, plus une recherche plein texte de repli,
garde les fichiers sous licence libre (PD, CC0, CC BY, CC BY-SA), de 1 400 px
de large au moins, au format paysage, les classe (bonus « in flight », malus
musée, cockpit, détail…) et télécharge un aperçu 640 px des meilleurs.

Le score ne remplace pas le coup d'œil : le nom d'un fichier Commons ne dit
pas ce que montre la photo. Chaque aperçu doit être ouvert avant d'être retenu.
Une seule file, pause entre requêtes : quatre recherches parallèles déclenchent
un refus de débit.
"""
import html
import json
import re
import sys
import time
from pathlib import Path

import requests

RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
API = 'https://commons.wikimedia.org/w/api.php'
UA = {'User-Agent': 'VolHistoireCatalogue/1.0 (https://vol-histoire.titouan-borde.com; vdh@titouan-borde.com) python-requests'}
PAUSE = 2.0
LARGEUR_MIN = 1400
NB_APERCUS = 10

IMAGE = re.compile(r'\.(jpe?g|png)$', re.I)
LICENCE_OK = re.compile(r'^(public domain|pd\b.*|cc0.*|cc[ -]by(-sa)?[ -]\d\.\d.*)$', re.I)
BONUS = re.compile(r'in[ _-]?flight|flying|airborne|take-?off|takeoff|departing|landing|approach|formation|refuel|over\b', re.I)
MALUS = re.compile(r'museum|cockpit|detail|engine|nose|interior|model|maquette|mock|display|exhibit|preserved|'
                   r'static|wreck|crash|tail|wing ?tip|gear|seat|panel|instrument|drawing|diagram|3[- ]?view|'
                   r'plan|logo|insignia|patch|stamp|toy|replica|memorial|gate ?guard|scrap|derelict', re.I)


def api(**params):
    params.update(format='json', formatversion=2)
    for essai in range(12):
        try:
            r = requests.get(API, params=params, headers=UA, timeout=60)
            if r.status_code == 200 and r.headers.get('content-type', '').startswith('application/json'):
                time.sleep(PAUSE)
                return r.json()
            if r.status_code == 429:
                time.sleep(int(r.headers.get('retry-after') or 30) + 2)
                continue
        except requests.RequestException:
            pass
        time.sleep(6 * (essai + 1))
    raise RuntimeError(f'échec API {params}')


def membres(categorie, profondeur=1, vus=None):
    vus = vus if vus is not None else set()
    if categorie in vus:
        return []
    vus.add(categorie)
    fichiers, souscats, suite = [], [], {}
    while True:
        d = api(action='query', list='categorymembers', cmtitle='Category:' + categorie,
                cmtype='file|subcat', cmlimit=500, **suite)
        for m in d['query']['categorymembers']:
            (fichiers if m['ns'] == 6 else souscats).append(m['title'])
        if 'continue' not in d:
            break
        suite = d['continue']
    if profondeur > 0:
        # Les sous-catégories « in flight » d'abord ; on plafonne pour borner le temps.
        souscats.sort(key=lambda t: (not BONUS.search(t), MALUS.search(t) is not None))
        for sc in souscats[:25]:
            if MALUS.search(sc):
                continue
            fichiers += membres(sc.split(':', 1)[1], profondeur - 1, vus)
    return fichiers


def recherche(texte, n=150):
    d = api(action='query', list='search', srsearch=texte, srnamespace=6, srlimit=n)
    # Le plein texte remonte aussi des scans de livres et des PDF : images seules.
    return [h['title'] for h in d['query']['search'] if IMAGE.search(h['title'])]


def infos(titres):
    res = []
    for i in range(0, len(titres), 20):
        lot = titres[i:i + 20]
        try:
            d = api(action='query', titles='|'.join(lot), prop='imageinfo',
                    iiprop='url|size|extmetadata|mime', iiurlwidth=640)
        except RuntimeError:  # URL trop longue ou lot refusé : on passe au suivant
            continue
        for p in d['query']['pages']:
            ii = (p.get('imageinfo') or [None])[0]
            if ii:
                res.append((p['title'], ii))
    return res


def nettoyer(valeur):
    return re.sub(r'\s+', ' ', html.unescape(re.sub(r'<[^>]+>', '', valeur or ''))).strip()


def evaluer(titre, ii):
    meta = ii.get('extmetadata', {})
    licence = nettoyer(meta.get('LicenseShortName', {}).get('value'))
    if ii.get('mime') not in ('image/jpeg', 'image/png') or not LICENCE_OK.match(licence):
        return None
    l, h = ii.get('width', 0), ii.get('height', 0)
    if l < LARGEUR_MIN or l < h * 1.2:
        return None
    texte = titre + ' ' + nettoyer(meta.get('ImageDescription', {}).get('value'))[:300]
    score = 10 * bool(BONUS.search(texte)) - 8 * bool(MALUS.search(titre)) - 3 * bool(MALUS.search(texte))
    score += min(l, 4000) / 1000
    return {
        'titre': titre,
        'score': round(score, 2),
        'largeur': l,
        'hauteur': h,
        'licence': licence,
        'auteur': nettoyer(meta.get('Artist', {}).get('value'))[:200],
        'credit': nettoyer(meta.get('Credit', {}).get('value'))[:200],
        'description': nettoyer(meta.get('ImageDescription', {}).get('value'))[:300],
        'url': ii['url'],
        'apercu': ii.get('thumburl'),
        'page': ii.get('descriptionurl'),
    }


def candidats(slug):
    w = json.loads((RACINE / 'wiki' / f'{slug}.json').read_text(encoding='utf-8'))
    titres = []
    if w.get('commons_categorie'):
        titres += membres(w['commons_categorie'])
    nom = w['titre_en']
    titres += recherche(f'"{nom}" flight')
    titres += recherche(nom)
    titres = list(dict.fromkeys(titres))
    notes = [e for e in (evaluer(t, ii) for t, ii in infos(titres)) if e]
    notes.sort(key=lambda e: -e['score'])
    dossier = RACINE / 'review' / slug
    dossier.mkdir(parents=True, exist_ok=True)
    for vieux in dossier.glob('*.jpg'):
        vieux.unlink()
    retenus = notes[:NB_APERCUS]
    for i, c in enumerate(retenus, 1):
        c['fichier'] = f'{i:02d}.jpg'
        r = requests.get(c['apercu'], headers=UA, timeout=60)
        (dossier / c['fichier']).write_bytes(r.content)
        time.sleep(PAUSE)
    (dossier / 'candidats.json').write_text(json.dumps(retenus, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f'{slug:22} {len(titres):4} fichiers vus, {len(notes):3} libres et assez grands, '
          f'{len(retenus)} aperçus', flush=True)


def telecharger(slug, titre, nom):
    d = api(action='query', titles=titre, prop='imageinfo', iiprop='url|size|extmetadata|mime')
    ii = d['query']['pages'][0]['imageinfo'][0]
    e = evaluer(titre, ii) or {}
    sortie = RACINE / 'photos' / f'{nom}.jpg'
    sortie.parent.mkdir(exist_ok=True)
    for essai in range(5):
        r = requests.get(ii['url'], headers=UA, timeout=120)
        if r.status_code == 200 and r.content[:2] in (b'\xff\xd8', b'\x89P'):
            break
        time.sleep(10 * (essai + 1))
    else:
        raise RuntimeError(f'téléchargement refusé : {ii["url"]}')
    sortie.write_bytes(r.content)
    meta = {'slug': slug, 'titre': titre, 'page': ii.get('descriptionurl'),
            'licence': e.get('licence'), 'auteur': e.get('auteur'), 'credit': e.get('credit'),
            'largeur': ii.get('width'), 'hauteur': ii.get('height')}
    (RACINE / 'photos' / f'{nom}.json').write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding='utf-8')
    print(json.dumps(meta, ensure_ascii=False))


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    if sys.argv[1] == 'candidats':
        for s in sys.argv[2:]:
            try:
                candidats(s)
            except Exception as exc:  # noqa: BLE001 — on poursuit la file
                print(f'!! {s}: {exc}', flush=True)
    elif sys.argv[1] == 'telecharger':
        telecharger(sys.argv[2], sys.argv[3], sys.argv[4])
