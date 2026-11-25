"""Strate 7 — extrait Mach max, distance de convoyage, points d'emport,
carburant interne et radar du gabarit {{Aircraft specs}} de chaque article,
et relève les mentions de supercroisière et de soute pour la revue.

Entrée : specs7/catalogue.json + specs7/raw/*.wiki
Sortie : specs7/extrait.json — une entrée par fiche :
  { name, titre, brut: {param: texte}, valeurs: {colonne: valeur}, notes: [...],
    supercroisiere: [extraits], soute: [extraits] }

  python -I tools/lots/specs7_parse.py
"""
import json
import re
import sys
import urllib.parse
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')
RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
D = RACINE / 'specs7'

# Fiches dont l'article partagé décrit un autre modèle : rien n'est repris.
EXCLUES = {
    'Rafale A', 'CASC CH-5 Rainbow', 'Beechcraft MC-12W Liberty', 'Embraer EMB 111 Bandeirulha',
    'KAI FA-50', 'F-35B Lightning II Anglais', 'Ilyushin Il-20 Coot', 'MiG-21 Bison',
}

PARAMS = ('max speed mach', 'max speed kmh', 'max speed note', 'max speed', 'ferry range km',
          'ferry range nmi', 'ferry range miles', 'ferry range note', 'fuel capacity', 'hardpoints',
          'avionics', 'more performance', 'more general', 'range km', 'range note')


def titre(url):
    return urllib.parse.unquote(url.rsplit('/wiki/', 1)[1]).replace('_', ' ').split('#')[0]


def gabarit(texte):
    """Contenu du premier {{Aircraft specs …}}, accolades équilibrées."""
    m = re.search(r'\{\{\s*aircraft specs', texte, re.I)
    if not m:
        return None
    i, prof = m.start(), 0
    while i < len(texte):
        if texte.startswith('{{', i):
            prof += 1
            i += 2
            continue
        if texte.startswith('}}', i):
            prof -= 1
            i += 2
            if prof == 0:
                return texte[m.end():i - 2]
            continue
        i += 1
    return None


def parametres(corps):
    """Découpe aux « | » de premier niveau (hors {{ }} et [[ ]])."""
    morceaux, prof, cour = [], 0, []
    i = 0
    while i < len(corps):
        deux = corps[i:i + 2]
        if deux in ('{{', '[['):
            prof += 1
            cour.append(deux)
            i += 2
            continue
        if deux in ('}}', ']]'):
            prof -= 1
            cour.append(deux)
            i += 2
            continue
        if corps[i] == '|' and prof == 0:
            morceaux.append(''.join(cour))
            cour = []
        else:
            cour.append(corps[i])
        i += 1
    morceaux.append(''.join(cour))
    out = {}
    for m in morceaux:
        if '=' in m:
            k, v = m.split('=', 1)
            k = k.strip().lower()
            v = re.sub(r'<!--.*?-->', '', v, flags=re.S).strip()
            if v:
                out[k] = v
    return out


def propre(t):
    """Wikitexte → texte lisible : liens, convert, ref, balises."""
    t = t.replace('&nbsp;', ' ').replace(' ', ' ')
    t = re.sub(r'<ref[^>]*/>', '', t)
    t = re.sub(r'<ref[^>]*>.*?</ref>', '', t, flags=re.S)
    t = re.sub(r'\{\{\s*(?:convert|cvt)\s*\|([^|}]+)\|([^|}]+)[^}]*\}\}', r'\1 \2', t, flags=re.I)
    t = re.sub(r'\{\{\s*(?:sfn|efn|cn|citation needed|refn|r)\b[^}]*\}\}', '', t, flags=re.I)
    t = re.sub(r'\[\[(?:[^|\]]*\|)?([^\]]+)\]\]', r'\1', t)
    t = re.sub(r"'''?", '', t)
    t = re.sub(r'<br\s*/?>', ' ; ', t)
    t = re.sub(r'<[^>]+>', '', t)
    t = re.sub(r'\{\{[^}]*\}\}', '', t)
    return re.sub(r'\s+', ' ', t).strip()


def nombre(s):
    s = s.replace(' ', ' ').replace(',', '')
    m = re.search(r'\d+(?:\.\d+)?', s)
    return float(m.group()) if m else None


