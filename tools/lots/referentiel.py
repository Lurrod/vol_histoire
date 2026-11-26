"""Reporte les entrées `nouveau_referentiel` des fiches JSON dans db.sql et 001.

  python -I tools/lots/referentiel.py

Rejouable : le bloc généré est encadré de marqueurs et réécrit à chaque passe.
db.sql reçoit un INSERT … VALUES par table juste après la dernière
technologie (« Aile volante ») ; la section 2 de la migration reçoit la forme
INSERT … SELECT … WHERE NOT EXISTS, au même endroit.
"""
import json
import re
from pathlib import Path

RACINE = Path(__file__).resolve().parent.parent.parent
DB = RACINE / 'backend' / 'db_backup' / 'db.sql'
MIG = RACINE / 'backend' / 'migrations' / '001_mise_a_niveau.sql'
DEBUT = '-- >>> Lots 29 à 53 : référentiel ajouté (généré par .lots/tools/referentiel.py)'  # repère historique matché dans db.sql et 001 : ne pas modifier
FIN = '-- <<< Lots 29 à 53'
TABLES = ('tech', 'armement')


def lit(v: str | None) -> str:
    return 'NULL' if v is None else "'" + v.replace("'", "''") + "'"


def entrees() -> dict[str, list[dict]]:
    vus: dict[tuple[str, str], dict] = {}
    for p in sorted((RACINE / '.lots' / 'json').glob('*.json')):
        for e in json.loads(p.read_text(encoding='utf-8')).get('nouveau_referentiel') or []:
            vus.setdefault((e['table'], e['name']), e)
    par_table: dict[str, list[dict]] = {t: [] for t in TABLES}
    for (table, _), e in sorted(vus.items(), key=lambda kv: (kv[0][0], kv[0][1].lower())):
        if table not in par_table:
            raise SystemExit(f'table non prise en charge : {table}')
        par_table[table].append(e)
    return par_table


def nom_en(e: dict) -> str | None:
    # Convention du référentiel : name_en NULL quand il est identique au nom.
    return None if e.get('name_en') in (None, e['name']) else e['name_en']


def bloc_db(par_table: dict[str, list[dict]]) -> str:
    parts = [DEBUT]
    for t, lignes in par_table.items():
        if not lignes:
            continue
        vals = ',\n'.join(f"({lit(e['name'])}, {lit(nom_en(e))}, {lit(e['description'])}, {lit(e['description_en'])})"
                          for e in lignes)
        parts.append(f'INSERT INTO {t} (name, name_en, description, description_en) VALUES\n{vals};')
    parts.append(FIN)
    return '\n'.join(parts) + '\n'


def bloc_mig(par_table: dict[str, list[dict]]) -> str:
    parts = [DEBUT]
    for t, lignes in par_table.items():
        for e in lignes:
            parts.append(f'INSERT INTO {t} (name, name_en, description, description_en)\n'
                         f"SELECT {lit(e['name'])}, {lit(nom_en(e))}, {lit(e['description'])}, {lit(e['description_en'])}\n"
                         f"WHERE NOT EXISTS (SELECT 1 FROM {t} WHERE name = {lit(e['name'])});")
    parts.append(FIN)
    return '\n'.join(parts) + '\n'


def inserer(chemin: Path, ancre: str, bloc: str) -> None:
    s = chemin.read_text(encoding='utf-8')
    s = re.sub(re.escape(DEBUT) + r'.*?' + re.escape(FIN) + r'\n', '', s, flags=re.S)
    i = s.index(ancre)
    fin_ligne = s.index('\n', i) + 1
    chemin.write_text(s[:fin_ligne] + bloc + s[fin_ligne:], encoding='utf-8', newline='\n')


def main() -> None:
    par_table = entrees()
    inserer(DB, "('Aile volante', 'Flying wing',", bloc_db(par_table))
    inserer(MIG, "WHERE NOT EXISTS (SELECT 1 FROM tech WHERE name = 'Aile volante');", bloc_mig(par_table))
    for t, lignes in par_table.items():
        print(f'{t:9} {len(lignes)} : ' + ', '.join(e['name'] for e in lignes))


if __name__ == '__main__':
    main()
