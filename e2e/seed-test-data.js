#!/usr/bin/env node
/**
 * Seed des données de référence + avions pour les E2E.
 * Insère un jeu minimal mais complet : countries, manufacturers, generations,
 * types, et 5 avions avec relations.
 *
 * Usage : node e2e/seed-test-data.js
 * Idempotent : utilise ON CONFLICT DO NOTHING.
 */

try {
  require('dotenv').config({ path: require('path').join(__dirname, '../backend/.env') });
} catch { /* dotenv optionnel — env vars peuvent venir directement du shell */ }

const path = require('path');
const Module = require('module');
const backendNodeModules = path.join(__dirname, '../backend/node_modules');
Module.globalPaths.push(backendNodeModules);
const { Pool } = require(path.join(backendNodeModules, 'pg'));

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

async function seed() {
  // ── Countries ──────────────────────────────────────────────
  await pool.query(`
    INSERT INTO countries (id, name, code) VALUES
      (1, 'France',         'FRA'),
      (2, 'United States',  'USA'),
      (3, 'Russia',         'RUS'),
      (4, 'United Kingdom', 'GBR'),
      (5, 'China',          'CHN')
    ON CONFLICT (id) DO NOTHING
  `);
  await pool.query("SELECT setval('countries_id_seq', GREATEST((SELECT MAX(id) FROM countries), 1))");

  // ── Manufacturers ──────────────────────────────────────────
  await pool.query(`
    INSERT INTO manufacturer (id, name, country_id, code) VALUES
      (1, 'Dassault Aviation', 1, 'DAS'),
      (2, 'Lockheed Martin',   2, 'LMT'),
      (3, 'Boeing',            2, 'BOE'),
      (4, 'Sukhoi',            3, 'SUK'),
      (5, 'BAE Systems',       4, 'BAE')
    ON CONFLICT (id) DO NOTHING
  `);
  await pool.query("SELECT setval('manufacturer_id_seq', GREATEST((SELECT MAX(id) FROM manufacturer), 1))");

  // ── Generations ────────────────────────────────────────────
  await pool.query(`
    INSERT INTO generation (id, generation, description) VALUES
      (1, 1, '1ère génération — premiers jets'),
      (2, 2, '2e génération — supersoniques'),
      (3, 3, '3e génération — multirôle naissant'),
      (4, 4, '4e génération — fly-by-wire'),
      (5, 5, '5e génération — furtivité')
    ON CONFLICT (id) DO NOTHING
  `);
  await pool.query("SELECT setval('generation_id_seq', GREATEST((SELECT MAX(id) FROM generation), 1))");

  // ── Types ──────────────────────────────────────────────────
  await pool.query(`
    INSERT INTO type (id, name, description) VALUES
      (1, 'Chasseur',     'Avion de chasse air-air'),
      (2, 'Multirôle',    'Air-air et air-sol'),
      (3, 'Bombardier',   'Frappes air-sol stratégiques'),
      (4, 'Intercepteur', 'Interception haute altitude')
    ON CONFLICT (id) DO NOTHING
  `);
  await pool.query("SELECT setval('type_id_seq', GREATEST((SELECT MAX(id) FROM type), 1))");

  // ── Airplanes ──────────────────────────────────────────────
  await pool.query(`
    INSERT INTO airplanes (
      id, name, complete_name, little_description, image_url, description,
      country_id, date_concept, date_first_fly, date_operationel,
      max_speed, max_range, id_manufacturer, id_generation, type, status, weight
    ) VALUES
      (1, 'Rafale', 'Dassault Rafale', 'Multirôle français',
       'https://i.postimg.cc/test/rafale.jpg', 'Chasseur multirôle français de 4ème génération.',
       1, '1986-01-01', '1986-07-04', '2001-06-18',
       1.8, 3700, 1, 4, 2, 'En service', 9500),

      (2, 'F-22 Raptor', 'Lockheed Martin F-22 Raptor', 'Furtif américain',
       'https://i.postimg.cc/test/f22.jpg', 'Premier chasseur de 5e génération.',
       2, '1981-01-01', '1997-09-07', '2005-12-15',
       2.25, 2960, 2, 5, 1, 'En service', 19700),

      (3, 'Su-27', 'Sukhoi Su-27', 'Chasseur soviétique',
       'https://i.postimg.cc/test/su27.jpg', 'Chasseur de supériorité aérienne soviétique.',
       3, '1969-01-01', '1977-05-20', '1985-01-01',
       2.35, 3530, 4, 4, 1, 'En service', 16380),

      (4, 'Mirage 2000', 'Dassault Mirage 2000', 'Multirôle français 4e gen',
       'https://i.postimg.cc/test/mirage2000.jpg', 'Multirôle français de 4ème génération.',
       1, '1972-01-01', '1978-03-10', '1984-07-02',
       2.2, 1550, 1, 4, 2, 'En service', 7500),

      (5, 'F-35 Lightning II', 'Lockheed Martin F-35 Lightning II', 'Furtif multirôle',
       'https://i.postimg.cc/test/f35.jpg', 'Multirôle furtif américain de 5ème génération.',
       2, '1992-01-01', '2006-12-15', '2015-07-31',
       1.6, 2220, 2, 5, 2, 'En service', 13290)
    ON CONFLICT (id) DO NOTHING
  `);
  await pool.query("SELECT setval('airplanes_id_seq', GREATEST((SELECT MAX(id) FROM airplanes), 1))");

  // ── Compteurs ──────────────────────────────────────────────
  const counts = await pool.query(`
    SELECT
      (SELECT COUNT(*) FROM countries)    AS countries,
      (SELECT COUNT(*) FROM manufacturer) AS manufacturers,
      (SELECT COUNT(*) FROM generation)   AS generations,
      (SELECT COUNT(*) FROM type)         AS types,
      (SELECT COUNT(*) FROM airplanes)    AS airplanes
  `);
  const r = counts.rows[0];
  console.log(`Seed donnees OK : ${r.countries} pays, ${r.manufacturers} constructeurs, ${r.generations} generations, ${r.types} types, ${r.airplanes} avions`);
}

seed()
  .then(() => { console.log('Seed donnees termine.'); process.exit(0); })
  .catch((err) => { console.error('Erreur seed donnees:', err.message); process.exit(1); })
  .finally(() => pool.end());
