#!/usr/bin/env bash
# Compare une installation neuve et le chemin de migration de production.
#
#   bash tools/lots/valider.sh
#
# vh_lots_neuve : db.sql puis chaque db_backup/*.sql dans l'ordre du glob
#                 (boucle du README : fiches, frise, zz en dernier).
# vh_lots_migr  : installation neuve de l'état de HEAD (434 fiches), puis
#                 001_mise_a_niveau.sql + charger-fiches.js + zz du dépôt de travail.
# Les deux catalogues sont exportés en texte (identifiants remplacés par des
# noms) et comparés ligne à ligne.
set -euo pipefail
RACINE="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$RACINE"
set -a; . backend/.env; set +a
export PGHOST="$DB_HOST" PGPORT="$DB_PORT" PGUSER="$DB_USER" PGPASSWORD="$DB_PASSWORD"
SORTIE=.lots/valid  # sorties de travail, hors git
mkdir -p "$SORTIE"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

recreer() {
  psql -q -d postgres -c "DROP DATABASE IF EXISTS $1" -c "CREATE DATABASE $1" >/dev/null
}

installer() { # base dossier journal
  psql -q -d "$1" -f "$2/db.sql" >"$3" 2>&1
  for f in "$2"/*.sql; do
    [ "$(basename "$f")" = db.sql ] && continue
    psql -q -d "$1" -f "$f" >>"$3" 2>&1
  done
}

exporter() { # base fichier
  psql -q -A -t -d "$1" >"$2" <<'SQL'
SELECT 'A|' || a.name || '|' || (to_jsonb(a) - 'id' - 'created_at' - 'updated_at' - 'search_vector'
       - 'id_manufacturer' - 'country_id' - 'type' - 'id_generation'
       - 'predecessor_id' - 'successor_id' - 'rival_id'
       || jsonb_build_object('m', m.code, 'c', c.code, 't', t.name, 'g', g.generation,
                             'p', p.name, 's', s.name, 'r', r.name))::text
FROM airplanes a
LEFT JOIN manufacturer m ON m.id = a.id_manufacturer
LEFT JOIN countries c ON c.id = a.country_id
LEFT JOIN type t ON t.id = a.type
LEFT JOIN generation g ON g.id = a.id_generation
LEFT JOIN airplanes p ON p.id = a.predecessor_id
LEFT JOIN airplanes s ON s.id = a.successor_id
LEFT JOIN airplanes r ON r.id = a.rival_id
ORDER BY 1;
SELECT 'T|' || a.name || '|' || x.name FROM airplane_tech l JOIN airplanes a ON a.id = l.id_airplane JOIN tech x ON x.id = l.id_tech ORDER BY 1;
SELECT 'R|' || a.name || '|' || x.name FROM airplane_armement l JOIN airplanes a ON a.id = l.id_airplane JOIN armement x ON x.id = l.id_armement ORDER BY 1;
SELECT 'M|' || a.name || '|' || x.name FROM airplane_missions l JOIN airplanes a ON a.id = l.id_airplane JOIN missions x ON x.id = l.id_mission ORDER BY 1;
SELECT 'W|' || a.name || '|' || x.name FROM airplane_wars l JOIN airplanes a ON a.id = l.id_airplane JOIN wars x ON x.id = l.id_wars ORDER BY 1;
SELECT 'C|' || (to_jsonb(x) - 'id')::text FROM countries x ORDER BY 1;
SELECT 'F|' || (to_jsonb(x) - 'id' - 'country_id')::text || (SELECT code FROM countries WHERE id = x.country_id) FROM manufacturer x ORDER BY 1;
SELECT 'X|' || (to_jsonb(x) - 'id')::text FROM tech x ORDER BY 1;
SELECT 'Y|' || (to_jsonb(x) - 'id')::text FROM armement x ORDER BY 1;
SELECT 'N|' || (to_jsonb(x) - 'id')::text FROM missions x ORDER BY 1;
SELECT 'P|' || (to_jsonb(x) - 'id')::text FROM type x ORDER BY 1;
SELECT 'G|' || (to_jsonb(x) - 'id')::text FROM generation x ORDER BY 1;
SELECT 'K|' || (to_jsonb(x) - 'id' - 'country_id')::text || coalesce((SELECT code FROM countries WHERE id = x.country_id), '') FROM wars x ORDER BY 1;
SELECT 'E|' || (to_jsonb(e) - 'id' - 'created_at' - 'updated_at' - 'airplane_id')::text || coalesce(a.name, '') FROM timeline_events e LEFT JOIN airplanes a ON a.id = e.airplane_id ORDER BY 1;
SQL
}

echo "== installation neuve"
recreer vh_lots_neuve
installer vh_lots_neuve backend/db_backup "$SORTIE/neuve.log"

echo "== chemin de migration (HEAD -> dépôt de travail)"
git archive HEAD backend/db_backup | tar -x -C "$TMP"
recreer vh_lots_migr
installer vh_lots_migr "$TMP/backend/db_backup" "$SORTIE/head.log"
psql -q -v ON_ERROR_STOP=1 -d vh_lots_migr -f backend/migrations/001_mise_a_niveau.sql >"$SORTIE/migr.log" 2>&1
DB_NAME=vh_lots_migr node backend/migrations/charger-fiches.js >>"$SORTIE/migr.log" 2>&1
for zz in zz_backfill_relations zz_conflits zz_specs_strate7; do  # ordre de la production
  psql -q -d vh_lots_migr -f "backend/db_backup/$zz.sql" >>"$SORTIE/migr.log" 2>&1
done

echo "== contrôles"
for b in vh_lots_neuve vh_lots_migr; do
  echo "-- $b : $(psql -A -t -d $b -c 'SELECT count(*) FROM airplanes') fiches"
  psql -A -t -d $b -c "SELECT '   FK NULL : ' || name FROM airplanes WHERE id_manufacturer IS NULL OR country_id IS NULL OR type IS NULL OR id_generation IS NULL"
done
echo "-- erreurs SQL (installation neuve) :"
grep -n "ERROR\|ERREUR" "$SORTIE/neuve.log" | head -20 || true
echo "-- erreurs SQL (migration) :"
grep -n "ERROR\|ERREUR" "$SORTIE/migr.log" | head -20 || true

exporter vh_lots_neuve "$SORTIE/neuve.txt"
exporter vh_lots_migr "$SORTIE/migr.txt"
echo "-- lignes comparées : $(wc -l <"$SORTIE/neuve.txt")"
if diff -q "$SORTIE/neuve.txt" "$SORTIE/migr.txt" >/dev/null; then
  echo "IDENTIQUES"
else
  echo "ÉCARTS :"
  diff "$SORTIE/neuve.txt" "$SORTIE/migr.txt" | head -40
fi
