"""Collecte, pour chaque appareil du manifeste, la matière première d'une fiche.

Pour chaque ligne de manifest.tsv :
  - résout le titre Wikipédia anglais (redirections suivies, recherche en repli) ;
  - enregistre l'article en texte brut       -> wiki/<slug>.txt
  - enregistre l'infobox et la section « Specifications » en wikitexte brut,
    le titre français, l'élément Wikidata et la catégorie Commons (P373)
                                               -> wiki/<slug>.json

Une seule file, une pause entre les requêtes : Wikimedia refuse les rafales.

  python -I tools/lots/wiki.py [slug ...]     # sans argument : tout le manifeste
"""
import json
import re
import sys
import time
from pathlib import Path

import requests

RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
SORTIE = RACINE / 'wiki'
UA = {'User-Agent': 'VolHistoireCatalogue/1.0 (https://vol-histoire.titouan-borde.com; vdh@titouan-borde.com) python-requests'}
EN = 'https://en.wikipedia.org/w/api.php'
FR = 'https://fr.wikipedia.org/w/api.php'
WD = 'https://www.wikidata.org/w/api.php'
PAUSE = 2.0


def api(url, **params):
    params.update(format='json', formatversion=2)
    for essai in range(12):
        try:
            r = requests.get(url, params=params, headers=UA, timeout=30)
            if r.status_code == 200 and r.headers.get('content-type', '').startswith('application/json'):
                time.sleep(PAUSE)
                return r.json()
            if r.status_code == 429:
                attente = int(r.headers.get('retry-after') or 30) + 2
                print(f'   429, pause {attente} s', flush=True)
                time.sleep(attente)
                continue
        except requests.RequestException:
            pass
        time.sleep(5 * (essai + 1))
    raise RuntimeError(f'échec API {url} {params}')


def resoudre(titre):
    d = api(EN, action='query', titles=titre, redirects=1, prop='pageprops|langlinks',
            lllang='fr', ppprop='wikibase_item')
    page = d['query']['pages'][0]
    if page.get('missing'):
        s = api(EN, action='query', list='search', srsearch=titre, srlimit=1)
        hits = s['query']['search']
        if not hits:
            return None
        return resoudre(hits[0]['title'])
    return page


def section_specs(wikitexte):
    m = re.search(r'^==+\s*Specifications?[^=\n]*==+\s*$', wikitexte, re.M | re.I)
    if not m:
        return None
    suite = wikitexte[m.end():]
    fin = re.search(r'^==\s*[^=\n]+\s*==\s*$', suite, re.M)
    return (suite[:fin.start()] if fin else suite).strip()[:12000]


def infobox(wikitexte):
    m = re.search(r'\{\{\s*Infobox aircraft', wikitexte, re.I)
    if not m:
        return None
    # Toutes les infobox aircraft (begin + type + career) se suivent en tête.
    bloc = wikitexte[m.start():m.start() + 6000]
    fin = bloc.find("'''")
    return bloc[:fin if fin > 0 else 4000]


def commons_categorie(qid):
    if not qid:
        return None
    d = api(WD, action='wbgetentities', ids=qid, props='claims')
    claims = d['entities'][qid].get('claims', {})
    p373 = claims.get('P373')
    if p373:
        return p373[0]['mainsnak'].get('datavalue', {}).get('value')
    return None


def traiter(slug, titre):
    page = resoudre(titre)
    if not page:
        print(f'!! {slug}: aucun article pour « {titre} »')
        return
    vrai = page['title']
    qid = page.get('pageprops', {}).get('wikibase_item')
    fr = (page.get('langlinks') or [{}])[0].get('title')
    d = api(EN, action='query', titles=vrai, prop='revisions|extracts', rvprop='content', rvslots='main',
            explaintext=1)
    p0 = d['query']['pages'][0]
    wt = p0['revisions'][0]['slots']['main']['content']
    texte = p0.get('extract', '')
    texte_fr = ''
    if fr:
        e = api(FR, action='query', titles=fr, prop='extracts', explaintext=1)
        texte_fr = e['query']['pages'][0].get('extract', '')
    info = {
        'slug': slug,
        'demande': titre,
        'titre_en': vrai,
        'titre_fr': fr,
        'wikipedia_en': 'https://en.wikipedia.org/wiki/' + vrai.replace(' ', '_'),
        'wikipedia_fr': ('https://fr.wikipedia.org/wiki/' + fr.replace(' ', '_')) if fr else None,
        'wikidata': qid,
        'commons_categorie': commons_categorie(qid),
        'infobox': infobox(wt),
        'specifications': section_specs(wt),
    }
    (SORTIE / f'{slug}.json').write_text(json.dumps(info, ensure_ascii=False, indent=2), encoding='utf-8')
    (SORTIE / f'{slug}.txt').write_text(texte, encoding='utf-8')
    if texte_fr:
        (SORTIE / f'{slug}.fr.txt').write_text(texte_fr, encoding='utf-8')
    alerte = '' if vrai == titre else f'   (demandé : {titre})'
    print(f'ok {slug:22} {vrai} | fr={fr} | commons={info["commons_categorie"]}{alerte}', flush=True)


def main():
    SORTIE.mkdir(exist_ok=True)
    filtre = set(sys.argv[1:])
    lignes = (RACINE / 'manifest.tsv').read_text(encoding='utf-8').splitlines()[1:]
    for ligne in lignes:
        lot, slug, titre = ligne.split('\t')
        if filtre and slug not in filtre:
            continue
        if not filtre and (SORTIE / f'{slug}.json').exists():
            continue
        try:
            traiter(slug, titre)
        except Exception as exc:  # noqa: BLE001 — on poursuit la file
            print(f'!! {slug}: {exc}', flush=True)


if __name__ == '__main__':
    main()
