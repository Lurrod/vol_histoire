"""Écrit backend/db_backup/<slug>.sql à partir de .lots/json/<slug>.json.

Le gabarit reproduit celui des fiches existantes (x59_quesst.sql). Avant
d'écrire, chaque référence (pays, constructeur, type, technologie, armement,
mission, conflit) est vérifiée contre db.sql : une référence inconnue ne lève
AUCUNE erreur au chargement (clé étrangère nullable) ou fait échouer tout le
fichier (tables de liaison NOT NULL) — dans les deux cas, on refuse ici.

  python -I tools/lots/gen_fiche.py <slug> [...]       # écrit les fiches
  python -I tools/lots/gen_fiche.py --check <slug> ... # vérifie sans écrire
  python -I tools/lots/gen_fiche.py --lot 29           # tout un lot du manifeste
"""
import json
import re
import sys
from pathlib import Path

RACINE = Path(__file__).resolve().parents[2] / '.lots'  # données de travail hors git (json, photos, wiki, specs7…)
DEPOT = RACINE.parent
DB_SQL = DEPOT / 'backend' / 'db_backup' / 'db.sql'
SORTIE = DEPOT / 'backend' / 'db_backup'

STATUTS = {'Retiré': 'Retired', 'En service': 'In service', 'Annulé': 'Cancelled',
           'En développement': 'In development'}
FURTIVITE = {'aucune', 'reduite', 'moderee', 'elevee', 'tres_elevee'}

SPECS = [
    ('Strate 1 : fiche technique étendue', ['length', 'wingspan', 'height', 'wing_area', 'empty_weight', 'mtow',
                                            'service_ceiling', 'climb_rate', 'g_limit_pos', 'g_limit_neg',
                                            'combat_radius', 'crew']),
    ('Strate 2 : motorisation', ['engine_name', 'engine_count', 'engine_type', 'engine_type_en',
                                 'thrust_dry', 'thrust_wet']),
    ('Strate 3 : production & service', ['production_start', 'production_end', 'units_built', 'unit_cost_usd',
                                         'unit_cost_year', 'operators_count', 'variants', 'variants_en']),
    ('Strate 4 : qualitatif', ['nickname']),
    ('Strate 6 : médias externes et attribution de la photo', ['wikipedia_fr', 'wikipedia_en', 'youtube_showcase',
                                                                'manufacturer_page', 'image_credit',
                                                                'image_licence']),
]
REQUIS = ['slug', 'name', 'name_en', 'complete_name', 'complete_name_en', 'little_description',
          'little_description_en', 'image', 'photo', 'description', 'description_en', 'country',
          'date_concept', 'date_first_fly', 'date_operationel', 'max_speed', 'max_range', 'manufacturer',
          'generation', 'type', 'status', 'tech', 'armement', 'missions', 'wars', 'stealth_level', 'relations']
REQUIS += [c for _, cols in SPECS for c in cols]


def referentiel():
    """Noms connus de chaque table de référence, lus dans db.sql."""
    sql = DB_SQL.read_text(encoding='utf-8')
    ref = {t: set() for t in ('countries', 'manufacturer', 'type', 'tech', 'armement', 'missions', 'wars')}
    for m in re.finditer(r'INSERT INTO (\w+) \([^)]*\) VALUES\s*(.*?);\s*$', sql, re.S | re.M):
        table, corps = m.group(1), m.group(2)
        if table not in ref:
            continue
        for ligne in corps.splitlines():
            ligne = ligne.strip()
            if not ligne.startswith('('):
                continue
            litteraux = [x.replace("''", "'") for x in re.findall(r"'((?:[^']|'')*)'", ligne)]
            if not litteraux:
                continue
            if table == 'manufacturer':
                ref[table].add(litteraux[-1])
            elif table == 'countries':
                ref[table].add(litteraux[2])
            else:
                ref[table].add(litteraux[0])
    return ref


def lit(v):
    """Littéral SQL : NULL, nombre, chaîne simple ou chaîne E'' si retour à la ligne."""
    if v is None:
        return 'NULL'
    if isinstance(v, bool):
        raise ValueError('booléen inattendu')
    if isinstance(v, (int, float)):
        return repr(v)
    s = str(v)
    if '\n' in s or '\\' in s:
        return "E'" + s.replace('\\', '\\\\').replace("'", "''").replace('\n', '\\n') + "'"
    return "'" + s.replace("'", "''") + "'"