def mach(p):
    """Mach max : paramètre dédié, sinon le plus grand Mach cité dans la
    vitesse (« M2.05 at 13000 m ; M1.06 at sea level » → 2,05), hors piqué."""
    v = p.get('max speed mach')
    if v:
        n = nombre(re.sub(r'(\d),(\d)', r'\1.\2', propre(v)))
        if n and 0.1 < n < 7:
            return n, 'max speed mach'
    for k in ('max speed note', 'max speed', 'more performance'):
        t = propre(p.get(k, ''))
        vus = []
        for m in re.finditer(r'(?:\bMach\s*|\bM)(\d(?:[.,]\d+)?)|(\d(?:[.,]\d+)?)\s*Mach\b', t):
            if 'dive' in t.lower()[max(0, m.start() - 40):m.end() + 40]:
                continue
            vus.append(float((m.group(1) or m.group(2)).replace(',', '.')))
        vus = [x for x in vus if 0.1 < x < 7]
        if vus:
            return max(vus), k
    return None, None


def convoyage(p):
    if p.get('ferry range km'):
        n = nombre(propre(p['ferry range km']))
        if n:
            return round(n), 'ferry range km'
    if p.get('ferry range nmi'):
        n = nombre(propre(p['ferry range nmi']))
        if n:
            return round(n * 1.852), 'ferry range nmi'
    if p.get('ferry range miles'):
        n = nombre(propre(p['ferry range miles']))
        if n:
            return round(n * 1.609344), 'ferry range miles'
    return None, None


