"""Génère backend/db_backup/zz_conflits.sql depuis tools/lots/conflits/<slug>.json.

Pages de conflit étoffées (2026-11-22) : issue, contexte, récit aérien,
camps, rôle de chaque appareil, dates clés, sources.

Chaque JSON validé porte :
  war        : nom FR canonique (wars.name)
  outcome / context / narrative : {"fr", "en"}
  sides      : [{"key", "name": {fr, en}, "members": {fr, en}}]
  events     : [{"date", "precision", "title": {fr, en}, "body": {fr, en}, "aircraft", "source"}]
  aircraft   : [{"name", "side", "attested", "role": {fr, en}, "sources": [...], "note"}]
  sources    : [url, ...]
et, à côté, <slug>.api.json (réponse de /api/wars/<slug>) : la liste des
appareils RATTACHÉS au conflit, contre laquelle chaque nom est vérifié.

Le SQL produit est rejouable et n'écrit rien au second passage : toute
écriture est gardée par IS DISTINCT FROM (ou ON CONFLICT … WHERE).
Un appareil non attesté (attested=false) ne reçoit pas de rôle : il est
signalé dans le rapport, sa liaison reste à trancher.

Usage : python tools/lots/conflits_build.py [--check]
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = Path(__file__).resolve().parent / 'conflits'
OUT = ROOT / 'backend' / 'db_backup' / 'zz_conflits.sql'

DATE_RE = re.compile(r'^\d{4}-\d{2}-\d{2}$')
URL_RE = re.compile(r'^https?://\S+$')
PRECISIONS = {'day', 'month', 'year'}


def q(value: str | None) -> str:
    """Littéral SQL texte (NULL::text si vide)."""
    if value is None or str(value).strip() == '':
        return 'NULL::text'
    return "'" + str(value).replace("'", "''") + "'"


def urls(values: list[str] | None) -> str | None:
    clean = [u.strip() for u in (values or []) if URL_RE.match(u.strip())]
    return '\n'.join(dict.fromkeys(clean)) or None


def bi(obj: dict | None, lang: str) -> str | None:
    if not obj:
        return None
    value = obj.get(lang)
    return value.strip() if isinstance(value, str) and value.strip() else None


class Problems(list):
    def add(self, slug: str, msg: str) -> None:
        self.append(f'{slug} : {msg}')


def check(slug: str, data: dict, linked: set[str], problems: Problems) -> None:
    if not data.get('war'):
        problems.add(slug, 'clé « war » (nom FR canonique) absente')
    for field in ('outcome', 'context', 'narrative'):
        if not bi(data.get(field), 'fr'):
            problems.add(slug, f'{field}.fr vide')
    keys = [s.get('key') for s in data.get('sides', [])]
    if len(keys) != len(set(keys)) or not all(keys):
        problems.add(slug, f'clés de camp vides ou en double : {keys}')
    seen = set()
    for a in data.get('aircraft', []):
        name = a.get('name')
        if name not in linked:
            problems.add(slug, f'appareil non rattaché au conflit : {name!r}')
        if name in seen:
            problems.add(slug, f'appareil en double : {name!r}')
        seen.add(name)
        if a.get('attested') and not bi(a.get('role'), 'fr'):
            problems.add(slug, f'rôle vide : {name!r}')
        if a.get('side') not in (None, *keys):
            problems.add(slug, f'camp inconnu {a.get("side")!r} pour {name!r}')
        if len(bi(a.get('role'), 'fr') or '') > 420:
            problems.add(slug, f'rôle trop long ({len(a["role"]["fr"])} car.) : {name!r}')
    missing = linked - seen
    if missing:
        problems.add(slug, f'appareils rattachés sans entrée : {sorted(missing)}')
    titles = set()
    for e in data.get('events', []):
        if not DATE_RE.match(str(e.get('date', ''))):
            problems.add(slug, f'date invalide : {e.get("date")!r}')
        if e.get('precision') not in PRECISIONS:
            problems.add(slug, f'précision invalide : {e.get("precision")!r}')
        key = (e.get('date'), bi(e.get('title'), 'fr'))
        if key in titles:
            problems.add(slug, f'événement en double : {key}')
        titles.add(key)
        if e.get('aircraft') and e['aircraft'] not in linked:
            problems.add(slug, f'événement lié à un appareil non rattaché : {e["aircraft"]!r}')


def war_sql(data: dict) -> list[str]:
    war = q(data['war'])
    out: list[str] = [f"-- ── {data['war']} ──"]
    cols = ['outcome', 'outcome_en', 'context', 'context_en', 'narrative', 'narrative_en', 'sources']
    vals = [
        q(bi(data.get('outcome'), 'fr')), q(bi(data.get('outcome'), 'en')),
        q(bi(data.get('context'), 'fr')), q(bi(data.get('context'), 'en')),
        q(bi(data.get('narrative'), 'fr')), q(bi(data.get('narrative'), 'en')),
        q(urls(data.get('sources'))),
    ]
    sets = ',\n       '.join(f'{c} = {v}' for c, v in zip(cols, vals))
    out.append(
        f"UPDATE wars SET {sets}\n"
        f" WHERE name = {war}\n"
        f"   AND ({', '.join(cols)}) IS DISTINCT FROM ({', '.join(vals)});"
    )

    # Camps
    keys = []
    for pos, side in enumerate(data.get('sides', []), start=1):
        keys.append(q(side['key']))
        v = [q(side['key']), str(pos), q(bi(side.get('name'), 'fr')), q(bi(side.get('name'), 'en')),
             q(bi(side.get('members'), 'fr')), q(bi(side.get('members'), 'en'))]
        out.append(
            "INSERT INTO war_sides (war_id, side_key, position, name, name_en, members, members_en)\n"
            f"SELECT w.id, {', '.join(v)} FROM wars w WHERE w.name = {war}\n"
            "ON CONFLICT ON CONSTRAINT uq_war_sides_key DO UPDATE\n"
            "   SET position = EXCLUDED.position, name = EXCLUDED.name, name_en = EXCLUDED.name_en,\n"
            "       members = EXCLUDED.members, members_en = EXCLUDED.members_en\n"
            " WHERE (war_sides.position, war_sides.name, war_sides.name_en, war_sides.members, war_sides.members_en)\n"
            "       IS DISTINCT FROM (EXCLUDED.position, EXCLUDED.name, EXCLUDED.name_en, EXCLUDED.members, EXCLUDED.members_en);"
        )
    keep = ', '.join(keys) if keys else "''"
    out.append(
        f"DELETE FROM war_sides s USING wars w\n"
        f" WHERE s.war_id = w.id AND w.name = {war} AND s.side_key NOT IN ({keep});"
    )

    # Rôles des appareils
    for a in sorted(data.get('aircraft', []), key=lambda x: x['name']):
        if not a.get('attested'):
            continue
        side = (f"(SELECT s.id FROM war_sides s WHERE s.war_id = aw.id_wars AND s.side_key = {q(a['side'])})"
                if a.get('side') else 'NULL::int')
        role, role_en, src = q(bi(a.get('role'), 'fr')), q(bi(a.get('role'), 'en')), q(urls(a.get('sources')))
        out.append(
            f"UPDATE airplane_wars aw SET side_id = {side}, role = {role}, role_en = {role_en}, sources = {src}\n"
            f"  FROM airplanes a, wars w\n"
            f" WHERE aw.id_airplane = a.id AND aw.id_wars = w.id AND a.name = {q(a['name'])} AND w.name = {war}\n"
            f"   AND (aw.side_id, aw.role, aw.role_en, aw.sources) IS DISTINCT FROM ({side}, {role}, {role_en}, {src});"
        )

    # Dates clés
    pairs = []
    for e in sorted(data.get('events', []), key=lambda x: x['date']):
        title = bi(e.get('title'), 'fr')
        pairs.append(f"(DATE '{e['date']}', {q(title)})")
        plane = f"(SELECT id FROM airplanes WHERE name = {q(e['aircraft'])})" if e.get('aircraft') else 'NULL::int'
        v = [f"DATE '{e['date']}'", q(e['precision']), q(title), q(bi(e.get('title'), 'en')),
             q(bi(e.get('body'), 'fr')), q(bi(e.get('body'), 'en')), plane, q(urls([e.get('source') or '']))]
        out.append(
            "INSERT INTO war_events (war_id, event_date, date_precision, title, title_en, body, body_en, airplane_id, source)\n"
            f"SELECT w.id, {', '.join(v)} FROM wars w WHERE w.name = {war}\n"
            "ON CONFLICT ON CONSTRAINT uq_war_events DO UPDATE\n"
            "   SET date_precision = EXCLUDED.date_precision, title_en = EXCLUDED.title_en, body = EXCLUDED.body,\n"
            "       body_en = EXCLUDED.body_en, airplane_id = EXCLUDED.airplane_id, source = EXCLUDED.source\n"
            " WHERE (war_events.date_precision, war_events.title_en, war_events.body, war_events.body_en, war_events.airplane_id, war_events.source)\n"
            "       IS DISTINCT FROM (EXCLUDED.date_precision, EXCLUDED.title_en, EXCLUDED.body, EXCLUDED.body_en, EXCLUDED.airplane_id, EXCLUDED.source);"
        )
    keep_events = ', '.join(pairs) if pairs else "(DATE '0001-01-01', '')"
    out.append(
        f"DELETE FROM war_events e USING wars w\n"
        f" WHERE e.war_id = w.id AND w.name = {war}\n"
        f"   AND (e.event_date, e.title) NOT IN ({keep_events});"
    )
    return out


HEADER = """-- zz_conflits.sql — pages de conflit étoffées. FICHIER GÉNÉRÉ par
-- tools/lots/conflits_build.py depuis tools/lots/conflits/*.json : ne pas éditer
-- à la main.
--
-- Pour chaque conflit rédigé : issue, contexte et récit aérien (Markdown,
-- FR/EN), camps (war_sides), rôle et camp de chaque appareil rattaché
-- (airplane_wars), dates clés (war_events), sources (une URL par ligne).
--
-- Joué APRÈS les fiches et zz_backfill_relations.sql (il vise des liaisons
-- appareil-conflit existantes). Rejouable : toute écriture est gardée par
-- IS DISTINCT FROM, un second passage n'écrit rien.
"""


def main() -> int:
    sys.stdout.reconfigure(encoding='utf-8')
    check_only = '--check' in sys.argv
    problems = Problems()
    blocks: list[str] = []
    report: list[str] = []
    for path in sorted(SRC.glob('*.json')):
        if path.name.endswith('.api.json'):
            continue
        slug = path.stem
        data = json.loads(path.read_text(encoding='utf-8'))
        api_path = SRC / f'{slug}.api.json'
        if not api_path.exists():
            problems.add(slug, f'{api_path.name} absent')
            continue
        api = json.loads(api_path.read_text(encoding='utf-8'))
        linked = {a['name'] for a in api.get('airplanes', [])}
        check(slug, data, linked, problems)
        refused = [a for a in data.get('aircraft', []) if not a.get('attested')]
        report.append(f'{slug} : {len(data.get("aircraft", [])) - len(refused)} rôles, '
                      f'{len(data.get("events", []))} dates, {len(data.get("sides", []))} camps'
                      + (f' ; non attestés : {", ".join(a["name"] for a in refused)}' if refused else ''))
        blocks.append('\n'.join(war_sql(data)))
    print('\n'.join(report))
    if problems:
        print('\nPROBLÈMES :\n  ' + '\n  '.join(problems))
        return 1
    if check_only:
        return 0
    sql = HEADER + '\nBEGIN;\n\n' + '\n\n'.join(blocks) + '\n\nCOMMIT;\n'
    OUT.write_text(sql, encoding='utf-8', newline='\n')
    print(f'\n→ {OUT.relative_to(ROOT)} ({len(blocks)} conflits)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