def verifier(f, ref):
    erreurs = [f'champ manquant : {c}' for c in REQUIS if c not in f]
    if erreurs:
        return erreurs
    if f['country'] not in ref['countries']:
        erreurs.append(f"pays inconnu : {f['country']}")
    if f['manufacturer'] not in ref['manufacturer']:
        erreurs.append(f"constructeur inconnu : {f['manufacturer']}")
    if f['type'] not in ref['type']:
        erreurs.append(f"type inconnu : {f['type']}")
    for cle, table in (('tech', 'tech'), ('armement', 'armement'), ('missions', 'missions'), ('wars', 'wars')):
        for n in f[cle]:
            if n not in ref[table]:
                erreurs.append(f'{cle} inconnu : {n}')
    if f['status'] not in STATUTS:
        erreurs.append(f"statut hors vocabulaire : {f['status']}")
    if f['stealth_level'] not in FURTIVITE:
        erreurs.append(f"furtivité hors vocabulaire : {f['stealth_level']}")
    if f['generation'] not in (1, 2, 3, 4, 5):
        erreurs.append('génération hors 1..5')
    if not f['missions']:
        erreurs.append('aucune mission')
    for c in ('date_concept', 'date_first_fly', 'date_operationel'):
        if f[c] is not None and not re.fullmatch(r'\d{4}-\d{2}-\d{2}', f[c]):
            erreurs.append(f'date mal formée : {c}')
    d = [f[c] for c in ('date_concept', 'date_first_fly', 'date_operationel')]
    if d[0] and d[1] and d[1] < d[0] or d[1] and d[2] and d[2] < d[1]:
        erreurs.append('chronologie concept <= premier vol <= mise en service violée')
    if f['mtow'] and f['empty_weight'] and f['mtow'] < f['empty_weight']:
        erreurs.append('mtow < empty_weight')
    if f['crew'] is not None and not 1 <= f['crew'] <= 120:
        erreurs.append('crew hors 1..120')
    if f['engine_count'] is not None and not 1 <= f['engine_count'] <= 10:
        erreurs.append('engine_count hors 1..10')
    if f['thrust_dry'] and f['thrust_wet'] and f['thrust_wet'] < f['thrust_dry']:
        erreurs.append('thrust_wet < thrust_dry')
    if f['combat_radius'] and f['max_range'] and f['combat_radius'] > f['max_range']:
        erreurs.append('combat_radius > max_range')
    if f['production_start'] and f['production_end'] and f['production_end'] < f['production_start']:
        erreurs.append('production_end < production_start')
    if f['unit_cost_year'] is not None and not 1940 <= f['unit_cost_year'] <= 2100:
        erreurs.append('unit_cost_year hors 1940..2100')
    for c in ('length', 'wingspan', 'height', 'wing_area', 'empty_weight', 'mtow', 'max_speed', 'max_range',
              'service_ceiling', 'climb_rate', 'combat_radius', 'thrust_dry', 'thrust_wet', 'g_limit_pos'):
        if f[c] is not None and f[c] <= 0:
            erreurs.append(f'{c} doit être > 0')
    if f['g_limit_neg'] is not None and f['g_limit_neg'] >= 0:
        erreurs.append('g_limit_neg doit être < 0')
    if len(f['little_description']) > 255 or len(f['little_description_en']) > 255:
        erreurs.append('little_description > 255 caractères')
    if not re.fullmatch(r'[a-z0-9-]+', f['image']):
        erreurs.append('image : minuscules, chiffres et tirets seulement')
    for c in ('description', 'description_en'):
        titres = re.findall(r'^## (.+)$', f[c], re.M)
        if len(titres) < 3:
            erreurs.append(f'{c} : au moins trois sections « ## »')
    for c in ('photo',):
        for k in ('titre', 'licence', 'url'):
            if not f[c].get(k):
                erreurs.append(f'photo.{k} manquant')
    return erreurs