MOTS = {'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8,
        'nine': 9, 'ten': 10, 'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14}
NOMBRE = r'(\d{1,2}|' + '|'.join(MOTS) + r')'


def emport(p):
    """Points d'emport. (1) « 11 (8× …) », « Total of 13: … », « Five
    hardpoints » : le total annoncé. (2) Sinon, une énumération de positions
    (« 6 underwing and 1 underfuselage ») est additionnée. Rien sinon."""
    t = propre(p.get('hardpoints', ''))
    if not t:
        return None
    tl = t.lower().replace('×', ' x ')
    m = re.match(r'\s*(?:a total of |total of |total |up to )?' + NOMBRE + r'\b', tl)
    if m:
        reste = tl[m.end():]
        n = int(m.group(1)) if m.group(1).isdigit() else MOTS[m.group(1)]
        if re.match(r'\s*(lb|kg|pounds?)\b', reste) or re.match(r'\s*for [a-z]+-\d', reste):
            return None
        if (tl.lstrip().startswith('total') or tl.lstrip().startswith('a total')
                or re.match(r'\s*(x\s*)?(hardpoints?|wing stations|stations)?\s*(in total|total)?\s*(\(|:|;|,|$|hardpoints|for |with |capable|on |under the|consisting)', reste)):
            return n if 0 < n <= 30 else None
    # Énumération : nombres en tête de chaque élément (calculée d'abord,
    # elle l'emporte sur un nombre de tête suivi d'un seul emplacement)
    morceaux = re.split(r',|;|\band\b|\bplus\b', tl)
    total, compte = 0, 0
    for mo in morceaux:
        mm = re.match(r'\s*' + NOMBRE + r'\s*(?:x\s*)?(under|over|wing|fuselage|cent|side|semi|inner|outer|internal|pylon|hardpoint|missile|air-to-air|underwing|underfuselage)', mo)
        if mm:
            total += int(mm.group(1)) if mm.group(1).isdigit() else MOTS[mm.group(1)]
            compte += 1
    if compte >= 2 and 0 < total <= 30:
        return total
    # Un seul élément : « 15 external hardpoints », « 4× under-wing pylon
    # stations », « Four underwing pylons each rated… »
    if m and re.match(r'\s*(x\s*)?(external |internal |under-?wing |wing |under-?fuselage )?'
                      r'(hardpoints?|pylons?|pylon stations|stations|under-?wing|external|wing pylons|bomb racks)', tl[m.end():]):
        n = int(m.group(1)) if m.group(1).isdigit() else MOTS[m.group(1)]
        return n if 0 < n <= 30 else None
    return None


DENSITE = {'jet': 0.8, 'piston': 0.72}

UNITES = [
    (r'kg|kilograms?', lambda n, d: n),
    (r'lbs?|pounds?', lambda n, d: n * 0.45359237),
    (r'imp ?gal|imperial gallons?', lambda n, d: n * 4.54609 * d),
    (r'u\.?s\.? ?gal\.?|us gallons?|gal|gallons?', lambda n, d: n * 3.785411784 * d),
    (r'l|litres?|liters?', lambda n, d: n * d),
]


def segment_interne(t):
    """Partie du texte qui décrit le carburant interne : le morceau qui dit
    « internal », sinon le premier (avant « + », « ; », « with », « plus »)."""
    morceaux = [m for m in re.split(r'\+|;|\bplus\b|\bwith\b|, provision|\bincluding external', t, flags=re.I)
                if re.search(r'\d', m)]
    for m in morceaux:
        if re.search(r'internal', m, re.I):
            return m
    return morceaux[0] if morceaux else t


def carburant(p, moteur):
    t = propre(p.get('fuel capacity', ''))
    if not t:
        return None, None
    seg = segment_interne(t).lower()
    dens = DENSITE['piston'] if moteur and re.search(r'moteur (en|à)|piston|rotatif', moteur, re.I) else DENSITE['jet']
    for motif, conv in UNITES:
        m = re.search(r'(\d[\d,.]*)\s*(?:' + motif + r')(?![a-z])', seg)
        if m:
            n = nombre(m.group(1))
            if n:
                return round(conv(n, dens)), t
    return None, t


def radar(p):
    brut = p.get('avionics', '')
    if not brut:
        return None, None
    lignes = re.split(r'\n\s*\*|<br\s*/?>|;|\n', brut)
    for l in lignes:
        if re.search(r'radar', l, re.I) and not re.search(r'warning|rwr|altimeter|jammer|homing and warning', l, re.I):
            return propre(l).strip(' *:-'), propre(brut)
    return None, propre(brut)


def extraits(texte, motif, largeur=160):
    out = []
    for m in re.finditer(motif, texte, re.I):
        out.append(propre(texte[max(0, m.start() - largeur):m.end() + largeur]))
        if len(out) >= 4:
            break
    return out


def main():
    cat = json.loads((D / 'catalogue.json').read_text(encoding='utf-8'))
    res = []
    for a in cat:
        t = titre(a['wikipedia_en'])
        f = D / 'raw' / (t.replace('/', '∕') + '.wiki')
        entree = {'name': a['name'], 'titre': t, 'brut': {}, 'valeurs': {}, 'notes': []}
        if a['name'] in EXCLUES:
            entree['notes'].append('exclue : article d\'un autre modèle')
            res.append(entree)
            continue
        texte = f.read_text(encoding='utf-8')
        corps = gabarit(texte)
        if corps is None:
            entree['notes'].append('pas de gabarit Aircraft specs')
            p = {}
        else:
            p = parametres(corps)
        entree['brut'] = {k: propre(v) for k, v in p.items() if k in PARAMS}
        v = entree['valeurs']
        v['mach_max'], src = mach(p)
        v['ferry_range'], _ = convoyage(p)
        v['hardpoints'] = emport(p)
        v['internal_fuel'], ftxt = carburant(p, a.get('engine_type'))
        v['radar_model'], _ = radar(p)
        if ftxt and re.search(r'external|drop tank|tanks?\)|with', ftxt, re.I):
            entree['notes'].append('carburant : texte mentionne externe/réservoirs')
        if ftxt and v['internal_fuel'] is None:
            entree['notes'].append('carburant non converti')
        if src and src != 'max speed mach':
            entree['notes'].append(f'Mach lu dans « {src} »')
        entree['supercroisiere'] = extraits(texte, r'supercruis')
        entree['soute'] = extraits(texte, r'(bomb|weapons?|internal|missile|ordnance)[ -]bays?', 120)
        res.append(entree)
    (D / 'extrait.json').write_text(json.dumps(res, ensure_ascii=False, indent=1), encoding='utf-8')
    for col in ('mach_max', 'ferry_range', 'hardpoints', 'internal_fuel', 'radar_model'):
        print(col, sum(1 for r in res if r['valeurs'].get(col) is not None))
    print('supercroisière mentionnée :', sum(1 for r in res if r.get('supercroisiere')))
    print('soute mentionnée :', sum(1 for r in res if r.get('soute')))


if __name__ == '__main__':
    main()
