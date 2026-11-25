"""Strate 7 — articles absents : titre retrouvé par recherche, wikitexte enregistré sous le titre demandé."""
import json, sys, time
sys.stdout.reconfigure(encoding="utf-8")
from pathlib import Path
import requests
sys.path.insert(0, str(Path(__file__).parent))
from specs7_fetch import UA, EN, fichier, DOSSIER
for t in sys.argv[1:]:
    s = requests.get(EN, params={'action': 'query', 'list': 'search', 'srsearch': t, 'srlimit': 3, 'format': 'json', 'formatversion': 2}, headers=UA, timeout=30).json()
    hits = [h['title'] for h in s['query']['search']]
    time.sleep(1.5)
    if not hits:
        print('RIEN', t); continue
    d = requests.get(EN, params={'action': 'query', 'prop': 'revisions', 'rvprop': 'content', 'rvslots': 'main', 'redirects': 1, 'titles': hits[0], 'format': 'json', 'formatversion': 2}, headers=UA, timeout=30).json()
    page = d['query']['pages'][0]
    fichier(t).write_text(page['revisions'][0]['slots']['main']['content'], encoding='utf-8')
    print(t, '->', page['title'], '| autres :', hits[1:])
    time.sleep(1.5)