def rendre(f):
    nom = f['name']
    q = lit(nom)
    p = f['photo']
    out = [f"-- {f['complete_name']}", '--', f"-- Photo : {p['titre'].removeprefix('File:')}",
           f"--   licence {p['licence']} — {p.get('auteur') or 'auteur non indiqué'}", f"--   {p['url']}", '',
           '-- Insertion dans airplanes', 'INSERT INTO airplanes (']
    cols = ['name', 'name_en', 'complete_name', 'complete_name_en', 'little_description', 'little_description_en',
            'image_url', 'description', 'description_en', 'country_id', 'date_concept', 'date_first_fly',
            'date_operationel', 'max_speed', 'max_range', 'id_manufacturer', 'id_generation', 'type', 'status',
            'status_en']
    out.append(',\n'.join('    ' + c for c in cols))
    vals = [lit(f['name']), lit(f['name_en']), lit(f['complete_name']), lit(f['complete_name_en']),
            lit(f['little_description']), lit(f['little_description_en']),
            lit(f"/assets/airplanes/{f['image']}.jpg"), lit(f['description']), lit(f['description_en']),
            f"(SELECT id FROM countries WHERE code = {lit(f['country'])})",
            lit(f['date_concept']), lit(f['date_first_fly']), lit(f['date_operationel']),
            lit(f['max_speed']), lit(f['max_range']),
            f"(SELECT id FROM manufacturer WHERE code = {lit(f['manufacturer'])})",
            f"(SELECT id FROM generation WHERE generation = {f['generation']})",
            f"(SELECT id FROM type WHERE name = {lit(f['type'])})",
            lit(f['status']), lit(STATUTS[f['status']])]
    out.append(') VALUES (')
    out.append(',\n'.join('    ' + v for v in vals))
    out.append(');')

    def liaison(titre, table, col, ref_table, noms):
        if not noms:
            return
        out.extend(['', f'-- {titre}', f'INSERT INTO {table} (id_airplane, {col}) VALUES'])
        lignes = [f"((SELECT id FROM airplanes WHERE name = {q}), (SELECT id FROM {ref_table} WHERE name = {lit(n)}))"
                  for n in noms]
        out.append(',\n'.join(lignes) + ';')

    liaison('Technologies', 'airplane_tech', 'id_tech', 'tech', f['tech'])
    liaison('Armement', 'airplane_armement', 'id_armement', 'armement', f['armement'])
    liaison('Missions', 'airplane_missions', 'id_mission', 'missions', f['missions'])
    liaison('Conflits', 'airplane_wars', 'id_wars', 'wars', f['wars'])

    out += ['', '-- Enrichissement : strates 1 (fiche technique), 2 (motorisation),',
            '-- 3 (production) et 6 (médias). Filiations : voir zz_backfill_relations.sql.', 'BEGIN;', '',
            'UPDATE airplanes SET']
    blocs = []
    for titre, cols in SPECS:
        lignes = [f'  -- {titre}'] + [f'  {c:<17} = {lit(f[c])}' for c in cols]
        blocs.append(lignes)
    corps = []
    for i, lignes in enumerate(blocs):
        dernier_bloc = i == len(blocs) - 1
        for j, ligne in enumerate(lignes):
            fin = dernier_bloc and j == len(lignes) - 1
            corps.append(ligne if j == 0 or fin else ligne + ',')
        if not dernier_bloc:
            corps.append('')
    out += corps
    out += [f'WHERE name = {q};', '', 'COMMIT;', '',
            '-- [auto:006] furtivité (strate 4).',
            "-- 'aucune' = aucune mesure de réduction de signature radar, valeur explicite",
            '-- et non « inconnu ». Filiations : voir zz_backfill_relations.sql.',
            f"UPDATE airplanes SET stealth_level = {lit(f['stealth_level'])} WHERE name = {q};", '']
    return '\n'.join(out)


def slugs_du_lot(lot):
    lignes = (RACINE / 'manifest.tsv').read_text(encoding='utf-8').splitlines()[1:]
    return [l.split('\t')[1] for l in lignes if l.split('\t')[0] == lot]


def main():
    args = sys.argv[1:]
    seulement_verifier = '--check' in args
    args = [a for a in args if a != '--check']
    if args and args[0] == '--lot':
        args = slugs_du_lot(args[1])
    ref = referentiel()
    ko = 0
    for slug in args:
        chemin = RACINE / 'json' / f'{slug}.json'
        if not chemin.exists():
            print(f'-- {slug}: pas de JSON')
            ko += 1
            continue
        f = json.loads(chemin.read_text(encoding='utf-8'))
        erreurs = verifier(f, ref)
        if erreurs:
            ko += 1
            print(f'KO {slug}:\n   ' + '\n   '.join(erreurs))
            continue
        if not seulement_verifier:
            (SORTIE / f'{slug}.sql').write_text(rendre(f), encoding='utf-8', newline='\n')
        print(f'ok {slug}')
    sys.exit(1 if ko else 0)


if __name__ == '__main__':
    main()
