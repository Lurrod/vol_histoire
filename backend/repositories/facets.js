'use strict';

// -----------------------------------------------------------------------------
// Accès aux données — compteurs de facettes du hangar.
//
// Chaque groupe est compté en appliquant tous les AUTRES filtres actifs (jamais
// le sien) : choisir « Vietnam » ne réduit pas la liste des conflits à
// « Vietnam » seul. Conflits et missions sont des relations n-n : un appareil
// compte une fois par conflit auquel il est rattaché, d'où les jointures dédiées
// des deux dernières requêtes et les sous-requêtes EXISTS pour les filtres.
// -----------------------------------------------------------------------------

const BASE = `
        FROM airplanes a
        LEFT JOIN countries c ON a.country_id = c.id
        LEFT JOIN generation g ON a.id_generation = g.id
        LEFT JOIN type t ON a.type = t.id`;

/**
 * WHERE des filtres actifs, sauf celui du groupe compté (`exclude`).
 * @returns {{ params: Array, where: string }}
 */
function buildConditions(filters, exclude) {
  const params = [];
  const conds = [];
  if (filters.country && exclude !== 'country') {
    params.push(filters.country);
    conds.push(`c.name = $${params.length}`);
  }
  if (filters.generation && exclude !== 'generation') {
    params.push(Number(filters.generation));
    conds.push(`g.generation = $${params.length}`);
  }
  if (filters.type && exclude !== 'type') {
    params.push(filters.type);
    conds.push(`t.name = $${params.length}`);
  }
  if (filters.war && exclude !== 'war') {
    params.push(filters.war);
    conds.push(`EXISTS (SELECT 1 FROM airplane_wars fw JOIN wars fwn ON fwn.id = fw.id_wars
        WHERE fw.id_airplane = a.id AND fwn.name = $${params.length})`);
  }
  if (filters.mission && exclude !== 'mission') {
    params.push(filters.mission);
    conds.push(`EXISTS (SELECT 1 FROM airplane_missions fm JOIN missions fmn ON fmn.id = fm.id_mission
        WHERE fm.id_airplane = a.id AND fmn.name = $${params.length})`);
  }
  return { params, where: conds.length ? ' WHERE ' + conds.join(' AND ') : '' };
}

/**
 * Lignes { k, n } de chaque groupe, en parallèle.
 * @param {{ country?: string, generation?: string, type?: string, war?: string, mission?: string }} filters
 */
async function countAll(db, filters) {
  const ctryQ = buildConditions(filters, 'country');
  const genQ = buildConditions(filters, 'generation');
  const typQ = buildConditions(filters, 'type');
  const warQ = buildConditions(filters, 'war');
  const misQ = buildConditions(filters, 'mission');

  const [countries, generations, types, wars, missions] = await Promise.all([
    db.query(
      `SELECT c.name AS k, COUNT(*)::int AS n ${BASE}${ctryQ.where}
           GROUP BY c.name ORDER BY c.name`,
      ctryQ.params
    ),
    db.query(
      `SELECT g.generation AS k, COUNT(*)::int AS n ${BASE}${genQ.where}
           GROUP BY g.generation ORDER BY g.generation`,
      genQ.params
    ),
    db.query(
      `SELECT t.name AS k, COUNT(*)::int AS n ${BASE}${typQ.where}
           GROUP BY t.name ORDER BY t.name`,
      typQ.params
    ),
    db.query(
      `SELECT w.name AS k, COUNT(*)::int AS n ${BASE}
           JOIN airplane_wars aw ON aw.id_airplane = a.id
           JOIN wars w ON w.id = aw.id_wars${warQ.where}
           GROUP BY w.name ORDER BY w.name`,
      warQ.params
    ),
    db.query(
      `SELECT m.name AS k, COUNT(*)::int AS n ${BASE}
           JOIN airplane_missions am ON am.id_airplane = a.id
           JOIN missions m ON m.id = am.id_mission${misQ.where}
           GROUP BY m.name ORDER BY m.name`,
      misQ.params
    ),
  ]);

  return {
    countries: countries.rows,
    generations: generations.rows,
    types: types.rows,
    wars: wars.rows,
    missions: missions.rows,
  };
}

module.exports = { buildConditions, countAll };
