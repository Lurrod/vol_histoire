#!/usr/bin/env node
/* eslint-disable no-console */
/**
 * embed-translations.js
 *
 * Modifie en place les fichiers SQL source (db.sql + 68 fichiers d'avions)
 * pour incorporer les colonnes _en directement dans les CREATE TABLE et
 * les INSERT INTO. Comme ça, recréer la DB from scratch via les fichiers
 * source produit immédiatement une base bilingue FR/EN.
 *
 * Source des traductions : migrations/002, 003, 004 (déjà existantes).
 *
 * Usage : node tools/embed-translations.js
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', 'backend', 'db_backup');
const MIG = path.join(ROOT, 'migrations');

// ─────────────────────────────────────────────────────────────────────────────
// 1. PARSER LES MIGRATIONS POUR EXTRAIRE LES TRADUCTIONS
// ─────────────────────────────────────────────────────────────────────────────
function parseMigration(filePath) {
  const sql = fs.readFileSync(filePath, 'utf8');
  const result = {};
  const updateRegex = /UPDATE\s+(\w+)\s+SET\s+([\s\S]*?)\s+WHERE\s+(\w+)\s*=\s*'((?:''|[^'])*?)'\s*;/g;
  let m;
  while ((m = updateRegex.exec(sql)) !== null) {
    const table = m[1], setClause = m[2], keyCol = m[3];
    const keyVal = m[4].replace(/''/g, "'");
    if (!result[table]) result[table] = {};
    if (!result[table][keyCol]) result[table][keyCol] = {};
    const setRegex = /(\w+)\s*=\s*'((?:''|[^'])*?)'/g;
    const fields = {};
    let sm;
    while ((sm = setRegex.exec(setClause)) !== null) {
      fields[sm[1]] = sm[2].replace(/''/g, "'");
    }
    result[table][keyCol][keyVal] = fields;
  }
  const updateNumRegex = /UPDATE\s+(\w+)\s+SET\s+([\s\S]*?)\s+WHERE\s+(\w+)\s*=\s*(\d+)\s*;/g;
  while ((m = updateNumRegex.exec(sql)) !== null) {
    const table = m[1], setClause = m[2], keyCol = m[3], keyVal = m[4];
    if (!result[table]) result[table] = {};
    if (!result[table][keyCol]) result[table][keyCol] = {};
    const setRegex = /(\w+)\s*=\s*'((?:''|[^'])*?)'/g;
    const fields = {};
    let sm;
    while ((sm = setRegex.exec(setClause)) !== null) {
      fields[sm[1]] = sm[2].replace(/''/g, "'");
    }
    result[table][keyCol][keyVal] = fields;
  }
  return result;
}

console.log('Parsing migrations...');
const trans002 = parseMigration(path.join(MIG, '002_i18n_en_data.sql'));
const trans003 = parseMigration(path.join(MIG, '003_i18n_en_tech_armement.sql'));
const trans004 = parseMigration(path.join(MIG, '004_i18n_en_airplanes.sql'));

function deepMerge(target, source) {
  for (const k of Object.keys(source)) {
    if (target[k] && typeof target[k] === 'object' && !Array.isArray(target[k])) {
      deepMerge(target[k], source[k]);
    } else {
      target[k] = source[k];
    }
  }
  return target;
}
const allTrans = deepMerge(deepMerge({ ...trans002 }, trans003), trans004);

for (const table of Object.keys(allTrans)) {
  for (const keyCol of Object.keys(allTrans[table])) {
    const count = Object.keys(allTrans[table][keyCol]).length;
    console.log(`  ${table}.${keyCol} -> ${count} entrées`);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
function sqlEscape(s) {
  if (s == null) return 'NULL';
  return "'" + String(s).replace(/'/g, "''") + "'";
}

function stripQuotes(s) {
  if (typeof s !== 'string') return s;
  s = s.trim();
  if (s.startsWith("'") && s.endsWith("'")) {
    return s.slice(1, -1).replace(/''/g, "'");
  }
  return s;
}

function parseValues(s) {
  const result = [];
  let depth = 0, inString = false, buf = '';
  for (let i = 0; i < s.length; i++) {
    const ch = s[i], next = s[i + 1];
    if (inString) {
      buf += ch;
      if (ch === "'") {
        if (next === "'") { buf += next; i++; }
        else inString = false;
      }
    } else {
      if (ch === "'") { inString = true; buf += ch; }
      else if (ch === '(') { depth++; buf += ch; }
      else if (ch === ')') { depth--; buf += ch; }
      else if (ch === ',' && depth === 0) { result.push(buf.trim()); buf = ''; }
      else buf += ch;
    }
  }
  if (buf.trim()) result.push(buf.trim());
  return result;
}

function parseRows(s) {
  const result = [];
  let depth = 0, inString = false, buf = '';
  for (let i = 0; i < s.length; i++) {
    const ch = s[i], next = s[i + 1];
    if (inString) {
      buf += ch;
      if (ch === "'") {
        if (next === "'") { buf += next; i++; }
        else inString = false;
      }
    } else if (ch === "'") { inString = true; buf += ch; }
    else if (ch === '(') {
      if (depth === 0) buf = '';
      else buf += ch;
      depth++;
    } else if (ch === ')') {
      depth--;
      if (depth === 0) { result.push(buf); buf = ''; }
      else buf += ch;
    } else if (depth > 0) buf += ch;
  }
  return result;
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. AIRPLANES
// ─────────────────────────────────────────────────────────────────────────────
function transformAirplaneFile(filePath) {
  let sql = fs.readFileSync(filePath, 'utf8');
  const insertRegex = /INSERT\s+INTO\s+airplanes\s*\(([\s\S]*?)\)\s*VALUES\s*\(([\s\S]*?)\)\s*;/;
  const m = insertRegex.exec(sql);
  if (!m) {
    console.warn(`  SKIP ${path.basename(filePath)}: pas d'INSERT trouvé`);
    return false;
  }
  const cols = m[1].split(',').map((s) => s.trim()).filter(Boolean);
  if (cols.includes('name_en')) {
    console.log(`  SKIP ${path.basename(filePath)}: déjà migré`);
    return false;
  }
  const vals = parseValues(m[2]);
  if (vals.length !== cols.length) {
    console.error(`  ERROR ${path.basename(filePath)}: cols=${cols.length} vals=${vals.length}`);
    return false;
  }
  const row = {};
  cols.forEach((c, i) => { row[c] = vals[i]; });

  const nameFR = stripQuotes(row.name);
  const t = allTrans.airplanes && allTrans.airplanes.name && allTrans.airplanes.name[nameFR];
  if (!t) {
    console.warn(`  WARN ${path.basename(filePath)}: pas de traduction pour "${nameFR}"`);
    return false;
  }

  const newCols = [];
  const newVals = [];
  const TRANS = ['name', 'complete_name', 'little_description', 'description', 'status'];
  for (const c of cols) {
    newCols.push(c);
    newVals.push(row[c]);
    if (TRANS.includes(c)) {
      const enKey = c + '_en';
      newCols.push(enKey);
      let enVal;
      if (c === 'status') {
        const statusFR = stripQuotes(row.status);
        const stT = allTrans.airplanes && allTrans.airplanes.status && allTrans.airplanes.status[statusFR];
        enVal = stT && stT.status_en ? stT.status_en : null;
      } else {
        enVal = t[enKey];
      }
      newVals.push(enVal != null ? sqlEscape(enVal) : 'NULL');
    }
  }

  const newCols2 = newCols.map((c) => '    ' + c).join(',\n');
  const newVals2 = newVals.map((v) => '    ' + v).join(',\n');
  const newInsert = `INSERT INTO airplanes (\n${newCols2}\n) VALUES (\n${newVals2}\n);`;

  const newSql = sql.slice(0, m.index) + newInsert + sql.slice(m.index + m[0].length);
  fs.writeFileSync(filePath, newSql, 'utf8');
  console.log(`  OK ${path.basename(filePath)}`);
  return true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. db.sql
// ─────────────────────────────────────────────────────────────────────────────
function transformDbSql() {
  const filePath = path.join(ROOT, 'db.sql');
  let sql = fs.readFileSync(filePath, 'utf8');

  if (/name_en\s+VARCHAR/.test(sql)) {
    console.log('  SKIP db.sql: déjà migré');
    return false;
  }

  const tableSpecs = {
    countries:    [['name', 'VARCHAR(255)']],
    manufacturer: [['name', 'VARCHAR(255)']],
    type:         [['name', 'VARCHAR(50)'], ['description', 'VARCHAR(255)']],
    generation:   [['description', 'VARCHAR(255)']],
    tech:         [['name', 'VARCHAR(255)'], ['description', 'TEXT']],
    armement:     [['name', 'VARCHAR(255)'], ['description', 'TEXT']],
    wars:         [['name', 'VARCHAR(255)'], ['description', 'TEXT']],
    missions:     [['name', 'VARCHAR(255)'], ['description', 'TEXT']],
    airplanes:    [['name', 'VARCHAR(255)'], ['complete_name', 'VARCHAR(255)'],
                   ['little_description', 'VARCHAR(255)'], ['description', 'TEXT'],
                   ['status', 'VARCHAR(50)']],
  };

  for (const [table, cols] of Object.entries(tableSpecs)) {
    const ctRegex = new RegExp(`(CREATE TABLE(?: IF NOT EXISTS)?\\s+${table}\\s*\\([\\s\\S]*?)(\\n\\);)`, 'i');
    const m = ctRegex.exec(sql);
    if (!m) continue;
    let block = m[1];
    for (const [col, type] of cols) {
      const colRegex = new RegExp(`(\\b${col}\\s+[^,\\n]+)(,?\\n)`);
      const cm = colRegex.exec(block);
      if (cm && !block.includes(`${col}_en`)) {
        block = block.slice(0, cm.index + cm[1].length) +
                `,\n    ${col}_en ${type}` +
                block.slice(cm.index + cm[1].length);
      }
    }
    sql = sql.slice(0, m.index) + block + m[2] + sql.slice(m.index + m[0].length);
  }

  const refTables = {
    countries:    { keyCol: 'code', cols: ['name'] },
    manufacturer: { keyCol: 'code', cols: ['name'] },
    type:         { keyCol: 'name', cols: ['name', 'description'] },
    generation:   { keyCol: 'generation', cols: ['description'] },
    missions:     { keyCol: 'name', cols: ['name', 'description'] },
    wars:         { keyCol: 'name', cols: ['name', 'description'] },
    armement:     { keyCol: 'name', cols: ['name', 'description'] },
    tech:         { keyCol: 'name', cols: ['name', 'description'] },
  };

  for (const [table, spec] of Object.entries(refTables)) {
    const insRegex = new RegExp(`INSERT\\s+INTO\\s+${table}\\s*\\(([^)]+)\\)\\s*VALUES\\s*([\\s\\S]*?);`, 'i');
    const m = insRegex.exec(sql);
    if (!m) { console.log(`  SKIP db.sql ${table}: pas d'INSERT`); continue; }

    const cols = m[1].split(',').map((s) => s.trim());
    if (cols.includes('name_en') || cols.includes('description_en')) continue;

    const rows = parseRows(m[2]);

    const newCols = [];
    for (const c of cols) {
      newCols.push(c);
      if (spec.cols.includes(c)) newCols.push(c + '_en');
    }

    const tableTrans = allTrans[table] && allTrans[table][spec.keyCol];
    if (!tableTrans) { console.log(`  SKIP db.sql ${table}: pas de trad`); continue; }

    const newRows = rows.map((row) => {
      const vals = parseValues(row);
      if (vals.length !== cols.length) return null;
      const rowObj = {};
      cols.forEach((c, i) => { rowObj[c] = vals[i]; });
      const keyVal = stripQuotes(rowObj[spec.keyCol]);
      const t = tableTrans[keyVal] || tableTrans[String(keyVal)];

      const newVals = [];
      for (const c of cols) {
        newVals.push(rowObj[c]);
        if (spec.cols.includes(c)) {
          const enKey = c + '_en';
          const enVal = t && t[enKey];
          newVals.push(enVal != null ? sqlEscape(enVal) : 'NULL');
        }
      }
      return '(' + newVals.join(', ') + ')';
    }).filter(Boolean);

    const newInsert = `INSERT INTO ${table} (${newCols.join(', ')}) VALUES\n${newRows.join(',\n')};`;
    sql = sql.slice(0, m.index) + newInsert + sql.slice(m.index + m[0].length);
    console.log(`  OK db.sql: ${table} (${newRows.length} lignes)`);
  }

  fs.writeFileSync(filePath, sql, 'utf8');
  return true;
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN
// ─────────────────────────────────────────────────────────────────────────────
console.log('\n--- db.sql ---');
transformDbSql();

console.log('\n--- airplanes ---');
const files = fs.readdirSync(ROOT)
  .filter((f) => f.endsWith('.sql') && f !== 'db.sql')
  .sort();
let ok = 0, skip = 0, errors = 0;
for (const f of files) {
  const r = transformAirplaneFile(path.join(ROOT, f));
  if (r === true) ok++;
  else if (r === false) skip++;
  else errors++;
}
console.log(`\nTerminé : ${ok} OK, ${skip} skipped, ${errors} errors.`);
