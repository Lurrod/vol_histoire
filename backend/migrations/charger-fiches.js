'use strict';

// Charge dans une base déjà installée les fiches de backend/db_backup/ qui n'y
// sont pas encore, et rien d'autre.
//
// `airplanes.name` n'a pas de contrainte d'unicité : rejouer une fiche déjà
// présente y créerait un doublon silencieux. Ce script lit donc le nom de
// l'appareil dans chaque fichier et saute ceux que la base contient déjà, ce
// qui le rend rejouable sans risque.
//
// À lancer APRÈS backend/migrations/001_mise_a_niveau.sql (les fiches
// référencent des constructeurs, types et colonnes qu'il apporte) et AVANT
// backend/db_backup/zz_backfill_relations.sql (qui exige tous les appareils).
//
//   node backend/migrations/charger-fiches.js            # charge
//   node backend/migrations/charger-fiches.js --dry-run  # liste sans rien écrire

const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

const DOSSIER = path.join(__dirname, '..', 'db_backup');
const IGNORES = new Set(['db.sql', 'zz_backfill_relations.sql', 'timeline_events.sql']);
const SIMULATION = process.argv.includes('--dry-run');

// Le nom de l'appareil est la première valeur du INSERT INTO airplanes.
function nomAppareil(sql) {
  const m = sql.match(/\)\s*VALUES\s*\(\s*\n\s*'((?:[^']|'')*)'/);
  return m ? m[1].replace(/''/g, "'") : null;
}

async function main() {
  const fichiers = fs.readdirSync(DOSSIER)
    .filter((f) => f.endsWith('.sql') && !IGNORES.has(f))
    .sort();

  const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
  });

  const { rows } = await pool.query('SELECT name FROM airplanes');
  const presents = new Set(rows.map((r) => r.name));
  console.log(`${presents.size} appareil(s) déjà en base, ${fichiers.length} fiche(s) sur disque.`);

  let charges = 0;
  let sautes = 0;
  const echecs = [];

  for (const fichier of fichiers) {
    const sql = fs.readFileSync(path.join(DOSSIER, fichier), 'utf8');
    const nom = nomAppareil(sql);

    if (!nom) {
      echecs.push([fichier, 'nom introuvable dans le fichier']);
      continue;
    }
    if (presents.has(nom)) {
      sautes += 1;
      continue;
    }
    if (SIMULATION) {
      console.log(`  + ${fichier.padEnd(28)} ${nom}`);
      charges += 1;
      continue;
    }

    // Une fiche par transaction : un échec n'entame pas les autres.
    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      await client.query(sql);
      await client.query('COMMIT');
      charges += 1;
    } catch (err) {
      await client.query('ROLLBACK');
      echecs.push([fichier, err.message]);
    } finally {
      client.release();
    }
  }

  console.log(`${charges} chargée(s)${SIMULATION ? ' (simulation)' : ''}, ${sautes} déjà présente(s).`);
  for (const [fichier, message] of echecs) console.error(`  ÉCHEC ${fichier} : ${message}`);

  await pool.end();
  if (echecs.length) process.exit(1);

  if (!SIMULATION && charges) {
    console.log('\nÉtape suivante — les filiations, une fois tous les appareils présents :');
    console.log('  psql -f backend/db_backup/zz_backfill_relations.sql');
  }
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
